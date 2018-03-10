import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import processing.video.*;

Capture capture;
Controller ctr;
StarrySky ss;
ProjectorCorrection pc;
Monitor mon;
Minim minim;
AudioSample kira2;
boolean adjust;
void settings() {
  //size(640, 480);
  fullScreen(2);
}
void setup()
{
  minim=new Minim(this);
  kira2 = minim.loadSample( "kira2.mp3",512);
  //capture=new Capture(this, 640, 480,"USB_Camera", 30);//, 
  capture=new Capture(this, 640,480, 30);//, "USB_Camera"
  capture.start();
  frameRate(30);
  ctr=new Controller(new OpenCV(this, capture), 255);
  ss=new StarrySky();
  pc=new ProjectorCorrection();
  pc.setO_corner(0, 0, width, 0, width, height, 0, height);
  mon=new Monitor(this, capture.width,capture.height, "Monitor");
}

void draw() {
  if (capture.available()) {
    background(0);
    capture.read();
  }
  ctr.setImage(capture);
  ss.display();
  //image(capture, 0, 0, width, height);
  ctr.update();
  ctr.display();
  if (adjust) {
    noStroke();
    fill(255);
    ellipse(0, 0, 100, 100);
    ellipse(width, 0, 100, 100);
    ellipse(width, height, 100, 100);
    ellipse(0, height, 100, 100);
  }
}

void mousePressed() {
}