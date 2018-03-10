import gab.opencv.*;

class Brightest extends Thread {
  OpenCV opencv;
  PVector pos;
  float brightness;
  PImage capture;
  boolean isContinue;
  Brightest(OpenCV opencv) {
    this.opencv=opencv;
  }
  public void run() {
    while (true) {
      delay(20);
      setBrightest();
    }
  }
  synchronized void setBrightest() {
    pos=opencv.max();
    if (capture!=null)
      brightness=brightness(capture.get(int(pos.x), int(pos.y)));
  }
  synchronized void setImage(PImage capture) {
    this.capture=capture;
    opencv.loadImage(capture);
  }
  synchronized PVector getPos() {
    return pc.adapt(pos);
  }
  synchronized float getBrightness() {
    if (pc.adapt(pos).x<0||pc.adapt(pos).x>width||pc.adapt(pos).y<0||pc.adapt(pos).y>height)
      return 0;
    return brightness;
  }
}