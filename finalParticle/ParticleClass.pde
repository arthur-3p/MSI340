//Particle class for each individual particle

class Particle {
  //random position and 0 velocity and 0 acceleration.
  PVector pos = new PVector(random(width), random(height));
  PVector vel = new PVector(0, 0);
  PVector accel = new PVector(0, 0);
  float maxSpeed = 1;
  
  public void update() {
    vel.add(accel);
    vel.limit(maxSpeed);
    pos.add(vel);
    accel.mult(0);//check what changing this does
  }
  
  public void follow (PVector[] vectors) {
    int x = floor(pos.x/scale);
    int y = floor(pos.y/scale);
    int index = (x-1) + ((y-1) * cols);
    //Unknown bug causing index out of range. If statements to prevent crash
    index = index - 1;
    if(index > vectors.length || index < 0) {
      index = vectors.length - 1;
    }
    PVector force = vectors[index];
    applyForce(force);
  }
  
  void applyForce(PVector force) {
    accel.add(force);
  }
  
  public void show () {
    stroke(255, 255);//second arg is particle alpha
    strokeWeight(5);
    point(pos.x, pos.y);
  }
  
  public void edges() {
    if (pos.x > width) {
      pos.x = 0;
    }
    if (pos.x < 0) {
      pos.x = width;
    }

    if (pos.y > height) {
      pos.y = 0;
    }
    if (pos.y < 0) {
      pos.y = height;
    }
  }
}
