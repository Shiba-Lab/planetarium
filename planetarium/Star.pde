class Star {
  PVector pos;
  float radius;
  int mode;
  boolean used;
  Star(PVector pos, float radius) {
    this.pos=pos;
    this.radius=radius;
    mode=0;//0:normal 1:selected 2:
  }
  void display() {
    fill(200);
    noStroke();
    if (mode==1) {
      strokeWeight(10);
      stroke(0, 130, 0);
    }
    if (mode==2) {
      strokeWeight(15);
      stroke(150);
    }
    pushMatrix();
    translate(pos.x, pos.y);
    ellipse(0, 0, radius, radius);
    popMatrix();
  }
  float getDistance(PVector pos) {
    return dist(this.pos.x, this.pos.y, pos.x, pos.y);
  }
  void setMode(int mode) {
    this.mode=mode;
  }
  void reset() {
    mode=0;
  }
}