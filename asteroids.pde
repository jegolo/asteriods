
static int BULLET_SIZE= 40;
static int MAX_SPEED = 7;
static int BULLET_SPEED = 10;
static int MAX_ASTERIODS = 5;

float xpos = 320;
float ypos = 240;

float angle = 0;
PImage img;
PImage asteroid;
PGraphics bg;
int speed = 0;

int bulletCount = 0;
float [][] bullet = new float[BULLET_SIZE][3];

float [][] asteriods = new float[MAX_ASTERIODS][7];

int bulletSpeed = 15;

void setup() {
  size(640, 480);
  background(0);

  img = loadImage("/home/jens/Scratches/asteroids/sprites/glider.png");
  asteroid = loadImage("/home/jens/Scratches/asteroids/sprites/asteroid-clipart-white-background.png");
  createBackground();
  initializeAsteriods();
} 

void createAsteriod(int pos) {
  int side = int(random(4));
     
     int x = 0;
     int y = 0;
     float angle = 0;
     int speed = int(random(1,5));
     int size  = int(random(0,3));
     int rotateSpeed = int(random(10));
     if (side == 0) {
        x = int(random(width));
        angle = int(random(45,135));
     } else if (side == 1) {
        y = int(random(height));
        x = width;
        angle = int(random(225,315));
        
     } else if (side == 2) {
        y = height;
        x = int(random(width));
        angle = int(random(315,45));
     } else if (side == 3) {
        y = int(random(height));
        angle = int(random(135,225));
     }
     asteriods[pos]=new float[]{x, y, angle, speed, size, rotateSpeed, 0};
}

void initializeAsteriods() {
  for (int i=0;i<MAX_ASTERIODS;i++) {
     createAsteriod(i);
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

void checkForHit(int bulletNum) {
   float x = bullet[bulletNum][0];
   float y = bullet[bulletNum][1];
   
   //https://glossar.hs-augsburg.de/Axis_Aligned_Bounding_Box
   for (int i=0; i<MAX_ASTERIODS; i++) {
      float left = asteriods[i][0];
      float right = asteriods[i][0] + 32;
      float top = asteriods[i][1];
      float bottom = asteriods[i][1]+32;
      
      //Bounding Box
      if (left <= x && x <= right && top <= y && y <= bottom) {
        createAsteriod(i);
      }
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
     
     checkForHit(i);
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
     asteriods[i][5] = (asteriods[i][5] + asteriods[i][4]) % 360;
     translate(asteriods[i][0],asteriods[i][1]);
     scale(asteriods[i][4]);
     rotate(radians(asteriods[i][5]));
     translate(-16, -16);
     image(asteroid,0,0,32,32);
     popMatrix();
     if (asteriods[i][0]<0 || asteriods[i][0]>width || asteriods[i][1]<0 || asteriods[i][1]>height) {
       createAsteriod(i);
     }
  }
}
