class Monitor extends PApplet {
  int w, h;
  PApplet parent;

  Corners corners;
  Monitor(PApplet parent, int w, int h, String _name) {
    super();   
    this.parent = parent;
    this.w=w;
    this.h=h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    corners=new Corners(this, 4, new Action() {
      public void run(int n, PVector... corner) {
        println(corner);
        PVector[] temp=new PVector[n];
        for (int i=0; i<n; i++) {
          temp[i]=new PVector(corner[i].x, corner[i].y);
        }
        pc.setI_corner(temp);
      }
    }
    , 
      new PVector(0, 0), 
      new PVector(width, 0), 
      new PVector(width, height), 
      new PVector(0, height)
      );
  }
  public void settings() {
    size(w, h);
  }
  public void setup() {
  }
  public void draw() {
    image(capture, 0, 0);
    corners.display();
  }
  void mousePressed() {
    if (mouseButton==LEFT) {
      corners.pressed(mouseX, mouseY);
      adjust=true;
      noCursor();
    }
    
  }
  void mouseDragged() {
    corners.dragged(mouseX, mouseY);
  }
  void mouseReleased() {
    corners.released();
    adjust=false;      
    cursor();

  }
  void keyPressed() {
    switch(key) {
    case 's':
      pc.save("corner.dat");
      ss.save();
      break;
    case 'l':
      pc.load("corner.dat");
      corners.load("corner.dat");
      break;
    }
  }
  void dispose() {
    ss.save();
    println("exit.");
  }
}