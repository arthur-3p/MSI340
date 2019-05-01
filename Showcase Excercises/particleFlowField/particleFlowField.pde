//creates static flowfield which the point or line will then folloe, 
//becomes evident if left to build up.
Particle p;

void setup() {
  //size(1000, 800);
  fullScreen(P2D, 2);
  pixelDensity(2);
  frameRate(60);
  background(0);
  p = new Particle(random(1000), random(1000), 0, 0);

}

void draw() {
float value = getValue(p.x, p.y);
  p.vx += cos(value) * 0.2;
  p.vy += sin(value) * 0.2;
  
  
  p.x += p.vx;
  p.y += p.vy;
  if(p.x > 1000) p.x = 0;
  if(p.y > 800) p.y = 0;
  if(p.x < 0) p.x = 1000;
  if(p.y < 0) p.y = 800;
  translate(p.x, p.y);
  //point(0, 0);
  line(0,0,10,0);
  strokeWeight(1);
  stroke(255);
  
  // apply some friction so point doesn't speed up too much
  p.vx *= 0.99;
  p.vy *= 0.99;
}

float getValue(float x, float y) { 
  return (sin(x * 0.01) + sin(y * 0.01))*0.5 * (2 * PI);
}

class Particle {
  float x;
  float y;
  float vx;
  float vy;
  
  Particle(float xpos, float ypos, float velx, float vely){
    x = xpos;
    y = ypos;
    vx = velx;
    vy = vely;
  }
}
