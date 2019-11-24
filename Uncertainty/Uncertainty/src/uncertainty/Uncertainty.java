/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uncertainty;
import aima.core.probability.CategoricalDistribution;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesInference;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.Node;
import aima.core.probability.bayes.exact.EliminationAsk;
import aima.core.probability.bayes.impl.FullCPTNode;
import uncertainty.BifBNReader;
import aima.core.probability.example.BayesNetExampleFactory;
import aima.core.probability.proposition.AssignmentProposition;
import java.lang.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 *
 * @author tommy
 */
public class Uncertainty {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws Exception {
        // TODO code application logic here
        BifBNReader bnReader = new BifBNReader("C:\\Users\\tommy\\Documents\\universita\\Magistrale\\IA_Lab\\Esercizi incertezza\\SamIam Nets\\sachs.bif") {
            @Override
            protected Node nodeCreation(RandomVariable var, double[] probs, Node... parents) {
                return new FullCPTNode(var, probs, parents);
            }
        };
        
        BayesianNetwork bn = bnReader.getBayesianNetwork();
        
        //RETI BAYESIANE DI ESEMPIO
        //BayesianNetwork bn = BayesNetExampleFactory.constructBurglaryAlarmNetwork(); //bnReader.getBayesianNetwork();                
        //BayesianNetwork bn = BayesNetExampleFactory.constructCloudySprinklerRainWetGrassNetwork();
        
        HashMap<String, RandomVariable> rvsmap = new HashMap<>();
                
        List<RandomVariable> rvs = bn.getVariablesInTopologicalOrder();
        
        for (RandomVariable rv :rvs) {
            System.out.println(rv.getName());
            rvsmap.put(rv.getName(), rv);                
        }
        
        Set<RandomVariable> map = new HashSet<RandomVariable>();
        
        map.add(rvsmap.get("Cloudy"));
        map.add(rvsmap.get("Rain"));
        RandomVariable[] qrv = new RandomVariable[1];
        //qrv[0] = rvsmap.get("ALARM");
        qrv[0] = rvsmap.get("PKA");
        //qrv[1] = rvsmap.get("Progesterone");
        AssignmentProposition[] ap = new AssignmentProposition[0];
        //System.out.println(rvsmap.get("XRAY").getDomain().getValueAt();
        //ap[0] = new AssignmentProposition(rvsmap.get("XRAY"), rvsmap.get("XRAY").getDomain());        
        /*AssignmentProposition[] ap = new AssignmentProposition[2];
        ap[0] = new AssignmentProposition(rvsmap.get("MaryCalls"), Boolean.TRUE);
        ap[1] = new AssignmentProposition(rvsmap.get("JohnCalls"), Boolean.TRUE);*/

        BayesInference bi = new EliminationAsk();
        
        System.out.println("VARIABLE "+qrv[0]);
        
        CategoricalDistribution cd = bi.ask(qrv, ap, bn);
        
        System.out.println(cd);
        /*Inference inf = new Inference();
        
        inf.MPE(ap,bn);*/
        //inf.MAP(map,ap,bn);
        /*CategoricalDistribution cd = bi.ask(qrv, ap, bn);
              
        System.out.print("<");
        for (int i = 0; i < cd.getValues().length; i++) {
            System.out.print(cd.getValues()[i]);
            if (i < (cd.getValues().length - 1)) {
                System.out.print(", ");
            } else {
                System.out.println(">");
            }
        }*/                      
        /*System.out.println(bn.toString());
        System.out.println(bn.getVariablesInTopologicalOrder().size());            
        
        for(RandomVariable rv:bn.getVariablesInTopologicalOrder()){
            System.out.println(rv);
            System.out.println("2");
        }*/
    }
    
}
