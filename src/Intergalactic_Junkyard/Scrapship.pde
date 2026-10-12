import gifAnimation.*;
import processing.sound.*;
class Scrapship {
  // Member Variables
  int x, y, health, lasercount;
  Gif ship1;

  //Constructor

  Scrapship(int x, int y, PApplet parent) {
    this.x = x;
    this.y = y;
    ship1 = new Gif(parent, "Scrapship.gif");
    ship1.loop();
    lasercount = 2;
  }

  //Member Methods
  void display() {
    imageMode(CENTER);
    image(ship1, x, y);
  }

  void move(int tempX, int tempY) {
    x = tempX;
    y = tempY;
  }

  boolean isHit(Debris d) {
    float dis = dist(x, y, d.x, d.y);
    if (dis<d.size) {
      return true;
    } else {
      return false;
    }
  }
}
