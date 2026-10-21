// Marz Meyer | Sep 16 26 | Interglactic_Junkyard
import gifAnimation.*;
import processing.sound.*;
JSONObject highScore;
JSONObject loadScore;
ArrayList<Debris> debrisfield = new ArrayList<Debris>();
ArrayList<Startscrap> starts = new ArrayList<Startscrap>();
ArrayList<PowerUp> powerups = new ArrayList<PowerUp>();
ArrayList<Laser> lasers = new ArrayList<Laser>();
//ArrayList<Star> starfield = new ArrayList<Star>();
int balance, lives, pwrupcooldown, debrisfreq, laserdamage, level, score, hiscore;
PImage background;
PImage gameover;
PImage cursor;
PImage dashboard;
PImage shop;
PImage scoreboard;
boolean gamestarted;
boolean initialstart;
boolean shopup;
SoundFile laserfire;
SoundFile shiphit;
SoundFile debrishit;
SoundFile lifelost;
SoundFile powerup;
Timer debDist;
Timer pwrDist;
Timer difficulty;
Timer oneSec;
//Timer startime;
Scrapship ship01;

int y;
void setup() {
  loadScore = loadJSONObject("data/hscore.json");
  hiscore = loadScore.getInt("highScore");
  pixelDensity(1);
  frameRate(30);
  size(700, 900);
  background = loadImage("Background.png");
  gameover = loadImage("Gameover.png");
  cursor = loadImage("Cursor.png");
  dashboard = loadImage("dashboard.png");
  shop = loadImage("Shop.png");
  scoreboard = loadImage("Scoreboard.png");
  pwrupcooldown = 0;
  debrisfreq = 1800;
  laserdamage = 50;
  level = 0;
  textSize(25);
  ship01 = new Scrapship(width/2, height/4, this);
  starts.add(new Startscrap(width/2, height/2));
  //debrisfield.add(new Debris(int(random(width)), -100));
  //powerups.add(new PowerUp(int(random(width)), -100));
  gamestarted = false;
  initialstart = false;
  shopup =false;
  //sounds
  laserfire = new SoundFile(this, "laserfire.mp3");
  shiphit = new SoundFile(this, "shiphit.mp3");
  debrishit = new SoundFile(this, "debrishit.mp3");
  lifelost = new SoundFile(this, "lifelost.mp3");
  powerup = new SoundFile(this, "powerup.mp3");

  //timers
  oneSec = new Timer(1000);
  difficulty = new Timer(30000);
  debDist = new Timer(debrisfreq);
  //startime = new Timer(500);
  pwrDist = new Timer(8000);
  debDist.start();
  //startime.start();
  balance = 0;
  lives = 3;
  ship01.health = 200;
}
void draw() {
  if (score > hiscore) {
    hiscore = score;
    scoreboard = loadImage("NewHighScore.png");
  }else{scoreboard = loadImage("Scoreboard.png");}
  noCursor();
  background(background);

  //ship logic
  if (ship01.health<1) {
    balance = 0;
    ship01.health = 100;
  }
  if (pwrupcooldown == 4) {
    ship01.lasercount = 2;
  }
  if (gamestarted == true) {
    //difficulty timer
    if (difficulty.isFinished() == true) {
      debrisfreq = debrisfreq-100;
      oneSec.start();
      debDist.setTime(debrisfreq);
      level = level + 1;
      score = score + 200;
      balance += 150;
      difficulty.start();
    }
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
    //println("Startscrap: " + starts.size());
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
      score -= 10;
      debrisfield.remove(d);
      shiphit.play();
      ship01.health = ship01.health -25;
    }
    if (d.health<1) {
      debrisfield.remove(d);
      debrishit.play();
      balance = balance+d.value;
      pwrupcooldown ++;
      score += 25;
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
      score += 15;
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

    //println("Lasers: " + lasers.size());
    Laser l = lasers.get(i);
    l.damage = laserdamage;
    for (int j = 0; j < debrisfield.size(); j++) {
      Debris d = debrisfield.get(j);
      if (gamestarted == true) {
        if (d.isHit(l)) {
          score +=5;
          lasers.remove(l);
          d.laserhit(l);
          shiphit.play();
          //score = score+d.value;
        }
      }
    }
    for (int k = 0; k < starts.size(); k++) {
      Startscrap s = starts.get(k);
      if (s.isHit(l)) {
        lasers.remove(l);
        s.laserhit();
        gamestarted = true;
        initialstart = true;
      }
    }
    l.display();
    l.fire();

    if (l.isOffScreen() == true) {
      lasers.remove(l);
    }
  }
  ship01.display();
  ship01.move(mouseX, 700);
  infoPanel();
  if (shopup == true) {
    shoppanel();
  }

  //gameover sequence
  if (lives==0) {

    image(gameover, width/2, height/2);
    text("FINAL BALANCE: $" + balance, width/2, height/6);
    text("FINAL SCORE: " + score, width/2, height/6 - 50);
    text("HIGH SCORE: " + hiscore, width/2, height/6 - 25);
    text("PRESS R TO RESTART", width/2, 800);
    gamestarted = false;
    shopup = false;
     highScore = new JSONObject();
      highScore.setInt("highScore", hiscore);
      saveJSONObject(highScore, "data/hscore.json");
  }
  image(cursor, mouseX, mouseY);
  if (oneSec.isFinished() == false) {
    if (gamestarted == true) {
      textSize(64);
      text("LEVEL: " + level, width/2, height/2);
      textSize(20);
    }
  }
}
//restart function
void keyPressed() {
  if (lives == 0) {
    if (key == 'r') {
     
      debrisfield.clear();
      powerups.clear();
      lives = lives + 3;
      ship01.health = 200;
      balance = 0;
      level = 0;
      laserdamage = 50;
      score = 0;
      initialstart = false;
      starts.add(new Startscrap(width/2, height/2));
    }
  }
}
void mousePressed() {
  println("Mousex" + mouseX);
  println("Mousey" + mouseY);
  if (mouseX >= 558 && mouseX <= 644 &&
    mouseY >= 785 && mouseY <= 855) {
    shopup = !shopup;
    if (initialstart == true) {
      gamestarted = !gamestarted;
    }
  }

  if (balance>= 250) {
    if (mouseX >= 526 && mouseX <=600  &&
      mouseY >= 587 && mouseY <=600 ) {
      ship01.health = ship01.health + 50;
      balance = balance - 250;
    }
  }

  if (balance>= 500) {
    if (mouseX >= 526 && mouseX <=600  &&
      mouseY >= 610 && mouseY <=630 ) {
      balance = balance - 500;
      laserdamage = laserdamage + 25;
    }
  }
  if (balance>= 300) {
    if (mouseX >= 526 && mouseX <=600  &&
      mouseY >= 650 && mouseY <=670 ) {
      balance = balance - 300;
      powerups.add(new PowerUp(int(random(width)), -100));
    }
  }
  if (gamestarted == true) {
    if (ship01.lasercount == 2) {
      lasers.add(new Laser(ship01.x, ship01.y, this));
      laserfire.play();
    } else if (ship01.lasercount > 2) {
      lasers.add(new Laser(ship01.x+10, ship01.y, this));
      lasers.add(new Laser(ship01.x-10, ship01.y, this));
      laserfire.play();
    }
  } else if (initialstart == false) {
    if (ship01.lasercount == 2) {
      lasers.add(new Laser(ship01.x, ship01.y, this));
      laserfire.play();
    } else if (ship01.lasercount > 2) {
      lasers.add(new Laser(ship01.x+10, ship01.y, this));
      lasers.add(new Laser(ship01.x-10, ship01.y, this));
      laserfire.play();
    }
  }
}
void infoPanel() {
  imageMode(CORNER);
  image(scoreboard, 0, 0);
  imageMode(CENTER);
  image(dashboard, width/2, 825);
  fill(0, 256, 50);
  textSize(25);
  text(balance, 137, 850);
  text(lives, 78, 790);
  text(ship01.health, 285, 850);
  textSize(23);
  text(score, 195, 30);
    textSize(20);
  text(hiscore, 125, 78);
}

void shoppanel() {
  image(shop, 600, 650);
  textSize(20);
  text("+50  HP            250", 597, 592);
  text("+25DMG          500", 597, 625);
  text("PWRUP           300", 597, 656);
}
