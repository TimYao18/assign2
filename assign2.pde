/* please implement your assign2 code in this file. */

// constant variables
final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_LOSE = 2;

final int HIT_NONE = 0;
final int HIT_ENEMY = 1;
final int HIT_TREASURE = 2;

final int HP_POINT_DEFAULT = 50;
final int HP_POINT_MAX = 100;
final int HP_POINT_HIT = 20;
final int HP_POINT_ENERGY = 10;

// Fixed Position
final int HP_X = 10;
final int HP_Y = 10;
final int HP_RED_X = HP_X + 5;
final int HP_RED_Y = HP_Y + 2;
final int BUTTON_X = 202;
final int BUTTON_Y = 280;
final int BUTTON_WIDTH = 255;
final int BUTTON_HEIGHT = 123;

// image size
final int FIGHTER_SIZE = 50;
final int ENEMY_SIZE = 60;
final int TREASURE_SIZE = 40;
final int HP_WIDTH = 202;
final int HP_HEIGHT = 20;

// speed
final int BACKGROUND_SPEED = 2;
final int ENEMY_SPEED = 5;
final float ENEMY_SPEED_ACC = 0.3;
final int FIGHTER_SPEED = 5;



// variables
int gameState;
float enemySpeedY;

  // positions
int bg1RX;
int bg2RX;
int enemyX;
int enemyY;
int fighterX;
int fighterY;
int hpPoint;
int treasureX;
int treasureY;
  // keypressed
boolean isLeftPressed;
boolean isRightPressed;
boolean isUpPressed;
boolean isDownPressed;

// images
PImage gameStart1;
PImage gameStart2;
PImage bg1;
PImage bg2;
PImage enemy;
PImage fighter;
PImage hp;
PImage treasure;
PImage gameLose1;
PImage gameLose2;


void setup () {
  size(640,480) ;  // must use this size.

  // your code
  bg1RX = width; // bg1 right side position
  bg2RX = width * 2; // bg2 right side position
  
  // load images
  gameStart1 = loadImage("img/start2.png");
  gameStart2 = loadImage("img/start1.png");
  bg1 = loadImage("img/bg1.png");
  bg2 = loadImage("img/bg2.png");
  enemy = loadImage("img/enemy.png");
  fighter = loadImage("img/fighter.png");
  hp = loadImage("img/hp.png");
  treasure = loadImage("img/treasure.png");
  gameLose1 = loadImage("img/end2.png");
  gameLose2 = loadImage("img/end1.png");
  
  // default
  gameState = GAME_START;
  isLeftPressed = false;
  isRightPressed = false;
  isUpPressed = false;
  isDownPressed = false;
  
  // get random start position
  // hp
  hpPoint = HP_POINT_DEFAULT;
  enemySpeedY = 0;

  // enemy
  enemyX = 0; // from left side
  enemyY = floor(random(height-ENEMY_SIZE));
  
  // fighter
  fighterX = floor(random(width-FIGHTER_SIZE));
  fighterY = floor(random(height-FIGHTER_SIZE));
  
  // treasure
  treasureX = floor(random(width-TREASURE_SIZE));
  treasureY = floor(random(height-TREASURE_SIZE));  
  

}

void draw() {
  // your code
  switch (gameState)
  {
    case GAME_START:
      // Mouse in the button rectangle
      if (BUTTON_X < mouseX && mouseX < BUTTON_X + BUTTON_WIDTH &&
          BUTTON_Y < mouseY && mouseY < BUTTON_Y + BUTTON_HEIGHT) {
        image(gameStart2, 0,0);

        // Click
        if (mousePressed) {
          gameState = GAME_RUN;
        }
      }
      else {
        image(gameStart1, 0,0);
      }
      break;
      
    case GAME_RUN:
      // draw background
      bg1RX = (bg1RX + BACKGROUND_SPEED);
      if (bg1RX >= width * 2)
          bg1RX = 0;
      bg2RX = (bg2RX + BACKGROUND_SPEED);
      if (bg2RX >= width * 2)
          bg2RX = 0;
      image(bg1, bg1RX-width, 0);
      image(bg2, bg2RX-width, 0);
      
      // Fighter Position
      if (isUpPressed){
        fighterY -= FIGHTER_SPEED;
      }
      if (isDownPressed){
        fighterY += FIGHTER_SPEED;
      }
      if (isLeftPressed){
        fighterX -= FIGHTER_SPEED;
      }
      if (isRightPressed){
        fighterX += FIGHTER_SPEED;
      }
      
      // enemy position
      if (enemyX <= enemyX - ENEMY_SIZE) {
        enemyX = enemyX - ENEMY_SIZE;
      } else if (enemyX >=  width) {
        enemyX = 0;
        enemyY = floor(random(height-ENEMY_SIZE));
      }

      // enemy boundary detection
      if (enemyY <= enemyY - ENEMY_SIZE) {
        enemyY = enemyY - ENEMY_SIZE;
      } else if (enemyY >= height) {
        enemyY = height;
      }
      
      // Fighter - Screen Edge Boundery Detection
      if (fighterX <= 0) {
        fighterX = 0;
      }
      else if (fighterX > width - FIGHTER_SIZE) {
        fighterX = width - FIGHTER_SIZE;
      }
    
      if (fighterY <= 0) {
        fighterY = 0;
      }
      else if (fighterY > height - FIGHTER_SIZE) {
        fighterY = height - FIGHTER_SIZE;
      }

      // Enemy hit Detection
      int detectHit = HIT_NONE;
      if (enemyX <= fighterX && fighterX <= enemyX + ENEMY_SIZE &&
          enemyY <= fighterY && fighterY <= enemyY + ENEMY_SIZE) {
          // Fighter Left-Up corner is in enemy's rect
          detectHit = HIT_ENEMY;
      } else if (enemyX <= fighterX+FIGHTER_SIZE && fighterX+FIGHTER_SIZE <= enemyX + ENEMY_SIZE &&
          enemyY <= fighterY && fighterY <= enemyY + ENEMY_SIZE) {
          // Fighter Right-Up corner is in enemy's rect
          detectHit = HIT_ENEMY;
      } else if (enemyX <= fighterX && fighterX <= enemyX + ENEMY_SIZE &&
          enemyY <= fighterY+FIGHTER_SIZE && fighterY+FIGHTER_SIZE <= enemyY + ENEMY_SIZE) {
          // Fighter Left-Down corner is in enemy's rect
          detectHit = HIT_ENEMY;
      } else if (enemyX <= fighterX+FIGHTER_SIZE && fighterX+FIGHTER_SIZE <= enemyX + ENEMY_SIZE &&
          enemyY <= fighterY+FIGHTER_SIZE && fighterY+FIGHTER_SIZE <= enemyY + ENEMY_SIZE) {
          // Fighter Right-Down corner is in enemy's rect
          detectHit = HIT_ENEMY;
      }

      // Treasure hit Detection
      if (treasureX <= fighterX && fighterX <= treasureX + ENEMY_SIZE &&
          treasureY <= fighterY && fighterY <= treasureY + ENEMY_SIZE) {
          // Fighter Left-Up corner is in treasure's rect
          detectHit = HIT_TREASURE;
      } else if (treasureX <= fighterX+FIGHTER_SIZE && fighterX+FIGHTER_SIZE <= treasureX + ENEMY_SIZE &&
          treasureY <= fighterY && fighterY <= treasureY + ENEMY_SIZE) {
          // Fighter Right-Up corner is in treasure's rect
          detectHit = HIT_TREASURE;
      } else if (treasureX <= fighterX && fighterX <= treasureX + ENEMY_SIZE &&
          treasureY <= fighterY+FIGHTER_SIZE && fighterY+FIGHTER_SIZE <= treasureY + ENEMY_SIZE) {
          // Fighter Left-Down corner is in treasure's rect
          detectHit = HIT_TREASURE;
      } else if (treasureX <= fighterX+FIGHTER_SIZE && fighterX+FIGHTER_SIZE <= treasureX + ENEMY_SIZE &&
          treasureY <= fighterY+FIGHTER_SIZE && fighterY+FIGHTER_SIZE <= treasureY + ENEMY_SIZE) {
          // Fighter Right-Down corner is in treasure's rect
          detectHit = HIT_TREASURE;
      }

      if (detectHit == HIT_ENEMY) {
        hpPoint -= HP_POINT_HIT;
        if (hpPoint <= 0) {
          hpPoint = 0;
          gameState = GAME_LOSE;
        }

        // reset enemy
        enemySpeedY = 0;
        enemyX = 0-ENEMY_SIZE; // left start
        enemyY = floor(random(height-ENEMY_SIZE));
      } else if (detectHit == HIT_TREASURE){
        hpPoint += HP_POINT_ENERGY;
        if (hpPoint >= HP_POINT_MAX) {
          hpPoint = HP_POINT_MAX;
        }
        
        // reset treasure position
        treasureX = floor(random(width-TREASURE_SIZE));
        treasureY = floor(random(height-TREASURE_SIZE));
      }
      
      // enemy move toward fighter
      if (fighterY + FIGHTER_SIZE/2 > enemyY + ENEMY_SIZE/2) {
        // fighter is below enemy
        enemySpeedY+=ENEMY_SPEED_ACC;
        if (enemySpeedY >= ENEMY_SPEED)
            enemySpeedY = ENEMY_SPEED;
      } else if (fighterY + FIGHTER_SIZE/2 < enemyY + ENEMY_SIZE/2) {
        // fighter is above enemy
        enemySpeedY-=ENEMY_SPEED_ACC;
        if (enemySpeedY <= -ENEMY_SPEED)
            enemySpeedY = -ENEMY_SPEED;
      }

      // hpRed shoud draw before hp
      fill(#FF0000);
      rect(HP_RED_X, HP_RED_Y, hpPoint*HP_WIDTH/HP_POINT_MAX, HP_HEIGHT, 0, 3, 0, 0);
      image(hp, HP_X, HP_Y);
      // draw others
      image(fighter, fighterX, fighterY);
      image(treasure, treasureX, treasureY);
      image(enemy, enemyX+=ENEMY_SPEED, enemyY+=enemySpeedY);
      break;

    case GAME_LOSE:
      // Mouse in the button rectangle
      if (BUTTON_X < mouseX && mouseX < BUTTON_X + BUTTON_WIDTH &&
          BUTTON_Y < mouseY && mouseY < BUTTON_Y + BUTTON_HEIGHT) {
        image(gameLose2, 0,0);

        // Click
        if (mousePressed) {
          // reset hpPoint
          hpPoint = HP_POINT_DEFAULT;
          gameState = GAME_RUN;
          enemySpeedY = 0;

          // reset enemy
          enemyX = 0; // from left side
          enemyY = floor(random(height-ENEMY_SIZE));        

          // reset fighter
          fighterX = floor(random(width-FIGHTER_SIZE));
          fighterY = floor(random(height-FIGHTER_SIZE));
        }
      }
      else {
        image(gameLose1, 0,0);
      }
      break;
  }
}


void keyPressed() {
  if (key == CODED) {
    switch(keyCode)
    {
      case UP:
        isUpPressed = true;
        break;
      case DOWN:
        isDownPressed = true;
        break;
      case LEFT:
        isLeftPressed = true;
        break;
      case RIGHT:
        isRightPressed = true;
        break;
    }
  }
}

void keyReleased(){
  
  if (key == CODED) {
    switch(keyCode)
    {
      case UP:
        isUpPressed = false;
        break;
      case DOWN:
        isDownPressed = false;
        break;
      case LEFT:
        isLeftPressed = false;
        break;
      case RIGHT:
        isRightPressed = false;
        break;
    }
  }
}
