/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uncertainty;


import aima.core.probability.RandomVariable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javafx.util.Pair;

/**
 *
 * @author tommy
 * 
 * This class is used for saving the assignments information
 * while the inference is being processed
 * 
 * The assignments are saved in a Map object
 * 
 * keyMap save the variable needed to retrieve 
 * the key assignments for a certain variable in the map
 */
public class FinalAssignment {        
    Map<MPEAssignment, MPEAssignment> map;    
    Map<RandomVariable, Set<RandomVariable>> keyMap;
    MPEAssignment finalAssignment;    
    
    public FinalAssignment(){        
        this.map = new HashMap<MPEAssignment, MPEAssignment>();
        this.keyMap = new HashMap<RandomVariable, Set<RandomVariable>>();
        this.finalAssignment = new MPEAssignment();
    }            
    
    //add possible assignment in map
    public void mapadd(MPEAssignment key, Pair<RandomVariable,Object> value){
        MPEAssignment ass;
        
        //if there is already this key in the map I add or update the new value      
        if(this.map.containsKey(key)){
            ass = this.map.get(key);
            
            //if there is already the variable I update its value
            if(ass.containVariable(value.getKey())){

                Pair<RandomVariable,Object> rm=null;
                for(Pair<RandomVariable,Object> p:ass.assignments){
                    if(p.getKey()==value.getKey()){
                        rm=p;
                    }
                }

                ass.assignments.remove(rm);                
                ass.assignments.add(value);                
            } else {
                ass.add(value);                
            }
        } else {
            ass = new MPEAssignment();
            ass.add(value);
            this.map.put(key, ass);
        }
    }
    
    //save the key for the map
    public void saveKey(RandomVariable key, Set<RandomVariable> values){
        keyMap.put(key, values);
    }
    
    public void printMap(){
        Iterator it = this.map.entrySet().iterator();
        int i = 0;
        while (it.hasNext()) {
            Map.Entry pair = (Map.Entry)it.next();
            i++;
            System.out.print(i+" ");
            for(Pair<RandomVariable,Object> p:((MPEAssignment)pair.getKey()).assignments){
                    System.out.print(p.getKey()+"="+p.getValue()+" ");
            }

            System.out.println("-> " + pair.getValue());
            //it.remove(); // avoids a ConcurrentModificationException
        }
    }
    
    public void printMap(Map<MPEAssignment, MPEAssignment> map){
        if(map!=null){
            Iterator it = map.entrySet().iterator();
            System.out.print("\n\n\n\n\n");
            int i = 0;
            while (it.hasNext()) {
                Map.Entry pair = (Map.Entry)it.next();
                i++;
                System.out.print(i+" ");
                for(Pair<RandomVariable,Object> p:((MPEAssignment)pair.getKey()).assignments){
                        System.out.print(p.getKey()+"="+p.getValue()+" ");
                }

                System.out.println("-> " + pair.getValue());
                //it.remove(); // avoids a ConcurrentModificationException
            }
        }
    }
    
    //this method saves the variable which value is already determined
    public void add(RandomVariable rv, Object value){
        if(this.finalAssignment.getAssignment(rv)!=null){
            this.finalAssignment.remove(rv);
        }
        this.finalAssignment.add(rv, value);
    }    
    
    //this method calculate the finalassignement
    public MPEAssignment finalCalculateAssignment(Set<RandomVariable> vars){
        //until finalAssignment doesn't contain all the variable of interest
        while(!containsAll(finalAssignment, vars)){
            List<RandomVariable> listvars = new ArrayList<RandomVariable>();
            listvars.addAll(vars);
            
            //iterate over the variables of interest
            for(RandomVariable var:listvars){
                //getting the variables needed to obtain the assingment of var
                Set<RandomVariable> varkey = keyMap.get(var);
                
                //search inside finalAssignment the assignment of key variables
                MPEAssignment key = null;
                if(varkey!=null){
                     key = buildKey(varkey);
                }
                
                //if the key have all the variables assignments I add the assignment to finalAssignment
                if(key!=null){
                    finalAssignment.add(this.map.get(key));
                    vars.remove(var);
                }
            }
        }
        
        return finalAssignment;
    }
    
    //this method try to build the key for map
    private MPEAssignment buildKey(Set<RandomVariable> vars){
        MPEAssignment key = new MPEAssignment();
                
        for(RandomVariable v:vars){
            Pair<RandomVariable, Object> p = finalAssignment.getAssignment(v);
            if(p!=null){
                key.add(p);
            } else {
                return null;
            }
        }
        
        return key;
    }        
    
    //check if in finalassignment there are all the variable vars
    private boolean containsAll(MPEAssignment finalAssignment, Set<RandomVariable> vars){
        for(RandomVariable var:vars){
            if(!finalAssignment.containVariable(var)){
                return false;
            }
        }
        return true;
    }        
    
}