int count = 50000;

void setup() {
  size(1400, 850, P2D);
  pixelDensity(2);
  background(#D25454);
    for(int i=0; i < count; i++) {
    float x =  int(random(width));
    float y = int(random(height));
    float value = getValue(x, y);
    
    pushMatrix();
    translate(x, y);
    rotate(value);
    line(0, 0, 15, 10);
    stroke(#F09898);
    popMatrix();
  }

}

float getValue(float x, float y) { 
  return (sin(x * 0.01) + sin(y * 0.01))*0.5 * (2 * PI);
}
