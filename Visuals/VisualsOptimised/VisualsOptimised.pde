import oscP5.*;
OscP5 oscP5;

float zoff = 0.01;
float anglezoom = 0.5;
float alpha = 15;
float attraction = 0.02;
float weight = 2;
Particle[] particles = new Particle[10000];
PVector[] flowField;

void setup() {
  size(4080, 768, P2D);
  oscP5 = new OscP5(this, 4859);
  flowField = new PVector[(120*24)];//across the 4080 screen that's a column every 34 pixels and down the 768 screen that's a row every 32 pixels
  for(int i = 0; i < particles.length; i++) {
    particles[i] = new Particle();
  }
}

void draw() {
  fill(0, alpha);//second argument is trail variable using alpha
  rect(0, 0, 4080, 763);

  float yoff = 0;
  for(int y = 0; y < 24; y ++) {
    float xoff = 0;
    for(int x = 0; x < 120; x ++) {
      int index = (x + y * 120);
      
      float angle = noise(xoff/anglezoom, yoff/anglezoom, zoff/anglezoom) * (4 * PI);//change pi multiple for direction
      PVector v = PVector.fromAngle(angle);
      v.setMag(attraction);//attraction variable
      flowField[index] = v;

      xoff = xoff + 0.1;
    }
    yoff = yoff + 0.1;
  }
  zoff = zoff + (0.1/50);
  
  for(int i = 0; i < particles.length; i++) {
  particles[i].follow(flowField);
  }
  println(frameRate);
}

void oscEvent(OscMessage theOscMessage) {
  float value1, value2, value3;
  if (theOscMessage.checkAddrPattern("/value1")==true) {
    value1 = theOscMessage.get(0).floatValue();
    weight = (value1*4)+1;
  } else if (theOscMessage.checkAddrPattern("/value2")==true) {
    value2 = theOscMessage.get(0).floatValue();
    alpha = 80*(1-value2);
  } else if (theOscMessage.checkAddrPattern("/value3")==true) {
    value3 = theOscMessage.get(0).floatValue();
    anglezoom = value3 +0.1;
    attraction = ((1-value3)*0.1) + 0.001;
  }
}
