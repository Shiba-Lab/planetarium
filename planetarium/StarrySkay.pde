import java.util.List;
class StarrySky {
  List<Star> stars;
  List<Constellation> constellations;
  Star currentStar;
  Star selectedStar;
  Constellation con;
  
  Particles p;
  int SelectedTime;
  StarrySky() {
    stars=new ArrayList<Star>();
    //for (int i=0; i<80; i++) {
    //  stars.add(new Star(new PVector(random(0, width), random(0, height)), random(3, 10)));
    //}
    constellations=new ArrayList<Constellation>();
    con=new Constellation();
    p=new Particles();
    load();
  }
  void display() {
    p.display();
    noStroke();
    fill(0, p.a);
    rect(0, 0, width, height);
    for (Star star : stars) {
      star.display();
      star.pos.set(star.pos.x,(star.pos.y+0.5)%10000);
    }
    for (Constellation cons : constellations) {
      cons.display();
    }
    con.display();
    p.a=constrain(p.a+10, 0, 255);
  }
  Star getNearestStar(PVector pos) {
    Star star=null;
    float min=width*height, temp;
    for (Star s : stars) {
      temp=s.getDistance(pos);
      if (temp<min) {
        min=temp;
        star=s;
      }
    }
    return star;
  }
  boolean isCurrentStar(Star currentStar) {
    return this.currentStar==currentStar;
  }
  boolean hasSelectedStar() {
    for (Star star : stars) {
      if (star.mode==2)
        return true;
    }
    return false;
  }
  void setCurrentStar(Star currentStar) {
    if (this.currentStar!=null)
      if (this.currentStar.mode!=2)
        this.currentStar.reset();
    this.currentStar=currentStar;
    currentStar.mode=1;
    SelectedTime=millis();
  }
  void reset() {
    for (Star star : stars) {
      star.mode=0;
    }
    currentStar=null;
  }
  int getProgress() {
    return millis()-SelectedTime;
  }
  void setSelectedStar(Star star) {
    selectedStar=star;
  }
  boolean hasConstellation() {
    return con.stars.size()!=0;
  }
  void completeConstellation() {
    constellations.add(con);
    for (Constellation.Tuple t : con.stars) {
      ((Star)t.a).used=true;
      ((Star)t.b).used=true;
    }
    con.reset();
    con.complete=true;
    p.action();
    p.a=0;
    con=new Constellation();
    kira2.trigger();
  }

  void load() {
    String filename="starmap.dat";
    XML root=loadXML(filename);
    XML[] stars=root.getChild("stars").getChildren("star");
    for (XML star : stars) {
      this.stars.add(star.getInt("id"), new Star(new PVector(star.getFloat("x"), star.getFloat("y")), star.getFloat("r")));
    }
    root=loadXML("constellations.dat");
    XML[] constellations=root.getChild("constellations").getChildren("constellation");
    for (XML constellation : constellations) {
      Constellation c=new Constellation();
      for (XML t : constellation.getChildren("tuple")) {
        Star star1=this.stars.get(t.getInt("a"));
        Star star2=this.stars.get(t.getInt("b"));
        star1.used=true;
        star2.used=true;
        c.addTuple(star1, star2);
        c.complete=true;
      }
      this.constellations.add(c);
    }
  }
  void save() {
    XML root=new XML("data");
    XML constellations=new XML("constellations");
    for (Constellation con : this.constellations) {
      XML c=new XML("constellation");
      for (Constellation.Tuple tuple : con.stars) {
        XML t=new XML("tuple");
        t.setInt("a", this.stars.indexOf(tuple.a));
        t.setInt("b", this.stars.indexOf(tuple.b));
        c.addChild(t);
      }
      constellations.addChild(c);
    }
    root.addChild(constellations);
    saveXML(root, "constellations.dat");
  }
}