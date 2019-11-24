package uncertainty;

import aima.core.probability.Factor;
import aima.core.probability.RandomVariable;
import aima.core.probability.proposition.AssignmentProposition;
import java.util.ArrayList;
import java.util.List;
import javafx.util.Pair;

/**
 *
 * @author tommy
 * 
 * This class is a list of assignment
 */
public class MPEAssignment {    
    List<Pair<RandomVariable, Object>> assignments;
    Factor probability;
    double norm;
    
    public MPEAssignment(){
        this.assignments = new ArrayList<Pair<RandomVariable, Object>>();        
    }
        
    public MPEAssignment(RandomVariable rv, Object value){
        this.assignments = new ArrayList<Pair<RandomVariable, Object>>();
        this.add(rv,value);
    }
    
    public void add(RandomVariable rv, Object value){
        Pair<RandomVariable, Object> p = new Pair<RandomVariable, Object>(rv, value);
        this.assignments.add(p);
    }
    
    public void add(Pair<RandomVariable, Object> ass){     
        this.assignments.add(ass);
    }
    
    public void add(MPEAssignment m){
        for(Pair<RandomVariable, Object> p:m.assignments){
            //potrebbe servire confrontare chiave valore
            if(!this.assignments.contains(p)){
                this.assignments.add(p);
            }
        }        
    }    
    
    public boolean containVariable(RandomVariable var){
        for(Pair<RandomVariable, Object> p:this.assignments){
            if(p.getKey()==var){
                return true;
            }
        }
        return false;
    }
    
    public Pair<RandomVariable, Object> getAssignment(RandomVariable var){
        for(Pair<RandomVariable, Object> p:this.assignments){
            if(p.getKey()==var){
                return p;
            }
        }
        return null;
    }
    
    public AssignmentProposition getAssignmentProposition(RandomVariable rv){
        Pair<RandomVariable, Object> p = this.getAssignment(rv);
        return new AssignmentProposition(p.getKey(), p.getValue());
    }
    
    public void setProbability(Factor probability, double norm){
        this.probability = probability;
        this.norm = norm;
    }
    
    public void remove(RandomVariable rv){
        Pair<RandomVariable, Object> rm = this.getAssignment(rv);
        
        if(rm != null){
            this.assignments.remove(rm);
        }
    }
    
    //this method is used to compare two MPEAssignment Objects
    //in particular is used when to Map keys are compared
    @Override
    public boolean equals(Object o){
        // If the object is compared with itself then return true   
        if (o == this) { 
            return true; 
        } 

        if (!(o instanceof MPEAssignment)) { 
            return false; 
        } 
                  
        MPEAssignment as = (MPEAssignment) o; 
        boolean equal = true;
        
        //I check if the assignments have the same size and if are the same
        //even if the order is not the same
        if(as.assignments.size()==this.assignments.size()){
            for(Pair<RandomVariable, Object> p:as.assignments){
                if(!this.assignments.contains(p)){
                    equal=false;
                    break;
                }
            }
        } else {
            equal=false;
        }        
        
        return equal;
    }
    
    @Override
    public int hashCode() {
        int result = 17;
        
        for(Pair<RandomVariable, Object> p:this.assignments){
            //System.out.println("HASHCODE"+p.getKey().getName()+" "+p.getValue().toString());
            result += p.getKey().getName().hashCode()+p.getValue().toString().hashCode();
        }
        //System.out.println("HASHCODE"+result+"\n");
        return result*31;
    }
    
    @Override
    public String toString(){
        String s = new String();
        for(Pair<RandomVariable, Object> p:this.assignments){
            s+=p.getKey().getName()+" "+p.getValue().toString()+"\n";
        }
        return s;
    }
}
