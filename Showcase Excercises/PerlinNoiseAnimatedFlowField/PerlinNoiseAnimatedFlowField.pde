//creating 3d perlin noise flowfield and moving through them as 2d layers 
float z = 0;

void setup() {
  //size(1200, 800, P2D);
  fullScreen(P2D, 2);
  background(0);
  noiseDetail(1);
  pixelDensity(2);
}

void draw() {
  background(0);
  int res = 10;
  for(int x = 0; x < width; x += res) {
    for(int y = 0; y < height; y += 5) {
      float value = getValue(x, y);
      pushMatrix();
      translate(x, y);
      rotate(value);
      line(0, 0, res * 1.5, 0);
      stroke(255);
      popMatrix();
    }
  }
  z += 0.01;
  println(frameRate);
}

float getValue(int x, int y) {
  float scale = 0.01;
  return noise(x * scale, y * scale, z) * PI * 2;
}
