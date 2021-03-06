import ddf.minim.*;
import ddf.minim.analysis.*;
import java.util.*; 

Circle circle; 
ArrayList<Circle> circles = new ArrayList<Circle>(); 

Minim minim;
AudioInput in;
FFT fft;

void setup()
{
  size(displayWidth, displayHeight, P2D);

  minim = new Minim(this);
  minim.debugOn();

  in = minim.getLineIn(Minim.MONO, 4096, 44100);
  fft = new FFT(in.left.size(), 44100);
  
}

 float ellipseY = 400; 
 int colormain = 255; 
 int color1 = 255;
 int color2 = 255; 

void draw()
{
  background(0);
  stroke(255);
  textSize(150); 
  textAlign(CENTER); 
  text("Synthra",width/2,height/2); 
  
  
  fft.forward(in.left);
  for (int n = 0; n < fft.specSize()/10; n++) { 
    println("Current Frequency: "+((fft.getBand(n))*4410) );
    ellipseY = map(  ((fft.getBand(n))*44100*2), 0,height, 0, height);
    colormain = (int)(map( ((fft.getBand(n))*44100), 128, 255, 0, 255)); 
   
    //create a new circle object, and display it with the parameters    
    Circle c = new Circle(ellipseY, 10.0, colormain, color1, color2); 
    circles.add(c); 
  }
  
  // draw the waveforms
  for (int i = 0; i < in.bufferSize()/10; i+=5)
  {
    //getting left waves
    println("Current Left: "+Math.abs((map(in.left.get(i+1)*100000, 0,128,0,255)))); 
    color1 = (int)( Math.abs(map(in.left.get(i+1)*100000, in.left.get(i+1)*100000,in.left.get(i+1)*1000000,0,255))); 
    //getting right waves
    println("Current Right: "+Math.abs((map(in.right.get(i+1)*100000, 0,255,0,255))));  
    color2 = (int)(Math.abs(map(in.right.get(i+1)*100000, 0,128,0,255))); 
  }//end of for loop  
  
  //before we create new circle, check if any have gone out 
 
  //display the circles
  for(Circle c: circles){
//   Iterator itr = circles.iterator(); 
//        while (itr.hasNext()) 
//        {  
//            if (c.circleX > width) 
//                itr.remove(); 
//        } 
//   
     if(c.circleX < width){
       c.display();  
     }
   }
  
}//end of draw 

void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();
  super.stop();
}


class Circle{
 float circleX = 10.0;
 float circleY;
 float radius = 10.0;
 int colormains = 255; 
 int color1s = 255;
 int color2s = 255; 
 
 public Circle(){
  this.circleY = 0.0; 
 }
 
 public Circle(float y){
   this.circleY = y;  
 }
 
 public Circle(float y, float r){
   this.circleY = y; 
   this.radius = r;  
 }
 
 public Circle(float y, float r, int cm, int c1, int c2){
   this.circleY = y; 
   this.radius = r;    
   this.colormains = cm; 
   this.color1s = c1;
   this.color2s = c2; 
 }
 
 void display(){
   fill(colormains, color1s, color2s, 50); 
   //stroke(colormains, color1s, color2s, 80);
   noStroke(); 
   ellipse(circleX,circleY,radius,radius); 
   animate(); 
 } 
 
 void animate(){
   this.circleX+=10; 
   ellipse(circleX,circleY,radius,radius);
 }

}//end of class circle 
