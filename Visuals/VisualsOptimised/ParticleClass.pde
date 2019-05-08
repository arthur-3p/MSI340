class Particle {
  PVector pos = new PVector(random(4080), random(768));
  PVector vel = new PVector(0, 0);
  PVector accel = new PVector(0, 0);

  public void follow (PVector[] vectors) {
    int x = floor(pos.x/34);
    int y = floor(pos.y/32);
    int i = (x-1) + ((y-1) * 120);
    //Unknown bug causing index out of range. If statements to prevent crash
    i = i - 1;
    if(i > vectors.length || i < 0) {
      i = vectors.length - 1;
    }
    PVector force = vectors[i];
    accel.add(force);
    vel.add(accel);
    vel.limit(1);
    pos.add(vel);
    accel.mult(0);
    stroke(255);
    strokeWeight(weight);
    if (pos.x > 4080) {
      pos.x = 0;
    } else if (pos.x < 0) {
      pos.x = 4080;
    } else if (pos.y > 763) {
      pos.y = 0;
    } else if (pos.y < 0) {
    pos.y = 763;
    } 
    point(pos.x, pos.y);
  }
}
