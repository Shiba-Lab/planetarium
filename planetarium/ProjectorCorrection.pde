/* ver1.1
 *
 */


class ProjectorCorrection {
  private double[] parameter;
  private PVector[] i_corner;//左上,右上,右下,左下の順
  private PVector[] o_corner;//左上,右上,右下,左下の順
  private int onum;
  private int inum;
  ProjectorCorrection() {
    parameter=null;
    i_corner=null;
    o_corner=null;
    onum=0;
    inum=0;
  }
  boolean hasData() {
    if (parameter==null)return false;
    return true;
  }
  void setI_corner(PVector[] i_corner) {
    if (i_corner.length!=4) {
      println("please set 4 points");
      return;
    }
    this.i_corner=i_corner.clone();
    if (o_corner!=null)
      computeParameter();
  }
  void setI_corner(float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3) {
    setI_corner(new PVector[]{new PVector(x0, y0), new PVector(x1, y1), new PVector(x2, y2), new PVector(x3, y3)});
  }
  void setO_corner(PVector[] o_corner) {
    if (o_corner.length!=4) {
      println("please set 4 points");
      return;
    }
    this.o_corner=o_corner.clone();
    if (i_corner!=null)
      computeParameter();
  }
  
  PVector[] getI_corner(){
    return i_corner;
  }
  PVector[] getO_corner(){
    return o_corner;
  }
  void setO_corner(float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3) {
    setO_corner(new PVector[]{new PVector(x0, y0), new PVector(x1, y1), new PVector(x2, y2), new PVector(x3, y3)});
  }
  void clearI_corner() {
    i_corner=null;
    //parameter=null;
    inum=0;
  }
  void clearO_corner() {
    o_corner=null;
    //parameter=null;
    onum=0;
  }
  void addI_corner(PVector p) {//順番に変換前の4隅のポイントを追加する
    if (inum>=4) {
      println("4 points have been already input");
      return;
    }
    if (i_corner==null)i_corner=new PVector[4];
    i_corner[inum]=p.copy();
    print(i_corner[inum]+" ");
    switch(inum) {
    case 0:
      println("added top-left point");
      break;
    case 1:
      println("added bottom-left point");
      break;
    case 2:
      println("added bottom-right point");
      break;
    case 3:
      println("added top-right point");
      break;
    }
    inum++;
    if (inum==4) {
      computeParameter();
    }
  }
  void addI_corner(float x, float y) {
    addI_corner(new PVector(x, y));
  }
  void addO_corner(PVector p) {//順番に変換前の4隅のポイントを追加する
    if (onum>=4) {
      println("4 points have been already input");
      return;
    }
    if (o_corner==null)o_corner=new PVector[4];
    o_corner[onum]=p.copy();
    print(o_corner[onum]+" ");
    switch(onum) {
    case 0:
      println("added top-left point");
      break;
    case 1:
      println("added bottom-left point");
      break;
    case 2:
      println("added bottom-right point");
      break;
    case 3:
      println("added top-right point");
      break;
    }
    onum++;
    if (onum==4) {
      computeParameter();
    }
  }
  void addO_corner(float x, float y) {
    addO_corner(new PVector(x, y));
  }
  void computeParameter() {//変換用のパラメータを計算する関数
    Matrix m=new Matrix(new float[][]{  
      {i_corner[0].x, i_corner[0].y, 1, 0, 0, 0, -o_corner[0].x*i_corner[0].x, -o_corner[0].x*i_corner[0].y}, 
      {i_corner[1].x, i_corner[1].y, 1, 0, 0, 0, -o_corner[1].x*i_corner[1].x, -o_corner[1].x*i_corner[1].y}, 
      {i_corner[2].x, i_corner[2].y, 1, 0, 0, 0, -o_corner[2].x*i_corner[2].x, -o_corner[2].x*i_corner[2].y}, 
      {i_corner[3].x, i_corner[3].y, 1, 0, 0, 0, -o_corner[3].x*i_corner[3].x, -o_corner[3].x*i_corner[3].y}, 
      {0, 0, 0, i_corner[0].x, i_corner[0].y, 1, -o_corner[0].y*i_corner[0].x, -o_corner[0].y*i_corner[0].y}, 
      {0, 0, 0, i_corner[1].x, i_corner[1].y, 1, -o_corner[1].y*i_corner[1].x, -o_corner[1].y*i_corner[1].y}, 
      {0, 0, 0, i_corner[2].x, i_corner[2].y, 1, -o_corner[2].y*i_corner[2].x, -o_corner[2].y*i_corner[2].y}, 
      {0, 0, 0, i_corner[3].x, i_corner[3].y, 1, -o_corner[3].y*i_corner[3].x, -o_corner[3].y*i_corner[3].y}});
    Matrix inv_m=m.inverse();
    parameter=inv_m.mul(new float[]{o_corner[0].x, o_corner[1].x, o_corner[2].x, o_corner[3].x, o_corner[0].y, o_corner[1].y, o_corner[2].y, o_corner[3].y});
    println("success update parameter");
  }
  PVector adapt(PVector input) {//入力に対して変換後の座標を返す関数
    if (parameter==null)return input;
    float x=(float)((parameter[0]*input.x+parameter[1]*input.y+parameter[2])/(parameter[6]*input.x+parameter[7]*input.y+1));
    float y=(float)((parameter[3]*input.x+parameter[4]*input.y+parameter[5])/(parameter[6]*input.x+parameter[7]*input.y+1));
    return new PVector(x, y);
  }
  PVector adapt(float x, float y) {
    return adapt(new PVector(x, y));
  }
  //各種数値をsave, loadする関数
  void load(String filename) {
    clearI_corner();
    XML root=loadXML(filename);
    XML[] i_cornerXML=root.getChildren("i_corner");
    for (int i=0; i<i_cornerXML.length; i++) {
      addI_corner(new PVector(i_cornerXML[i].getFloat("x"), i_cornerXML[i].getFloat("y")));
    }
    XML[] o_cornerXML=root.getChildren("o_corner");
    for (int i=0; i<o_cornerXML.length; i++) {
      addO_corner(new PVector(o_cornerXML[i].getFloat("x"), o_cornerXML[i].getFloat("y")));
    }
  }
  void load() {
    load("corner_data.xml");
    println("corner_data.xml "+"loaded!");
    computeParameter();
  }
  void save(String filename) {
    XML root=new XML("data");
    for (PVector c : i_corner) {
      XML i_corner=new XML("i_corner");
      i_corner.setFloat("x", c.x);
      i_corner.setFloat("y", c.y);
      root.addChild(i_corner);
    }
    for (PVector c : o_corner) {
      XML o_corner=new XML("o_corner");
      o_corner.setFloat("x", c.x);
      o_corner.setFloat("y", c.y);
      root.addChild(o_corner);
    }
    saveXML(root, filename);
  }
  void save() {
    save("corner_data.xml");
    println("corner_data.xml "+"saved!");
  }
  void expand() {
    i_corner=expandP(i_corner, 1);
    computeParameter();
  }
  void contract() {
    i_corner=expandP(i_corner, -1);
    computeParameter();
  }
  
}

PVector[] expandP(PVector[] p, float d) {
  PVector[] np=new PVector[p.length];
  PVector c=new PVector();
  for (int i=0; i<p.length; i++) {
    c.add(p[i]);
  }
  c.div(p.length);
  for (int i=0; i<p.length; i++) {
    np[i]=PVector.add(p[i], (PVector.sub(p[i], c).normalize().mult(d)));
  }
  return np;
}