int count = 20000;

void setup() {
  size(1000, 900, P2D);
  pixelDensity(2);
  background(255);
    for(int i=0; i < count; i++) {
    float x =  int(random(width));
    float y = int(random(height));
    float value = getValue(x, y);
    
    pushMatrix();
    translate(x, y);
    rotate(value);
    line(0, 0, 20, 3);
    stroke(10);
    popMatrix();
  }

}

float getValue(float x, float y) { 
  return (x+y) * 0.001 * PI * 2;
}
