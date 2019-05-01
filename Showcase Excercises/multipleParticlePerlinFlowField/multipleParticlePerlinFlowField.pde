Particle[] points = new Particle[200];

void setup() {
  //size(1600, 900, P2D);
  fullScreen(P2D, 2);
  pixelDensity(2);
  noiseDetail(2);
  background(0);
  for(int y = 0; y < points.length; y++){
  points[y] = new Particle(0, y, 0, 0);
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
      
      if(p.x > width) p.x = 0;
      if(p.y > height) p.y = 0;
      if(p.x < 0) p.x = width;
      if(p.y < 0) p.y = height;
      
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
  float scale = 0.01;
  return noise(x * scale, y * scale) * PI * 2;
}
