// Marz Meyer | Sep 16 26 | Interglactic_Junkyard
import gifAnimation.*;
import processing.sound.*;

ArrayList<Debris> debrisfield = new ArrayList<Debris>();
ArrayList<Startscrap> starts = new ArrayList<Startscrap>();
ArrayList<PowerUp> powerups = new ArrayList<PowerUp>();
ArrayList<Laser> lasers = new ArrayList<Laser>();
//ArrayList<Star> starfield = new ArrayList<Star>();
int score, lives, pwrupcooldown;
PImage background;
PImage gameover;
PImage cursor;
boolean gamestarted;
SoundFile laserfire;
SoundFile shiphit;
SoundFile debrishit;
SoundFile lifelost;
SoundFile powerup;
Timer debDist;
Timer pwrDist;
//Timer startime;
Scrapship ship01;

int y;
void setup() {
  frameRate(30);
  size(700, 900);
  background = loadImage("Background.png");
  gameover = loadImage("Gameover.png");
  cursor = loadImage("Cursor.png");
  pwrupcooldown = 0;
  ship01 = new Scrapship(width/2, height/4, this);
  starts.add(new Startscrap(width/2, height/2));
  //debrisfield.add(new Debris(int(random(width)), -100));
  //powerups.add(new PowerUp(int(random(width)), -100));
  gamestarted = false;
  //sounds
  laserfire = new SoundFile(this, "laserfire.mp3");
  shiphit = new SoundFile(this, "shiphit.mp3");
  debrishit = new SoundFile(this, "debrishit.mp3");
  lifelost = new SoundFile(this, "lifelost.mp3");
  powerup = new SoundFile(this, "powerup.mp3");

  //timers
  debDist = new Timer(1800);
  //startime = new Timer(500);
  pwrDist = new Timer(8000);
  debDist.start();
  //startime.start();
  score = 0;
  lives = 3;
  ship01.health = 200;
}
void draw() {
  noCursor();
  background(background);
  if (ship01.health<1) {
    score = 0;
    ship01.health = 100;
  }
  if (pwrupcooldown == 4) {
    ship01.lasercount = 2;
  }
  if (gamestarted == true) {
    //debris timer
    if (debDist.isFinished() == true) {
      debrisfield.add(new Debris(int(random(width)), -100));
      debDist.start();
    }
    //powerup timer
    if (pwrDist.isFinished() == true) {
      powerups.add(new PowerUp(int(random(width)), -100));
      pwrDist.start();
    }
    //star timer
    //  if (startime.isFinished() == true) {
    //  starfield.add(new Star(int(random(width)), -100));
    //  startime.start();
    //}
  }
  //startscrap forloop
  for (int i = 0; i < starts.size(); i++) {
    println("Startscrap: " + starts.size());
    Startscrap s = starts.get(i);
    s.display();
    if (s.health<1) {
      starts.remove(s);
      debrishit.play();
    }
  }
  //debrisforloop
  for (int i = 0; i < debrisfield.size(); i++) {
    println("Debris: " + debrisfield.size());
    Debris d = debrisfield.get(i);
    d.display();
    if (gamestarted == true) {
      d.move();
    }
    if (ship01.isHit(d)) {
      debrisfield.remove(d);
      shiphit.play();
      ship01.health = ship01.health -25;
    }
    if (d.health<1) {
      debrisfield.remove(d);
      debrishit.play();
      score = score+d.value;
      pwrupcooldown ++;
    }
    if (d.isOffScreen() == true) {

      debrisfield.remove(d);
      lives--;
      lifelost.play();
    }
  }
  //powerupforloop
  for (int i = 0; i < powerups.size(); i++) {
    println("Powerups:" + powerups.size());
    PowerUp p = powerups.get(i);

    p.display();
    p.move();
    if (p.isHit(ship01)) {
      powerups.remove(p);
      powerup.play();
      if (p.powtype == 1) {
        ship01.health = ship01.health +50;
      } else if (p.powtype == 2) {
        ship01.lasercount += 1;
        pwrupcooldown = 0;
      }
    }
    if (p.isOffScreen() == true) {
      powerups.remove(p);
    }
  }
  //laserforloop
  for (int i = 0; i < lasers.size(); i++) {
    println("Lasers: " + lasers.size());
    Laser l = lasers.get(i);
    for (int j = 0; j < debrisfield.size(); j++) {
      Debris d = debrisfield.get(j);
      if (d.isHit(l)) {
        lasers.remove(l);
        d.laserhit();
        //score = score+d.value;
      }
    }
    for (int k = 0; k < starts.size(); k++) {
      Startscrap s = starts.get(k);
      if (s.isHit(l)) {
        lasers.remove(l);
        s.laserhit();
        gamestarted = true;
      }
    }
    l.display();
    l.fire();

    if (l.isOffScreen() == true) {
      lasers.remove(l);
    }
  }
  //starforloop
  //for (int i = 0; i < starfield.size(); i++) {
  //  println(starfield.size());
  //  Star s = starfield.get(i);
  //  s.display();
  //  s.move();

  //  if (s.isOffScreen() == true) {
  //    powerups.remove(s);
  //  }
  //}

  ship01.display();
  ship01.move(mouseX, 850);
  infoPanel();
  image(cursor,mouseX,mouseY);
  //gameover sequence
  if (lives==0) {
    image(gameover, width/2, height/2);
    text("FINAL SCORE: $" + score, width/2, height/6);
    gamestarted = false;
  }
}

void mousePressed() {
  if (ship01.lasercount == 2) {
    lasers.add(new Laser(ship01.x, ship01.y, this));
    laserfire.play();
  } else if (ship01.lasercount > 2) {
    lasers.add(new Laser(ship01.x+10, ship01.y, this));
    lasers.add(new Laser(ship01.x-10, ship01.y, this));
    laserfire.play();
  }
}
void infoPanel() {
  rectMode(CORNER);
  fill(127, 127);
  rect(0, 0, width, 50);
  fill(256, 256, 256);
  textSize(32);
  text("Money:$ " + score, 75, 25);
  text("Lives Left:" + lives, width-100, 25);
  text("Health:" + ship01.health, 275, 25);
}
