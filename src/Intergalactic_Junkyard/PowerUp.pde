class PowerUp {
  //Memeber Variables

  int x, y, value, speed, powtype;
  PImage powerup;
  char type;
  //Constructor

  PowerUp(int x, int y) {
    this.x = x;
    this.y = y;
    value = int(random(10, 25));
    speed = int(random(10, 20));
    powerup = loadImage("PowerUp.gif");
    if (random(2)>1.0) {
      type = 'H';
      powtype = 1;
    } else {
      type = 'D';
      powtype = 2;
    }
  }

  //Member Methods
  void display() {
    imageMode(CENTER);
    image(powerup, x, y, 48, 48);
    textAlign(CENTER, CENTER);
    text(type, x, y - 30);
  }

  void move() {
    y = y + speed;
  }
  boolean isOffScreen() {
    if (y>height+50) {
      return true;
    } else {
      return false;
    }
  }
  boolean isHit(Scrapship s) {
    float dis = dist(x, y, s.x, s.y);
    if (dis<32) {
      return true;
    } else {
      return false;
    }
  }
}
