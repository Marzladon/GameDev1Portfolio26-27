class Debris {
  //Memeber Variables

  int x, y, health, size, value, speed;
  PImage debris;

  //Constructor

  Debris(int x, int y) {
    this.x = x;
    this.y = y;
    size = int(random(50, 75));
    health = int(random(100, 300));
    value = int(random(10, 25));
    speed = int(random(3, 9));
    debris = loadImage("Debris.png");
  }

  //Member Methods
  void display() {
    imageMode(CENTER);
    image(debris, x, y, size, size);
    textAlign(CENTER, CENTER);
    fill(256, 256, 256);
    text(health, x, y);
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
