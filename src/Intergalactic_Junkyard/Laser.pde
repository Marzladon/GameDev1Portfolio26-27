import gifAnimation.*;
import processing.sound.*;

class Laser {
  //Member Variables
  int x, y, w, h, speed, damage;
  Gif laser;
  //Constructor
  Laser(int x, int y, PApplet parent) {
    this.x = x;
    this.y = y;
    laser = new Gif(parent, "Laser.gif");
    laser.loop();
    w = 10;
    h = 20;
    speed = 15;
    damage = 50;
  }
  //Member Methods
  void display() {
    //fill(256, 0, 0);
    //rectMode(CENTER);
    //rect(x, y, w, h);
    imageMode(CENTER);
    image(laser, x, y);
  }
  void fire() {
    y = y - speed;
  }
  boolean isOffScreen() {
    if (y<-50) {
      return true;
    } else {
      return false;
    }
  }
}
