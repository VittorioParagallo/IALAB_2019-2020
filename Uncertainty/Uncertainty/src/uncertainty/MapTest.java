/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uncertainty;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.Node;
import aima.core.probability.bayes.impl.FullCPTNode;
import aima.core.probability.domain.FiniteDomain;
import aima.core.probability.proposition.AssignmentProposition;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Random;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.util.Pair;

/**
 *
 * @author tommy
 */
public class MapTest {
    
    static String path = "C:\\Users\\tommy\\Documents\\universita\\Magistrale\\IA_Lab\\Esercizi incertezza\\TestMap\\";
    
    public static void main(String[] args){
        BifBNReader bnReader=null;
        
        try {
            bnReader = new BifBNReader("C:\\Users\\tommy\\Documents\\universita\\Magistrale\\IA_Lab\\Esercizi incertezza\\SamIam Nets\\andes.bif") {
                @Override
                protected Node nodeCreation(RandomVariable var, double[] probs, Node... parents) {
                    return new FullCPTNode(var, probs, parents);
                }
            };
        } catch (Exception ex) {
            Logger.getLogger(MapTest.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        BayesianNetwork bn = bnReader.getBayesianNetwork();                       
                
        List<RandomVariable> rvs = new ArrayList();
        
        rvs.addAll(bn.getVariablesInTopologicalOrder());                
        
        AssignmentProposition[] e = genEvidence(rvs, 30);
        
        Inference inf = new Inference();
        
        boolean equal=false;                
        
        
        File f = new File(path);
        File[] files = f.listFiles();
        
        FileWriter fr = null;
        BufferedWriter br = null;
        
        File log = new File(path+(files.length+1)+".log");
        
        try{
            if(log.createNewFile()){
                System.out.println("FILE CREATED");   
            } else{
                System.out.println("STO BASTARDO NON CREA IL FILE");   
            }
            fr = new FileWriter(log);
            br = new BufferedWriter(fr);
        } catch (IOException ex) {
            ex.printStackTrace();
            try {
                br.close();
                fr.close();
            } catch (IOException ex1) {
                ex1.printStackTrace();
            }
        }
        
        double t=0d;
        
        System.out.println("Vars num: "+rvs.size());
        try {
            for(int i = 20; i < rvs.size(); i++){
                Set<RandomVariable> map = genMap(rvs, i);
                Set<RandomVariable> map2 = new HashSet();
                map2.addAll(map);

                System.out.println("Test: "+(i));
                System.out.println("map: "+map);
                long start = System.currentTimeMillis();
                MPEAssignment mpe1 = inf.testMAP(map, e, bn, true);

                long time1 = System.currentTimeMillis() - start;

                MPEAssignment mpe2 = inf.testMAP(map2, e, bn, false);
                long time2 = System.currentTimeMillis() - time1 - start;

                //if(mpe1.equals(mpe2) && mpe1.probability.getValues()[0] == mpe2.probability.getValues()[0]){
                if(mpe1.equals(mpe2) && mpe1.probability.getValues()[0] == mpe2.probability.getValues()[0]){//Double.compare(mpe1.probability.getValues()[0], mpe2.probability.getValues()[0])==0){
                    equal = true;
                    t++;
                } else {
                    equal = false;                
                }

                logToFile(br, map, e, mpe1, mpe2, time1, time2, equal);
                
                if(i%10==0){
                    System.out.println("TRUES: "+t);
                    br.flush();
                }
            }
            System.out.println("VARS NUM: "+rvs.size());                
            System.out.println("Equals: "+(t/rvs.size()));                
            System.out.println("Equals% : "+((t/rvs.size())*100)+"% Not Equals% : "+((1-(t/rvs.size()))*100)+"%");                
            
        } catch (Exception ex1) {
            ex1.printStackTrace();
        } finally {            
            try {
                br.flush();
                br.close();
                fr.close();
            } catch (IOException ex1) {
                ex1.printStackTrace();
            }            
        }
    }
    
    private static AssignmentProposition[] genEvidence(List<RandomVariable> vars, int n){
        AssignmentProposition[] e = new AssignmentProposition[n];
        
        Random random = new Random();
        int r1, r2;
        Set possibleValues;
        List<Integer> nums = new ArrayList();
        
        for(int j = 0; j < n; j++){
            r1 = getRandomNum(random, nums, vars.size()-1);
            possibleValues = (Set)(((FiniteDomain)vars.get(r1).getDomain()).getPossibleValues());
            
            nums.add(r1);
            
            r2 = random.nextInt(possibleValues.size()-1);  
            e[j] = new AssignmentProposition(vars.get(r1), getValue(possibleValues,r2));
            
            vars.remove(r1);
        }
        
        return e;
    }
    
    private static HashSet<RandomVariable> genMap(List<RandomVariable> vars, int n){
        List<RandomVariable> copy = new ArrayList<RandomVariable>();
        HashSet<RandomVariable> map = new HashSet<RandomVariable>();
        copy.addAll(vars);
        
        Random random = new Random();
        int r;
        //List<Integer> nums = new ArrayList();
        
        for(int x=n; x>0; x--){
            r = random.nextInt(x);//getRandomNum(random, nums, vars.size()-1);
            //nums.add(r);
            map.add(copy.get(r));
            copy.remove(r);
        }
        
        return map;     
    }
    
    private static Object getValue(Set possibleValues, int r){
        Iterator value = possibleValues.iterator();
        int i=0;
        Object ob = (Object) value.next();
        
        while(value.hasNext()){                        
            if(i==r){
               return ob; 
            }
            ob = (Object) value.next();
        }
        
        return ob;
    }
    
    private static void logToFile(BufferedWriter br, Set<RandomVariable> map, AssignmentProposition[] e, MPEAssignment mpe1, MPEAssignment mpe2, long time1, long time2, boolean equal){        
        
        String data = "";
        
        for(RandomVariable v: map){
            data+=v.getName()+" ";
        }
        
        //MAP VARIABLE
        data+=System.getProperty("line.separator");
        
        for(int k=0; k<e.length; k++){
            data+=e[k].getTermVariable()+"="+e[k].getValue()+" ";
        }
                
        data+=System.getProperty("line.separator");
        
        //ASSIGNMENT 1
        for(Pair<RandomVariable, Object> p:mpe1.assignments){
            data+=p.getKey().getName()+"="+p.getValue().toString()+" ";
        }
        
        data+=System.getProperty("line.separator")+new DecimalFormat("#.########################").format(mpe1.probability.getValues()[0])+System.getProperty("line.separator");                        
        
        //ASSIGNMENT 2
        for(Pair<RandomVariable, Object> p:mpe2.assignments){
            data+=p.getKey().getName()+"="+p.getValue().toString()+" ";
        }
        
        data+=System.getProperty("line.separator")+new DecimalFormat("#.########################").format(mpe2.probability.getValues()[0])+System.getProperty("line.separator");
        
        //time and result
        //data+=System.getProperty("line.separator");
        
        data+=printTime(time1)+System.getProperty("line.separator");
        data+=printTime(time2)+System.getProperty("line.separator");
        data+=equal+System.getProperty("line.separator");
        
        try{
            br.write(data);
        } catch (IOException ex) {
            ex.printStackTrace();
            try {
                br.close();                
            } catch (IOException ex1) {
                ex1.printStackTrace();
            }
        }
    }
    
    private static String printTime(long time){
        String timeString = new String();
        
        if(TimeUnit.MILLISECONDS.toSeconds(time) > 0){
            timeString+=TimeUnit.MILLISECONDS.toSeconds(time)+" sec";
        } else {
            timeString+=time+" ms";
        }
        
        return timeString;
    }
    
    private static int getRandomNum(Random r, List<Integer> nums, int n){
        int k=r.nextInt(n);
        
        while(nums.contains(k)){
            k=r.nextInt(n);
        }
        
        return k;
    }
}
