class Star {
  //Memeber Variables

  int x, y, size, speed;
  PImage star;

  //Constructor

  Star(int x, int y) {
    this.x = x;
    this.y = y;
    size = int(random(200, 450));
    speed = int(random(3, 6));
    star = loadImage("Star.png");
  }

  //Member Methods
  void display() {
    imageMode(CENTER);
    image(star, x, y, size, size);
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
}
