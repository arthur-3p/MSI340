Particle[] points = new Particle[20];
float a = random(1) * 4 -2;
float b = random(1) * 4 - 2;
float c = random(1) * 4 - 2;
float d = random(1) * 4 - 2;

void setup() {
  //size(1600, 900, P2D);
  fullScreen(P2D, 2);
  pixelDensity(2);
  background(0);
  for(int y = 0; y < points.length; y++){
  points[y] = new Particle(y, y, 0, 0);
  }
}

void draw() {
    for(int i = 0; i < points.length; i++) {
      Particle p = points[i];
      float value = getValue(p.x, p.y);
      p.vx += cos(value) * 0.1;
      p.vy += sin(value) * 0.1;
      
      
      p.x += p.vx;
      p.y += p.vy;
      if(p.x > 1600) p.x = 0;
      if(p.y > 900) p.y = 0;
      if(p.x < 0) p.x = 1600;
      if(p.y < 0) p.y = 900;
      //translate(p.x, p.y);
      point(p.x, p.y);
      //line(p.x, p.y, p.y, p.x);
      strokeWeight(1);
      stroke(255);
      
      // apply some friction so point doesn't speed up too much
      p.vx *= 0.99;
      p.vy *= 0.99;
    }
}

float getValue(float x, float y) {
  // clifford attractor
  // http://paulbourke.net/fractals/clifford/
  
  // scale down x and y
  float scale = 0.005;
  x = (x - 1000 / 2) * scale;
  y = (y - 800 / 2)  * scale;

  // attactor gives new x, y for old one. 
  float x1 = sin(a * y) + c * cos(a * x);
  float y1 = sin(b * x) + d * cos(b * y);

  // find angle from old to new. that's the value.
  return atan2(y1 - y, x1 - x);
  }
