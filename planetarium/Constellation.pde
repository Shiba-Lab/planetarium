class Constellation {
  List<Tuple> stars;
  boolean complete;
  float progress=0;
  Constellation() {
    stars=new ArrayList<Tuple>();
  }
  void addTuple(Star a, Star b) {
    stars.add(new Tuple<Star>(a, b));
  }
  void display() {
    if (!complete)
      progress++;
    for (Tuple<Star> t : stars) {
      //if (complete)
        strokeWeight(1);
      //else
      //  strokeWeight(max(1, progress/10.0));
      stroke(130);
      PVector pos1=t.a.pos;
      PVector pos2=t.b.pos;
      if (pos1.x<0||pos1.x>width||pos1.y<0||pos1.y>height)
        return;
      line(pos1.x, pos1.y, pos2.x, pos2.y);
    }
  }
  void reset() {
    progress=0;
  }
  class Tuple<T> {
    T a;
    T b;
    Tuple(T a, T b) {
      this.a=a;
      this.b=b;
    }
  }
}