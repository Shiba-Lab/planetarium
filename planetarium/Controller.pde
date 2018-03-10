class Controller {
  int selectTime=300;
  Brightest br;
  int threshold;
  boolean isContinue;
  Star ns;
  int detectTime;
  int missTime;
  Controller(OpenCV opencv, int threshold) {
    this.threshold=threshold;
    br=new Brightest(opencv);
    br.start();
  }
  void setImage(PImage capture) {
    br.setImage(capture);
  }
  void display() {
    if (isContinue) {
      stroke(180, 0, 0);
      strokeWeight(4);
      noFill();
      PVector pos=br.getPos();
      ellipse(pos.x, pos.y, 10, 10);
      if (ss.hasSelectedStar()) {
        strokeWeight(1);
        stroke(150);
        PVector pos2=ss.selectedStar.pos;
        line(pos.x, pos.y, pos2.x, pos2.y);
      }
      stroke(0, 0, 200);
      //text(ss.getProgress(), 30, 30);
    }

    //if (isContinue) {
    //  text("true", 70, 30);
    //} else {
    //  text("false", 70, 30);
    //}
    //text(getMissing(), 120, 30);
  }
  void update() {
    if (isContinue) {
      if (br.getBrightness()>=threshold) {
        keepOn();
      } else {
        release();
      }
    } else {
      if (br.getBrightness()>=threshold) {
        push();
      } else {
        keepOff();
      }
    }
    if (ss.hasConstellation()&&getMissing()>5000) {
      ss.completeConstellation();
      missTime=0;
    }
  }
  void push() {
    isContinue=true;
    PVector pos=br.getPos();
    ns=ss.getNearestStar(pos);
    detectTime=millis();
  }

  void keepOn() {
    PVector pos=br.getPos();
    ns=ss.getNearestStar(pos);
    ss.con.reset();
    if (ns.getDistance(pos)<30) {
      if (ss.isCurrentStar(ns)) {
      } else {
        ss.setCurrentStar(ns);
      }
      if (ss.getProgress()>selectTime&&!ss.hasSelectedStar()&&!ns.used) {
        ss.selectedStar=ns;
        ns.mode=2;
      }
    }
    missTime=0;
  }

  void release() {
    isContinue=false;
    if (ss.hasSelectedStar()) {
      if (!ss.isCurrentStar(ss.selectedStar)) {
        ss.con.addTuple(ss.selectedStar, ss.currentStar);
        ss.p.setPosition(((Star)(ss.con.stars.get(0).a)).pos.x, ((Star)(ss.con.stars.get(0).a)).pos.y);
        ss.con.reset();
      }
    }
    missTime=millis();
    ss.reset();
  }

  void keepOff() {
    detectTime=0;
  }
  int getDetecting() {
    if (detectTime==0)return 0;
    return millis()-detectTime;
  }
  int getMissing() {
    if (missTime==0)return 0;
    return millis()-missTime;
  }
  //void updateContinue(boolean b) {
  //  for (int i=0; i<continueList.length-1; i++) {
  //    continueList[i]=continueList[i+1];
  //  }
  //  continueList[continueList.length-1]=b;
  //}
  //float getContinueRate() {
  //  int count=0;
  //  for (boolean b : continueList) {
  //    if (b)
  //      count++;
  //  }
  //  return (float)count/continueList.length;
  //}
}