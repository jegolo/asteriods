
static int BULLET_SIZE= 40;
static int MAX_SPEED = 7;
static int BULLET_SPEED = 10;
static int MAX_ASTERIODS = 5;

float xpos = 320;
float ypos = 240;
boolean alive = true;

float angle = 0;
PImage img;
PImage asteroid;
PImage explosion;
PGraphics bg;
int speed = 0;
int time = 0;

int points = 0;

int bulletCount = 0;
float [][] bullet = new float[BULLET_SIZE][3];

float [][] asteriods = new float[MAX_ASTERIODS][7];

int bulletSpeed = 15;

int [][] explosions = new int[20][3];

int maxExplosions =0;
int minExplosions =0;


//https://forum.processing.org/two/discussion/19240/how-to-use-sprites

void setup() {
  size(640, 480);
  background(0);

  img = loadImage("/home/jens/Scratches/asteroids/sprites/glider.png");
  asteroid = loadImage("/home/jens/Scratches/asteroids/sprites/asteroid-clipart-white-background.png");
  explosion = loadImage("/home/jens/Scratches/asteroids/sprites/explosion.png");
  
  createBackground();
  initializeAsteriods();
} 

void drawExplosion(int x, int y, int count) {
  pushMatrix();
  translate(x,y);
  translate(-16, -16);
  image(explosion.get((count % 5) * 64, (count / 5) * 64 , 64, 64), 0,0,64,64);
  popMatrix();
}

void createAsteriod(int pos) {
  int side = int(random(4));
     
     int x = 0;
     int y = 0;
     float angle = 0;
     int speed = int(random(1,5));
     int size  = int(random(1,3));
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
      
      //Bounding Boxs
      if (left <= x && x <= right && top <= y && y <= bottom) {
        points+=5*asteriods[i][4];
       
        //Add Explosions
        int pos=0;
        if (minExplosions>0) {
          pos=--minExplosions;
        } else {
          pos=++maxExplosions;
        }
        explosions[pos]=new int[]{(int)left, (int)top, (int)0.0};
        //
        
        createAsteriod(i);
      }
   }
  
}

void draw() {
  time++;
  if (time % 20 == 0) {
   if (speed<0) {
     speed+=1;
   } else if (speed>0) {
     speed-=1;
   }
  }
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
     
     //Test collission 
     float a_left = asteriods[i][0];
     float a_right = asteriods[i][0] + 32;
     float a_top = asteriods[i][1];
     float a_bottom = asteriods[i][1]+32;
      
     float g_rgt = xpos + 32;
     float g_lft = xpos;
     float g_btm = ypos + 32;
     float g_top = ypos;
     
      //Bounding Box
      if (a_left <= g_rgt  && g_lft <= a_right && a_top <= g_btm && g_top <= a_bottom) {
        print ("Kollision");
        
      /*  alive=false;
        speed=0;
        points=0;
        xpos=320;
        ypos=200;*/    
      }
  }

  //Draw Explosion
  for (int pos = minExplosions;pos<maxExplosions;pos++) {
    int count = explosions[pos][2];
    int x = explosions[pos][0];
    int y = explosions[pos][1];
    
    drawExplosion(x,y, count);        
    explosions[pos][2]++;
    if (explosions[pos][2]>32) {
       minExplosions++; 
    }
  }
  
  textSize(32);
  text("Score: " + points, 470, 40);
  
}  
