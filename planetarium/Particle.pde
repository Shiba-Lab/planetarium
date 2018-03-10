class Particles {
  final int MAX_PARTICLE = 15;  //  パーティクルの個数
  Particle[] p = new Particle[MAX_PARTICLE];
  float a=255;
  final int LIGHT_FORCE_RATIO = 5;  //  輝き具体の抑制値
  final int LIGHT_DISTANCE= 75 * 75;  //  光が届く距離
  final int BORDER = 75;  //  光の計算する矩形範囲（高速化のため）

  float baseRed, baseGreen, baseBlue;  //  光の色
  float baseRedAdd, baseGreenAdd, baseBlueAdd;  //  光の色の加算量
  final float RED_ADD = 1.2;    //  赤色の加算値
  final float GREEN_ADD = 1.7;  //  緑色の加算値
  final float BLUE_ADD = 2.3;   //  青色の加算値
  PVector pos;
  void setPosition(float x, float y) {
    pos.set(x, y);
  }
  Particles() {
    pos=new PVector();
    for (int i = 0; i < MAX_PARTICLE; i++) {
      p[i] = new Particle();
    }

    //  光の色の初期化
    baseRed = 0;
    baseRedAdd = RED_ADD;

    baseGreen = 0;
    baseGreenAdd = GREEN_ADD;

    baseBlue = 0;
    baseBlueAdd = BLUE_ADD;
  }
  void display() {

    //  光の色を変更
    baseRed += baseRedAdd;
    baseGreen += baseGreenAdd;
    baseBlue += baseBlueAdd;

    //  色が範囲外になった場合は、色の加算値を逆転させる
    colorOutCheck();

    //  パーティクルの移動
    for (int pid = 0; pid < MAX_PARTICLE; pid++) {
      p[pid].move(pos.x, pos.y);
    }

    //  各ピクセルの色の計算
    int tRed = (int)baseRed;
    int tGreen = (int)baseGreen;
    int tBlue = (int)baseBlue;

    //  綺麗に光を出すために二乗する
    tRed *= tRed;
    tGreen *= tGreen;
    tBlue *= tBlue;

    //  各パーティクルの周囲のピクセルの色について、加算を行う
    loadPixels();
    for (int pid = 0; pid < MAX_PARTICLE; pid++) {

      //  パーティクルの計算影響範囲
      int left = max(0, p[pid].x - BORDER);
      int right = min(width, p[pid].x + BORDER);
      int top = max(0, p[pid].y - BORDER);
      int bottom = min(height, p[pid].y + BORDER);

      //  パーティクルの影響範囲のピクセルについて、色の加算を行う
      for (int y = top; y < bottom; y++) {
        for (int x = left; x < right; x++) {
          int pixelIndex = x + y * width;

          //  ピクセルから、赤・緑・青の要素を取りだす
          int r = pixels[pixelIndex] >> 16 & 0xFF;
          int g = pixels[pixelIndex] >> 8 & 0xFF;
          int b = pixels[pixelIndex] & 0xFF;

          //  パーティクルとピクセルとの距離を計算する
          int dx = x - p[pid].x;
          int dy = y - p[pid].y;
          int distance = (dx * dx) + (dy * dy);  //  三平方の定理だが、高速化のため、sqrt()はしない。

          //  ピクセルとパーティクルの距離が一定以内であれば、色の加算を行う
          if (distance < LIGHT_DISTANCE) {
            int fixFistance = distance * LIGHT_FORCE_RATIO;
            //  0除算の回避
            if (fixFistance == 0) {
              fixFistance = 1;
            }   
            r = r + tRed / fixFistance;
            g = g + tGreen / fixFistance;
            b = b + tBlue / fixFistance;
          }

          //  ピクセルの色を変更する
          pixels[x + y * width] = color(r, g, b);
        }
      }
    }
    updatePixels();
  }
  void action() {
    for (int pid = 0; pid < MAX_PARTICLE; pid++) {
      p[pid].explode();
    }
  }
  void colorOutCheck() {
    if (baseRed < 10) {
      baseRed = 10;
      baseRedAdd *= -1;
    } else if (baseRed > 255) {
      baseRed = 255;
      baseRedAdd *= -1;
    }

    if (baseGreen < 10) {
      baseGreen = 10;
      baseGreenAdd *= -1;
    } else if (baseGreen > 255) {
      baseGreen = 255;
      baseGreenAdd *= -1;
    }

    if (baseBlue < 10) {
      baseBlue = 10;
      baseBlueAdd *= -1;
    } else if (baseBlue > 255) {
      baseBlue = 255;
      baseBlueAdd *= -1;
    }
  }
}

class Particle {
  int x, y;        //  位置
  float vx, vy;    //  速度
  float slowLevel; //  座標追従遅延レベル
  final float DECEL_RATIO = 0.99;  //  減速率

  Particle() {
    x = (int)random(width);
    y = (int)random(height);
    slowLevel = random(50) + 5;
  }

  //  移動
  void move(float targetX, float targetY) {

    //  ターゲットに向かって動こうとする
    vx = vx * DECEL_RATIO + (targetX - x) / slowLevel;
    vy = vy * DECEL_RATIO + (targetY - y) / slowLevel;

    //  座標を移動
    x = (int)(x + vx);
    y = (int)(y + vy);
  }

  //  適当な方向に飛び散る
  void explode() {
    vx = random(100) - 50;
    vy = random(100) - 50;
    slowLevel = random(100) + 5;
  }
}