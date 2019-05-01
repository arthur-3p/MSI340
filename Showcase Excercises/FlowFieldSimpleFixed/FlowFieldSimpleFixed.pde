int res = 5;


void setup() {
  size(1000, 900, P2D);
  pixelDensity(2);
  background(255);
  for(int x = 0; x<width; x += res) {
  for(int y = 0; y< height; y += res) {
    float value = (x + y) * 0.01 * PI * 2;
    
    pushMatrix();
    translate(x, y);
    rotate(value);
    line(0, 0, res, 0);
    stroke(100);
    popMatrix();
    
  }
}    
}
