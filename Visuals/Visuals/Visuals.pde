import oscP5.*;
OscP5 oscP5;

float value1, value2, value3;
float increment = 0.1;
int scale = 10;
float zoff = 0.01;
float anglezoom = 0.5;
float alpha = 15;
float attraction = 0.02;
float colour = 255;
float weight = 2;

int cols;
int rows;

int numPoints = 10000;//number of points in field

Particle[] particles = new Particle[numPoints];
PVector[] flowField;

void setup() {
  fullScreen(P2D, 1);//fullscree, and GL renderer
  pixelDensity(1);//pixel density for retina Macbooks
  noiseSeed(0);//noise seed to repeat similar noise patterns
  noiseDetail(1);//detail of Perlin noise for flowfield
  background(0);
  hint(DISABLE_DEPTH_MASK);//avoid obvious visual artifacts due to the use of semi-transparent geometry together with alpha blending
  oscP5 = new OscP5(this, 4859);
  cols = floor(width/(2*scale));//columns for flowfield points scaled
  rows = floor(height/scale);//rows for flowfield points scaled
  
  flowField = new PVector[(cols*rows)];//appropriately sized array of vectors for flowfield
  
  //iterate through and create particle class for each
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
      PVector v = PVector.fromAngle(angle); 
      v.setMag(attraction);//attraction variable
      flowField[index] = v;
      
      // //for visualising flow field
      //stroke(255);
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
  //incrementing z creates a moving flowfield
  zoff = zoff + (increment/50);
  //draw the particles!
  for(int i = 0; i < particles.length; i++) {
  particles[i].follow(flowField);
  particles[i].update();
  particles[i].edges();
  particles[i].show();
  }
  //checking framerate
  println(frameRate);
}

//OSC incoming!
void oscEvent(OscMessage theOscMessage) {
  //what to do with each osc message
  if (theOscMessage.checkAddrPattern("/value1")==true) {
    value1 = theOscMessage.get(0).floatValue();
    weight = (value1*4)+1;
    //print("### value1: " + value1);
  } else if (theOscMessage.checkAddrPattern("/value2")==true) {
    value2 = theOscMessage.get(0).floatValue();
    alpha = 80*(1-value2);
    //print("### value2: " + value2);
  } else if (theOscMessage.checkAddrPattern("/value3")==true) {
    value3 = theOscMessage.get(0).floatValue();
    anglezoom = value3 +0.1;
    attraction = ((1-value3)*0.1) + 0.001;
    //print("### value3: " + value3);
  } else {
    println("### value3: " + theOscMessage.get(0).floatValue());
  }
}
