//行列計算を行うクラス
class Matrix {
  double [][] a;
  int n;
  Matrix(float[][] a) {
    n=a.length;
    this.a=new double[n][n];
    for (int i=0; i<n; i++) {
      for (int j=0; j<n; j++) {
        this.a[i][j]=a[i][j];
      }
    }
  }
  Matrix(double[][] a) {
    n=a.length;
    this.a=a;
  }
  double[] mul(float[] b) {
    double[] ans=new double[b.length];
    for (int i=0; i<n; i++) {
      for (int j=0; j<b.length; j++) {
        ans[i]+=a[i][j]*b[j];
      }
    }
    return ans;
  }

  Matrix inverse() {
    double[][] inv_a=new double[n][n*2];
    //単位行列を作る
    for (int i=0; i<n; i++) {
      for (int j=0; j<n; j++) {
        inv_a[i][j]=a[i][j];
      }
      for (int j=n; j<n*2; j++) {
        inv_a[i][j]=(i+n==j)?1.0:0.0;
      }
    }

    for (int i=0; i<n; i++) {
      pivot(i, inv_a);
      sweep(i, inv_a);
    }
    float[][] inv_b=new float[n][n];
    for (int i=0; i<n; i++) {
      for (int j=n; j<n*2; j++) {
        inv_b[i][j-n]=(float)inv_a[i][j];
      }
    }
    return new Matrix(inv_b);
  }

  double[][] pivot(int k, double a[][]) {
    double max, copy;
    //ipは絶対値最大となるk列の要素の存在する行を示す変数で、
    //とりあえずk行とする
    int ip=k;
    //k列の要素のうち絶対値最大のものを示す変数maxの値をとりあえず
    //max=|a[k][k]|とする
    max=Math.abs(a[k][k]);
    //k+1行以降、最後の行まで、|a[i][k]|の最大値とそれが存在する行を
    //調べる
    for (int i=k+1; i<n; i++) {       
      if (max<Math.abs(a[i][k])) {
        ip=i;
        max=Math.abs(a[i][k]);
      }
    }
    if (ip!=k) {
      for (int j=0; j<2*n; j++) {
        //入れ替え作業
        copy    =a[ip][j];
        a[ip][j]=a[k][j];
        a[k][j] =copy;
      }
    }
    return a;
  }

  //ガウス・ジョルダン法により、消去演算を行う
  double[][] sweep(int k, double a[][]) {
    double piv, mmm;
    //枢軸要素をpivとおく
    piv=a[k][k];
    //k行の要素をすべてpivで割る a[k][k]=1となる
    for (int j=0; j<2*n; j++)
      a[k][j]=a[k][j]/piv;
    //    
    for (int i=0; i<n; i++) {
      mmm=a[i][k];
      //a[k][k]=1で、それ以外のk列要素は0となる
      //k行以外
      if (i!=k) {
        //i行において、k列から2N-1列まで行う        
        for (int j=k; j<2*n; j++)
          a[i][j]=a[i][j]-mmm*a[k][j];
      }
    }
    return a;
  }
  void draw() {
    for (double[] x : a) {
      print("[");
      for (double y : x) {
        print(String.format("%e\t", y));
      }
      println("]");
    }
  }
}