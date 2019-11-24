/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kallmanproject;

import org.apache.commons.math3.filter.DefaultMeasurementModel;
import org.apache.commons.math3.filter.DefaultProcessModel;
import org.apache.commons.math3.filter.KalmanFilter;
import org.apache.commons.math3.filter.MeasurementModel;
import org.apache.commons.math3.filter.ProcessModel;
import org.apache.commons.math3.linear.Array2DRowRealMatrix;
import org.apache.commons.math3.linear.ArrayRealVector;
import org.apache.commons.math3.linear.MatrixUtils;
import org.apache.commons.math3.linear.RealMatrix;
import org.apache.commons.math3.linear.RealVector;
import org.apache.commons.math3.random.JDKRandomGenerator;
import org.apache.commons.math3.random.RandomGenerator;

/**
 *
 * @author tommy
 */
public class KallmanProject {

    /**
     * @param args the command line arguments
     */
    private static int parseChoice(String arg){
        int choice = 1;
        
        switch(arg){
                case "low":
                    choice = 0;
                    break;
                case "mid":
                    choice = 1;
                    break;
                case "high":
                    choice = 2;
                    break;                
            }
        
        return choice;
    }
    
    private static int[] parseArgs(String[] args){
        int[] choices = new int[3];
        
        choices[2] = 0;
        
        if(args.length == 2){
            choices[0] = parseChoice(args[0]);
            choices[1] = parseChoice(args[1]);
        } else if(args.length == 3) {
            choices[0] = parseChoice(args[0]);
            choices[1] = parseChoice(args[1]);
            if(args[2].equals("rand")) choices[2] = 1;
        } else {
            choices[0] = 1;
            choices[1] = 1;
        }
        
        return choices;
    }
          
    public static void main(String[] args) {
        
        double dt = 0.1d;
        
        //System.out.println(args[0]+" "+args[1]);
        
        //Rumore del processo
        RealMatrix low = new Array2DRowRealMatrix(new double[][] {
            { 0, 0 },
            { 0, 0 }});
        
        RealMatrix mid = new Array2DRowRealMatrix(new double[][] {
            { 10, 0 },
            { 0, 10 } });
        
        RealMatrix high = new Array2DRowRealMatrix(new double[][] {
            { 100, 0 },
            { 0, 100 } });
        
        RealMatrix[] qNoise = {low, mid, high}; 
        
        //rumore della misurazione
        double[] mNoise = {0.00001d, 10d, 100d};
        
        int[] ch = parseArgs(args);
        
        //System.out.println("choice0: "+ch[0]+" choice1: "+ch[1]+"choice3: "+ch[2]);
        
        experiment(dt, mNoise[ch[0]], qNoise[ch[1]], ch[2]);        
        
    }
    
    private static void experiment(double dt, double measurementNoise, RealMatrix externalNoise, int rnd){                                

        //modello transizionale
        //matrice di trasformazione per la predizione F
        RealMatrix A = new Array2DRowRealMatrix(new double[][] { { 1, dt }, { 0, 1 } });
        
        //control input matrix
        //come i fattori vengono modificati (posizione , velocità)
        RealMatrix B = new Array2DRowRealMatrix(new double[][] { { Math.pow(dt, 2d) / 2d }, { dt } });
        
        //measurement matrix        
        //matrice per scalare i valori letti a quelli che ci interessano
        RealMatrix H = new Array2DRowRealMatrix(new double[][] { { 1d, 0d } });
        
        //vettiore variabili aleatorie
        // x = [ 0 0 ]
        //random [0, 20]
        RealVector x;
        
        //distribuzione iniziale
        // P0 = [ 1 1 ]
        //      [ 1 1 ]        
        RealMatrix P0 = new Array2DRowRealMatrix(new double[][] { { 1, 1 }, { 1, 1 } });;
        
        if(rnd == 0){
            x = new ArrayRealVector(new double[] { 0, 0 });                        
        } else {
            x = new ArrayRealVector(new double[] { Math.random()*10, Math.random()*10 });
        }
        
        //printInitialDistribution(x,P0);              
        
        //process noise covariance matrix

        // il rumore dei fattori di cui non puoi tenere conto
        RealMatrix Q = externalNoise;//tmp.scalarMultiply(Math.pow(accelNoise, 2));               
        
        //measurement noise covariance matrix
        // R = [ measurementNoise^2 ]
        RealMatrix R = new Array2DRowRealMatrix(new double[] { Math.pow(measurementNoise, 2) });

        // constant control input, increase velocity by 1 m/s        
        RealVector u = new ArrayRealVector(new double[] { 1d });

        ProcessModel pm = new DefaultProcessModel(A, B, Q, x, P0);
        MeasurementModel mm = new DefaultMeasurementModel(H, R);
        KalmanFilter filter = new KalmanFilter(pm, mm);      

        RandomGenerator rand = new JDKRandomGenerator();
        
        RealVector mNoise = new ArrayRealVector(1);
        
        RealVector real_x = new ArrayRealVector(new double[] { 0, 0 });                
        
        RealMatrix KalmanGain;
        // iterate 60 steps
        for (int i = 0; i < 60; i++) {
            filter.predict(u);

            // simulate the process            

            // calcolo lo spazio
            real_x.setEntry(0, real_x.getEntry(0) + 1/2*u.getEntry(0)*dt*dt+real_x.getEntry(1)*dt);
            
            //calcolo la velocità
            real_x.setEntry(1, real_x.getEntry(1) + u.getEntry(0)*dt);
            
            // x = A * x + B * u + pNoise
            //x = A.operate(x).add(B.operate(u)).add(pNoise);
            //real_x = A.operate(x).add(B.operate(u));
            
            //System.out.println("U: "+ u);
            // simulate the measurement
            mNoise.setEntry(0, measurementNoise * rand.nextGaussian());

            // z = H * x + m_noise
            RealVector z = H.operate(real_x).add(mNoise);            
            
            filter.correct(z);
                        
            double position = filter.getStateEstimation()[0];
            double velocity = filter.getStateEstimation()[1];
                     
            
            RealMatrix errorCovariance = filter.getErrorCovarianceMatrix();                        
            
            //H*P*H'*(H*P*H'+R)^-1
            
            RealMatrix HPH = H.multiply(errorCovariance).multiply(H.transpose());                        
            
            KalmanGain=HPH.multiply(MatrixUtils.inverse(HPH.add(R)));
            //KalmanGain=HPH.multiply(new LUDecomposition((HPH.add(R))).getSolver().getInverse());
            
            //tracciare lo stato
            System.out.println("Estimated Position: "+position+"\nEstimated Velocity: "+velocity+"");
            System.out.println("Position: "+real_x.getEntry(0)+"\nVelocity: "+real_x.getEntry(1)+"\n");
            
            System.out.println("Errore stimato posizione: "+ Math.abs(position- real_x.getEntry(0))+"");
            System.out.println("Errore stimato velocità: "+ Math.abs(velocity- real_x.getEntry(1))+"\n");                        
                        
            System.out.println("KalmanGain "+KalmanGain.getEntry(0, 0)+"\n");
        }
    }
    
    private static void printInitialDistribution(RealVector x, RealMatrix P0){
        System.out.print("X: ");
        for(int i=0; i<x.getDimension(); i++){
            System.out.print(x.getEntry(i)+" ");
        }
        System.out.println("\nP0:");
        for(int i=0; i<P0.getRowDimension(); i++){            
            for(int j=0; j<P0.getColumnDimension(); j++){
                System.out.print(P0.getEntry(i,j)+" ");
            }
            System.out.print("\n");
        }
        System.out.print("\n");
    }         
}
