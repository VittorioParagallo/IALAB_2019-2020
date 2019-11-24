package uncertainty;

import aima.core.probability.*;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.FiniteNode;
import aima.core.probability.bayes.Node;
import aima.core.probability.proposition.AssignmentProposition;
import aima.core.probability.util.ProbabilityTable;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javafx.util.Pair;
/**
 *
 * @author tommy
 * 
 * This class implements MPE, MAP and VariableElimination
 */
public class Inference {    
    FinalAssignment mpeass;
    
    public MPEAssignment MPE(AssignmentProposition[] e, BayesianNetwork bn) {              
        Set<RandomVariable> hidden = new HashSet<RandomVariable>();
        List<RandomVariable> VARS = new ArrayList<RandomVariable>();                
        Set<RandomVariable> map = null;
        calculateVariables(map, e, bn, hidden, VARS);
        
        mpeass = new FinalAssignment();
 
        List<Factor> factors = new ArrayList<Factor>();
        
        //maxOut of every hidden variable
        for (RandomVariable var : order(VARS)) {                
                factors.add(0, makeFactor(var, e, bn));
                
                if (hidden.contains(var)) {
                        factors = maxOut(var, factors, bn);
                }                
        }
        Factor product = pointwiseProduct(factors);
        
        //mpeass.printMap();

        MPEAssignment finalAssignment = mpeass.finalCalculateAssignment(hidden);
        
        System.out.printf("\nFinal Factor %f\n",product.getValues()[0]);
        System.out.println("\nFinal assignment:\n"+finalAssignment);        
        
        double norm = 1;
        //computing normalization constant
        if(e.length > 0){            
            norm = calcNormVar(bn, e);     
            
            //System.out.print("\nNORM: "+new DecimalFormat("#.##############").format(norm));
            //System.out.print("\nFinal Factor NORMALIZED: "+new DecimalFormat("#.##############").format(product.getValues()[0]/norm));                    
        }
        
        finalAssignment.setProbability(product, norm);

        return finalAssignment;
    }
    
    public MPEAssignment MAP(Set<RandomVariable> map, AssignmentProposition[] e, BayesianNetwork bn) {                                              
        Set<RandomVariable> hidden = new HashSet<RandomVariable>();
        List<RandomVariable> VARS = new ArrayList<RandomVariable>();                

        calculateVariables(map, e, bn, hidden, VARS);
        
        mpeass = new FinalAssignment();

        List<Factor> factors = new ArrayList<Factor>();
        
        List<RandomVariable> maxvars = order(VARS);
        
        //VARIABILI NON MAP sum out
        for (RandomVariable var : order(VARS)) {
                
                factors.add(0, makeFactor(var, e, bn));
                if(!map.contains(var)){
                    //System.out.println("Var non MAP "+var);                    
                    
                    if (hidden.contains(var)) {                        
                        factors = sumOut(var, factors);
                    }
                    maxvars.remove(var);
                    //System.out.println("NON MAP "+factors);                    
                }
        }
        
        //System.out.println("FACTORS AFTER NON MAP "+factors);
        
        //VARIABILI MAP max out
        for (RandomVariable var: maxvars){
            //System.out.println("Var MAP "+var);
            //factors.add(0, makeFactor(var, e, bn));
            if (hidden.contains(var)) {
                    if(map.contains(var)){
                        factors = maxOut(var, factors, bn);
                    }
            }
            //System.out.println("NON MAP "+factors);
        }        
        Factor product = pointwiseProduct(factors);
        
        //mpeass.printMap();
        
        MPEAssignment finalAssignment = mpeass.finalCalculateAssignment(map);
        
        System.out.print("\nFinal Factor: "+new DecimalFormat("#.###################").format(product.getValues()[0]));        
        System.out.println("\nFinal assignment:\n"+finalAssignment);
        
        double norm = 1;
        //computing normalization constant
        if(e.length > 0){            
            norm = calcNormVar(bn, e);     
            
            //System.out.print("\nNORM: "+new DecimalFormat("#.##############").format(norm));
            //System.out.print("\nFinal Factor NORMALIZED: "+new DecimalFormat("#.##############").format(product.getValues()[0]/norm));                    
        }
        
        finalAssignment.setProbability(product, norm);

        return finalAssignment;
    }
    
    public MPEAssignment testMAP(Set<RandomVariable> map, AssignmentProposition[] e, BayesianNetwork bn, boolean opt) {                                              
        Set<RandomVariable> hidden = new HashSet<RandomVariable>();
        List<RandomVariable> VARS = new ArrayList<RandomVariable>();                
        
        if(opt){
            calculateVariables(map, e, bn, hidden, VARS);
        } else {
            Set<RandomVariable> m = null;
            calculateVariables(m, e, bn, hidden, VARS);
        }
        
        mpeass = new FinalAssignment();

        List<Factor> factors = new ArrayList<Factor>();
        
        List<RandomVariable> maxvars = order(VARS);
        
        //VARIABILI NON MAP sum out
        for (RandomVariable var : order(VARS)) {
                
                factors.add(0, makeFactor(var, e, bn));
                if(!map.contains(var)){
                    //System.out.println("Var non MAP "+var);                    
                    
                    if (hidden.contains(var)) {                        
                        factors = sumOut(var, factors);
                    }
                    maxvars.remove(var);
                    //System.out.println("NON MAP "+factors);                    
                }
        }
        
        //System.out.println("FACTORS AFTER NON MAP "+factors);
        
        //VARIABILI MAP max out
        for (RandomVariable var: maxvars){
            //System.out.println("Var MAP "+var);
            //factors.add(0, makeFactor(var, e, bn));
            if (hidden.contains(var)) {
                    if(map.contains(var)){
                        factors = maxOut(var, factors, bn);
                    }
            }
            //System.out.println("NON MAP "+factors);
        }        
        Factor product = pointwiseProduct(factors);
        
        //mpeass.printMap();
        
        MPEAssignment finalAssignment = mpeass.finalCalculateAssignment(map);
        
        System.out.print("\nFinal Factor: "+new DecimalFormat("#.###################").format(product.getValues()[0]));        
        System.out.println("\nFinal assignment:\n"+finalAssignment);
        
        double norm = 1;
        //computing normalization constant
        //if(e.length > 0){            
          //  norm = calcNormVar(bn, e);     
            
            //System.out.print("\nNORM: "+new DecimalFormat("#.##############").format(norm));
            //System.out.print("\nFinal Factor NORMALIZED: "+new DecimalFormat("#.##############").format(product.getValues()[0]/norm));                    
        //}
        
        finalAssignment.setProbability(product, norm);

        return finalAssignment;
    }
    
    public CategoricalDistribution eliminationAsk(final RandomVariable[] X, final AssignmentProposition[] e, final BayesianNetwork bn) {
        
        ProbabilityTable _identity = new ProbabilityTable(new double[] { 1.0 });
        Set<RandomVariable> hidden = new HashSet<RandomVariable>();
        List<RandomVariable> VARS = new ArrayList<RandomVariable>();
        calculateVariables(X, e, bn, hidden, VARS);

        List<Factor> factors = new ArrayList<Factor>();

        for (RandomVariable var : order(VARS)) {
                factors.add(0, makeFactor(var, e, bn));

                if (hidden.contains(var)) {
                        factors = sumOut(var, factors);
                }
        }

        Factor product = pointwiseProduct(factors);
        
        return ((ProbabilityTable) product.pointwiseProductPOS(_identity, X))
                        .normalize();
    }
        
    //this method extract hidden variables
    private void calculateVariables(Set<RandomVariable> map, final AssignmentProposition[] e, final BayesianNetwork bn,
                    Set<RandomVariable> hidden, Collection<RandomVariable> bnVARS) {
            
            bnVARS.addAll(bn.getVariablesInTopologicalOrder());
            hidden.addAll(bnVARS);
            
            for (AssignmentProposition ap : e) {
                    hidden.removeAll(ap.getScope());
            }                         
            
            //optimization that eliminate not ancestor of variable map or evidence
            if(map != null){
                List<RandomVariable> rmList = new ArrayList<RandomVariable>();
                for (RandomVariable rv : bnVARS) {
                    if(!isAncestor(rv,map,e,bn)){
                        rmList.add(rv);
                    }                    
                }
                hidden.removeAll(rmList);
                bnVARS.removeAll(rmList);
            }                       
            
            return;
    }
    
    //this is a calculateVariable that deletes also query variable its used by elimination ask
    private void calculateVariables(RandomVariable[] X, final AssignmentProposition[] e, final BayesianNetwork bn,
                    Set<RandomVariable> hidden, Collection<RandomVariable> bnVARS) {
            
            bnVARS.addAll(bn.getVariablesInTopologicalOrder());
            hidden.addAll(bnVARS);
            
            for (RandomVariable x : X) {
                hidden.remove(x);
            }
            
            for (AssignmentProposition ap : e) {
                    hidden.removeAll(ap.getScope());
            }                         
            
            Set<RandomVariable> map = new HashSet<RandomVariable>();
            
            for(int i=0; i<X.length; i++){
                map.add(X[i]);
            }
            
            List<RandomVariable> rmList = new ArrayList<RandomVariable>();
            for (RandomVariable rv : bnVARS) {
                if(!isAncestor(rv,map,e,bn)){
                    rmList.add(rv);
                }                    
            }
            hidden.removeAll(rmList);
            bnVARS.removeAll(rmList);                        
            
            return;
    }
    
    //this method tells if a variable is an ancestor of a group of variables
    private boolean isAncestor(RandomVariable rv, Set<RandomVariable> map, AssignmentProposition[] evidence, BayesianNetwork bn){
        //boolean ancestor = false;
        //System.out.println("ISANCESTOR "+rv);
        Node nodeRv = bn.getNode(rv);        
        
        //check if rv is ancestor of a map variables
        for(RandomVariable m:map){
            Node mapRv = bn.getNode(m);
            
            if(nodeRv == mapRv){
                return true;
            } else if(isInParents(nodeRv, mapRv)){
                return true;                
            }
        }
        
        //check if rv is ancestor of an evidence variable
        for(int i=0; i<evidence.length; i++){
             Node eRv = bn.getNode(evidence[i].getTermVariable());
            
            if(nodeRv == eRv){
                return true;
            } else if(isInParents(nodeRv, eRv)){
                return true;                
            }
        }
        
        return false;
    }
    
    //visits the graph bottom up to find the ancestor
    private boolean isInParents(Node nodeRv, Node parRv){
        List<Node> parents = new ArrayList<Node>();
        List<Node> visited = new ArrayList<Node>();
        
        parents.addAll(parRv.getParents());        
       
        while(!parents.isEmpty()){
            List<Node> rmList = new ArrayList<Node>();
            List<Node> getParList = new ArrayList<Node>();

            for(Node p:parents){
                if(p==nodeRv){
                    return true;
                } else if (p.isRoot()||visited.contains(p)){
                    rmList.add(p);
                } else {
                    getParList.add(p);
                    visited.add(p);
                }
            }

            for(Node p:getParList){
                parents.addAll(p.getParents());
            }

            parents.removeAll(rmList);

            rmList.clear();
            getParList.clear();
        }
        
        return false;
    }

    //le variabili vengono messe in ordine inverso in questo modo
    //la rete viene visitata dal basso verso l'alto e ogni fattore
    //dipendente è già stato calcolato
    private List<RandomVariable> order(Collection<RandomVariable> vars) {
            // Note: Trivial Approach:
            // For simplicity just return in the reverse order received,
            // i.e. received will be the default topological order for
            // the Bayesian Network and we want to ensure the network
            // is iterated from bottom up to ensure when hidden variables
            // are come across all the factors dependent on them have
            // been seen so far.
            List<RandomVariable> order = new ArrayList<RandomVariable>(vars);
            Collections.reverse(order);

            return order;
    }

    private Factor makeFactor(RandomVariable var, AssignmentProposition[] e,
                    BayesianNetwork bn) {

            Node n = bn.getNode(var);
            if (!(n instanceof FiniteNode)) {
                    throw new IllegalArgumentException(
                                    "Elimination-Ask only works with finite Nodes.");
            }            
            FiniteNode fn = (FiniteNode) n;
            List<AssignmentProposition> evidence = new ArrayList<AssignmentProposition>();
            for (AssignmentProposition ap : e) {
                    if (fn.getCPT().contains(ap.getTermVariable())) {
                            evidence.add(ap);
                    }
            }

            return fn.getCPT().getFactorFor(
                            evidence.toArray(new AssignmentProposition[evidence.size()]));
    }
    
    //this method compute the normalization constant
    private double calcNormVar(BayesianNetwork bn, AssignmentProposition[] e){        
        
        RandomVariable[] qrv = new RandomVariable[e.length];
        
        AssignmentProposition[] ap = new AssignmentProposition[0];
        
        for(int i = 0; i<e.length; i++){
            qrv[i] = e[i].getTermVariable();
        }                
        
        CategoricalDistribution cd = eliminationAsk(qrv, ap, bn);//bi.ask(qrv, ap, bn);
        
        return cd.getValue(e);
    }
    

    private List<Factor> maxOut(RandomVariable var, List<Factor> factors, BayesianNetwork bn) {
            
            //find factors to maxOut
            List<Factor> maxedOutFactors = new ArrayList<Factor>();
            List<Factor> toMultiply = new ArrayList<Factor>();
            for (Factor f : factors) {
                    if (f.contains(var)) {
                            toMultiply.add(f);
                    } else {                            
                            maxedOutFactors.add(f);
                    }
            }
            //System.out.println("Interno Maxout fattori da moltiplicare "+toMultiply);
            Factor product = pointwiseProduct(toMultiply);
            //System.out.println("Interno Maxout fattori moltiplicati "+product);
            //System.out.println("Variabile da maxare "+var);

            maxedOutFactors.add(maxFactor(product, var));

            //maxedOutFactors.add(pointwiseProduct(toMultiply).sumOut(var));

            return maxedOutFactors;
    }
    
    private List<Factor> sumOut(RandomVariable var, List<Factor> factors) {
        //find variable to sumOut
        List<Factor> summedOutFactors = new ArrayList<Factor>();
        List<Factor> toMultiply = new ArrayList<Factor>();
        for (Factor f : factors) {
                if (f.contains(var)) {
                        toMultiply.add(f);
                } else {                        
                        summedOutFactors.add(f);
                }
        }
        
        //System.out.println("MULTIPLYING "+var);
        Factor product = pointwiseProduct(toMultiply);
                
        //System.out.println("SUMMING "+var);
        //System.out.println("VARIABLE CPT "+product.getArgumentVariables());
        summedOutFactors.add(product.sumOut(var));

        return summedOutFactors;
    }
    
    //this method find maxAssignment for a variable and max probability
    private Factor maxFactor(Factor factor, RandomVariable... var){        
        Set<RandomVariable> maxVars = new HashSet<RandomVariable>();

        maxVars.addAll(factor.getArgumentVariables());

        for (RandomVariable rv : var) {
                    maxVars.remove(rv);
        }

        //System.out.println("maxVars"+ maxVars);

        ProbabilityTable maxedOut = new ProbabilityTable(maxVars);
        
        ProbabilityTable.Iterator di = null;

        if (maxedOut.getValues().length > 1) {            
            final Object[] termValues = new Object[maxedOut.getArgumentVariables().size()];

            mpeass.saveKey(var[0], maxVars);
            //Iterate possible assignments of variables
            di = new ProbabilityTable.Iterator() {
                public void iterate(Map<RandomVariable, Object> possibleWorld, double probability) {
                    int i = 0;
                    MPEAssignment ass = new MPEAssignment();
                    
                    //System.out.println("Mondo possibile "+possibleWorld);
                    //System.out.println("Probabilità "+probability);
                    for (RandomVariable rv : maxedOut.getArgumentVariables()) {
                        termValues[i] = possibleWorld.get(rv);
                        ass.add(rv,termValues[i]);
                        i++;
                    }

                    //update max
                    if(maxedOut.getValues()[maxedOut.getIndex(termValues)] < probability){
                        maxedOut.getValues()[maxedOut.getIndex(termValues)] = probability;
                        //System.out.println("VALORE VARIABILE MONDO POSSIBILE "+possibleWorld.get(var[0]));
                        //System.out.println("ASS "+ass);
                        mpeass.mapadd(ass, new Pair<RandomVariable,Object>(var[0],possibleWorld.get(var[0])));                        
                    }
                }
            };                                                        
        } else {
            //the table has only one variable, find max probability and assignment
            di = new ProbabilityTable.Iterator() {
                public void iterate(Map<RandomVariable, Object> possibleWorld, double probability) {
                    if( maxedOut.getValues()[0] < probability){                            
                        maxedOut.getValues()[0]=probability;
                        mpeass.add(var[0], possibleWorld.get(var[0]));
                    }
                }
            };                                  
        }
        
        ((ProbabilityTable)factor).iterateOverTable(di);

        return maxedOut;
    }
    
    private Factor pointwiseProduct(List<Factor> factors) {

            Factor product = factors.get(0);
            for (int i = 1; i < factors.size(); i++) {
                    product = product.pointwiseProduct(factors.get(i));
            }

            return product;
    }    
}
