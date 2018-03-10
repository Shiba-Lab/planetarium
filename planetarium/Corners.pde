class Corners {
  PApplet pa;
  int n;
  PVector corner[];
  int hold=-1;
  Action action;
  Corners(PApplet pa, int n, Action action, PVector... p) {
    this.pa=pa;
    this.n=n;
    this.action=action;
    corner=new PVector[n];
    for (int i=0; i<n; i++) {
      corner[i]=p[i];
    }
  }
  void display() {
    pa.beginShape();
    pa.stroke(255);
    pa.strokeWeight(1);
    for (int i=0; i<n; i++) {
      pa.fill(255);
      if (hold==i)pa.noFill();
      pa.ellipse(corner[i].x, corner[i].y, 10, 10);
      pa.noFill();
      pa.vertex(corner[i].x, corner[i].y);
    }
    pa.endShape(CLOSE);
  }
  void setCorners(int n, PVector... p) {
    for (int i=0; i<n; i++) {
      corner[i].set(p[i]);
    }
  }
  void setCorner(int n, PVector p) {
    corner[n].set(p);
  }
  void pressed(float x, float y) {
    int nearest=-1;
    float min=100000000;
    for (int i=0; i<n; i++) {
      float d=dist(x, y, corner[i].x, corner[i].y);
      if (d<min) {
        min=d;
        nearest=i;
      }
    }
    if (dist(x, y, corner[nearest].x, corner[nearest].y)<10) {
      hold=nearest;
      corner[hold].set(x, y);
    }
  }
  void dragged(float x, float y) {
    if (hold!=-1) {
      corner[hold].set(x, y);
    }
  }
  void released() {
    if (hold!=-1) {
      action.run(n, corner);
      hold=-1;
    }
  }
  void load(String filename){
    XML root=loadXML(filename);
    XML[] i_cornerXML=root.getChildren("i_corner");
    for (int i=0; i<i_cornerXML.length; i++) {
      corner[i]=new PVector(i_cornerXML[i].getFloat("x"), i_cornerXML[i].getFloat("y"));
    }
  }
}

interface Action {
  void run(int n, PVector... corner);
}