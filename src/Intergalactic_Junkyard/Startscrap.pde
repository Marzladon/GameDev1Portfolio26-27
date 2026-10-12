class Startscrap {
  //Memeber Variables

  int x, y, size, health;
  PImage startscrap;

  //Constructor

  Startscrap(int x, int y) {
    this.x = x;
    this.y = y;
    health = 50;
    startscrap = loadImage("Start?.png");
    size = 100;
  }

  //Member Methods
  void display() {
    imageMode(CENTER);
    image(startscrap, x, y, 256, 64);
  }
  boolean isOffScreen() {
    if (y>height+50) {
      return true;
    } else {
      return false;
    }
  }
  boolean isHit(Laser l) {
    float dis = dist(x, y, l.x, l.y);
    if (dis<50) {
      return true;
    } else {
      return false;
    }
  }
  void laserhit() {
    health = health - 50;
  }
}
