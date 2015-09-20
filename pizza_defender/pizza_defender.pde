import ddf.minim.*;
AudioPlayer music;
AudioPlayer laser;
Minim minim;
ArrayList <Asteroida> asteroidy = new ArrayList <Asteroida>();
ArrayList <Pocisk> pociski = new ArrayList <Pocisk>();
PImage ship;
PImage tlo;
PImage astimg;
PImage kirby;
int lastMillis = 0;
int time = 0;
float tloy = 1;
float polozx;
int score = 0;
int tempscore = 0;
int level = 1;
float xspeed = 1;
float yspeed = 1;
boolean lose=false;

void setup() {
  size (600, 600);
  frameRate (30);
  smooth();
  noCursor();
  ship = loadImage("kot.png");
  tlo = loadImage("tlo600.jpg");
  astimg = loadImage("pizza.png");
  kirby = loadImage("Kirby.gif");
  minim = new Minim(this);
  music = minim.loadFile("music.mp3", 2048);
  music.loop();
  laser = minim.loadFile("LASER.WAV", 512);
}

void draw() {
  if (lose) {
    textSize(50);
    fill(255,0,0);
    textAlign(CENTER);
    text("GAME OVER", width/2, height/2-60);
    text("SCORE: " + score, width/2, (height/2));
    }
  else {    
  tlo ();
  statek();
  spawn ();
  strzal ();
  moveAst();
  movePoc();
  hud ();
  update();
  time++;
  if (tempscore == 10) {
    tempscore = 0;
    level++;
    }
  }
}
  
void tlo() {
  tloy++;
  tloy%=height;
  imageMode(CORNER);
  image(tlo, 0, int(tloy));
  image(tlo.get(0, tlo.height-int(tloy), tlo.width, int(tloy)), 0, 0);
}

void statek () {
  polozx = mouseX;
  imageMode(CENTER);
  image (ship, polozx, height-50, 100, 100);
}
void moveAst () {
  for(int i = 0; i < asteroidy.size(); i++) {    
  Asteroida ast = (Asteroida)asteroidy.get(i);
  ast.move();
  ast.display();
  }
}

void movePoc () {
  for(int j = 0; j < pociski.size(); j++) {
      Pocisk poc = (Pocisk)pociski.get(j);
      poc.y=poc.y-5;
      poc.display();
      poc=null;
  }
}
  
void strzal () {
  if (mousePressed && millis()>lastMillis+400) {
    lastMillis = millis();
    Pocisk poc = new Pocisk (mouseX, height-100);
    pociski.add (poc);
    laser.play();
    laser.rewind();
  }
}

void hud () {
  textAlign(LEFT);
  fill(255);
  textSize(20);
  text("SCORE: " + score, 30,30);
  text("LEVEL: " + level, 30,60);
}

void spawn() {
  if (time == 15) {
  time = 0;
  Asteroida ast = new Asteroida();
  asteroidy.add(ast);
  }
}

void update () {
  for(int i = 0; i < asteroidy.size(); i++) {
    Asteroida ast = (Asteroida)asteroidy.get(i);
    if (dist (ast.location.x, ast.location.y, mouseX, height-50)<=ast.r) {
      lose=true;
    }
    for(int j = 0; j < pociski.size(); j++) {
      Pocisk poc = (Pocisk)pociski.get(j);
      if (dist(poc.x, poc.y, ast.location.x, ast.location.y)<=poc.r+ast.r) {
        asteroidy.remove(i);
        pociski.remove(j);
        score ++;
        tempscore++;
      }
    }
  }
}
class Asteroida {
  
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float topspeed;
  
  Asteroida () {
    location = new PVector(random(r,width-r), 0);
    velocity = new PVector(0,0);
    topspeed = 4*level;
    r = int (random(50,100));
    
    
  }
  void move() {
    PVector statek = new PVector(mouseX,height-50);
    PVector dir = PVector.sub(statek,location);
    dir.normalize();
    dir.mult(1);
    acceleration = dir;
    velocity.add(acceleration);
    velocity.limit(topspeed);
    location.add(velocity);
  }
    
  void display () {
    imageMode (CENTER);
    image (astimg, location.x, location.y, r, r);
  }
}

class Pocisk {
  float x, y, r;
  Pocisk (float tempx, float tempy) {
    x = tempx;
    y = tempy;
    r = 20;
  }
    
  void display () {
    imageMode(CENTER);
    image (kirby, x, y, r, r);
  }
}