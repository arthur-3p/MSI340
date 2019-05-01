import oscP5.*;
OscP5 oscP5;

float value1, value2, value3;
float increment = 0.1;
int scale = 10;
float zoff = 0.01;
float anglezoom = 1;
float alpha = 255;
float attraction = 0.1;

int cols;
int rows;

int numPoints = 5000;

Particle[] particles = new Particle[numPoints];
PVector[] flowField;

void setup() {
  fullScreen(P2D, 1);
  pixelDensity(1);
  noiseSeed(0);
  noiseDetail(1);//experiment with this variable
  background(0);
  hint(DISABLE_DEPTH_MASK);//avoid obvious visual artifacts due to the use of semi-transparent geometry together with alpha blending
  oscP5 = new OscP5(this, 4859);
  cols = floor(width/scale);
  rows = floor(height/scale);
  
  flowField = new PVector[(cols*rows)];
  
  for(int i = 0; i < numPoints; i++) {
    particles[i] = new Particle();
  }
}

void draw() {
  stroke(0);
  fill(0, alpha);//second argument is trail variable using alpha
  rect(0, 0, width, height);
  noFill();

  float yoff = 0;
  for(int y = 0; y< rows; y++) {
    float xoff = 0;
    for(int x = 0; x < cols; x++) {
      int index = (x + y * cols);
      
      float angle = noise(xoff/anglezoom, yoff/anglezoom, zoff/anglezoom) * (4 * PI);//change pi multiple for direction
      PVector v = PVector.fromAngle(angle);//seconf int can vary attraction 
      v.setMag(attraction);//attraction variable
      flowField[index] = v;
      
      stroke(255);
      //// visualise flowfield. make sure numPoints = 0 or lag will ensue!
      // pushMatrix();
      
      // translate(x*scale, y*scale);
      // rotate(v.heading());
      // line(0, 0, scale, 0);
      
      // popMatrix();
      
      xoff = xoff + increment;
    }
    yoff = yoff + increment;
  }
  zoff = zoff + (increment/50);
  for(int i = 0; i < particles.length; i++) {
  particles[i].follow(flowField);
  particles[i].update();
  particles[i].edges();
  particles[i].show();
  }
  println(frameRate);
}

//void oscEvent(OscMessage theOscMessage) {
//  if (theOscMessage.checkAddrPattern("/value1")==true) {
//    value1 = theOscMessage.get(0).floatValue();
//    //println("### value1: " + value1);
//  } else if (theOscMessage.checkAddrPattern("/value2")==true) {
//    value2 = theOscMessage.get(0).floatValue();
//    alpha = 2.55*value2;
//  } else if (theOscMessage.checkAddrPattern("/value3")==true) {
//    value3 = theOscMessage.get(0).floatValue();
//    anglezoom = 0.01 * value3;
//  } else {
//    println("### value3: " + theOscMessage.get(0).floatValue());
//  }
//}
