
static int BULLET_SIZE= 40;
static int MAX_SPEED = 7;
static int BULLET_SPEED = 10;
static int MAX_ASTERIODS = 100;

float xpos = 320;
float ypos = 240;

float angle = 0;
PImage img;
PImage asteroid;
PGraphics bg;
int speed = 0;

int bulletCount = 0;
float [][] bullet = new float[BULLET_SIZE][3];

float [][] asteriods = new float[MAX_ASTERIODS][4];

int bulletSpeed = 15;

void setup() {
  size(640, 480);
  background(0);

  img = loadImage("/home/jens/Scratches/asteroids/sprites/glider.png");
  asteroid = loadImage("/home/jens/Scratches/asteroids/sprites/asteroid-clipart-white-background.png");
  createBackground();
  initializeAsteriods();
} 

void initializeAsteriods() {
  for (int i=0;i<MAX_ASTERIODS;i++) {
     asteriods[i]=new float[]{0,0,90,5};
  }
}

void createBackground() {
  bg = createGraphics(width, height);       
  bg.beginDraw();
  bg.background(0);
  
  for (int i=0; i<1000; i++) {
    int x = (int) random(640);
    int y = (int) random(480);
    int s = (int) random(5); 

    bg.ellipse(x, y, s, s);
  }
  bg.endDraw();
}

void keyPressed() {
   if (keyCode == LEFT) {
     angle = (angle - 10) % 380;
   } else if (keyCode == RIGHT) {
     angle = (angle + 10) % 380; 
   } else if (keyCode == UP) {
     speed = speed<MAX_SPEED?speed+1:speed;
   } else if (keyCode == DOWN) { 
     speed = speed>-MAX_SPEED?speed-1:speed;
   } else if (keyCode == 32) {
     bullet[bulletCount++%BULLET_SIZE]=new float[]{xpos, ypos, angle};
   }
}

void draw() {
  background(bg);
  
  //Bullets
  for (int i=0;i<BULLET_SIZE;i++) {
     float bulletAngle = bullet[i][2];
     bullet[i][0] = (sin(radians(bulletAngle)) * BULLET_SPEED + bullet[i][0]);
     bullet[i][1] = (-cos(radians(bulletAngle)) * BULLET_SPEED + bullet[i][1]);
     color(255);
     ellipse(bullet[i][0], bullet[i][1],3,3);                                                                                        
  }
 
  //Everthing for the GLIDER
  // nonlineare Bewegung des Bildes zur Maus
  xpos = (sin(radians(angle)) * speed + xpos) % width;
  ypos = (-cos(radians(angle)) * speed + ypos) % height;
  
  if (xpos<0) {
    xpos = width;
  } 
  
  if (ypos<0) {
    ypos = height; 
  }
  

  // Koordinatensystem in Richtung
  // der Maus verschieben
  pushMatrix();
  translate (xpos, ypos);

  // Winkel zwischen Dreick und Maus berechnenh
  //float angle = atan2 (mouseY - ypos, mouseX - xpos) + PI/2;

  // Koordinatensystem rotieren
  rotate (radians(angle));
  translate(- 16, - 16);
  image(img, 0, 0, 32, 32);
  popMatrix();
     
  //Asteriod
  for(int i=0;i<MAX_ASTERIODS;i++){
     pushMatrix();
     float asteriodAngle = asteriods[i][2];
     asteriods[i][0] = (sin(radians(asteriodAngle)) * asteriods[i][3] + asteriods[i][0]);
     asteriods[i][1] = (-cos(radians(asteriodAngle)) * asteriods[i][3] + asteriods[i][1]);
     translate(asteriods[i][0],asteriods[i][1]);
     image(asteroid,0,0,32,32);
     popMatrix();
  }
}
