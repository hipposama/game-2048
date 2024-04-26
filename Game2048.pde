//+=======================================-Global Variables-=============================================================+//
int[][] grid = new int[4][4];
int[][] buffer = new int[grid.length][grid[0].length];
int attempt;
int score = 0;
int bestScore = 0;
float textOffsetX = 0;
float textOffsetY = 0;

color currentColor;
float colorProgress = 0;

enum State {
  MENU, PLAYING
}

State animationState = State.MENU;


color colors[] = {
  color(238, 228, 218),
  color(237, 224, 200), 
  color(242, 177, 121), 
  color(245, 149, 99), 
  color(246, 124, 95), 
  color(246, 94, 59), 
  color(237, 207, 114), 
  color(237, 204, 97), 
  color(237, 200, 80), 
  color(237, 197, 63), 
  color(237, 194, 46)
};

//+=======================================-Setup-=============================================================+//

void setup() {
  size(800, 800);
  newTile();
  newTile();
}

//+========================================-New Tile-===========================================================+//

void newTile() {
  int x = floor(random(0, grid.length));
  int y =floor(random(0, grid[0].length));
  if (grid[x][y]==0) {
    grid[x][y]=floor(random(1, 3))*2;
    return;
  }
  attempt++;
  if(attempt<256){
    newTile();
  }
  
}
//+=======================================-Input-=============================================================+//

void keyPressed() {
  if (animationState == State.MENU && key == ' ') {
    animationState = State.PLAYING;
  } else {
    switch(key) {
    case 'w':
      moveDir(0, -1);
      break;
    case 'a':
      moveDir(-1, 0);
      break;
    case 's':
      moveDir(0, 1);
      break;
    case 'd':
      moveDir(1, 0);
      break;
    case 'r':
      resetGame();
      break;
    }
  }
}
//+=======================================-Move-=============================================================+//

void moveDir(int x, int y) {
  for (int i = 0; i<grid.length; i++) {
    for (int j = 0; j<grid[0].length; j++) {
      buffer[i][j] = grid[i][j];
    }
  }

  if (x==-1||y==-1) {
    for (int i = 0; i<grid.length; i++) {
      for (int j = 0; j<grid[0].length; j++) {
        move(i, j, x, y);
      }
    }
  } else {
    for (int i = grid.length-1; i>=0; i--) {
      for (int j = grid[0].length-1; j>=0; j--) {
        move(i, j, x, y);
      }
    }
  }

  if (buffer!=grid) {
    attempt=0;
    newTile();
  }
}

void move(int i, int j, int x, int y) {
  for (int ii = 0; ii < 5; ii++) {
    if (j + y >= 0 && j + y < grid[0].length && i + x >= 0 && i + x < grid.length) {
      if (grid[i+x][j+y]==0) {
        grid[i+x][j+y]=grid[i][j];
        grid[i][j]=0;
        score += grid[i+x][j+y]/4; // insert score
          if (score > bestScore) { // best score
              bestScore = score;
            }
      } else {
        if (grid[i+x][j+y]==grid[i][j]) {
          grid[i+x][j+y]*=2;
          grid[i][j]=0;
          score += grid[i+x][j+y]/4; // insert score
          if (score > bestScore) { // best score
              bestScore = score;
            }
        }
      }
    }
    i+=x;
    j+=y;
  }
}

//+=======================================-Render-===========================================================+//

void draw() {
  switch (animationState) {
    case MENU:
      drawMenuAnimation();
      break;
    case PLAYING:
      drawGame();
      break;
  }
}

void drawMenuAnimation() {
  textOffsetX = 50 * sin(millis() / 1000.0);
  textOffsetY = 50 * cos(millis() / 1000.0);
  
  float r = 127.5 * (1 + sin(millis() / 1000.0));
  float g = 127.5 * (1 + sin(millis() / 1000.0 + 2 * PI / 3));
  float b = 127.5 * (1 + sin(millis() / 1000.0 + 4 * PI / 3));

  currentColor = color(r, g, b);


  background(250, 248, 239);
  fill(currentColor);
  textSize(200);
  textAlign(CENTER, CENTER);

  int numTrails = 4;
  for (int i = 0; i < numTrails; i++) {
    float alpha = 255 * (1 - i / (float) numTrails);
    if (i != 0) {
      alpha *= 0.4;
    }
    fill(r, g, b, alpha);

    float offsetX = textOffsetX * i / numTrails;
    float offsetY = textOffsetY * i / numTrails;
    text("2048", width / 2 + offsetX, height / 2 - 100 + offsetY);
  }

  fill(119, 110, 101);
  textSize(32);
  text("Press SPACE to start", width / 2, height * 0.7);
}


void drawGame() {
  float s=1.2;
  float ss=1.5;
  float w = (width/ss)/grid.length;
  float h = (height/ss)/grid[0].length;

  background(250, 248, 239);
  fill(187, 173, 160);
  rect((width-width/ss)/2/s, (height-height/ss)/2/s, width/ss*(1+(s-1)/2), height/ss*(1+(s-1)/2), w/7);

  noStroke();
  textSize(w/3);
  textAlign(CENTER, CENTER);
  for (int i = 0; i<grid.length; i++) {
    for (int j = 0; j<grid[0].length; j++) {

      if (grid[i][j]>0) {
        fill(colors[(int)(log((float)grid[i][j]) / log(2))-1]);
        
        rect(i*h+h*(s-1)/2+(width-width/ss)/2, j*w+w*(s-1)/2+(height-height/ss)/2, w/s, h/s, w/10);
        fill(119, 110, 101);
        if(grid[i][j]>4){
          fill(249,246,242);
        }
        
        text(str(grid[i][j]), i * h + h * (s - 1) / 2 + (width - width / ss) / 2 + w / (2 * s), j * w + w * (s - 1) / 2 + (height - height / ss) / 2 + h / (2 * s));
      } else {
        fill(205, 193, 180);
        rect(i * h + h * (s - 1) / 2 + (width - width / ss) / 2, j * w + w * (s - 1) / 2 + (height - height / ss) / 2, w / s, h / s, w / 10);
      
      }
    }
  }
  // Gameover
    if (isGameOver()) {
    fill(0, 0, 0, 150);
    rect(0, 0, width, height);

    textSize(64);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Game Over", width / 2, height / 2 - 50);

    textSize(32);
    text("Press R to Restart", width / 2, height / 2 + 50);
  }
  //score
  fill(119, 110, 101);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Score: " + score, width / 2, 40);
  
  // best score
  fill(119, 110, 101);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Best Score: " + bestScore, width / 2, 80);
}

//+=======================================-Restart-===========================================================+//
void resetGame() {
  // Clear the grid
  for (int i = 0; i < grid.length; i++) {
    for (int j = 0; j < grid[0].length; j++) {
      grid[i][j] = 0;
    }
  }
  // Reset the attempt counter
  attempt = 0;
  // Add two new tiles to start a new game
  newTile();
  newTile();
  score = 0;
}

//+=======================================-GameOver-===========================================================+//
boolean isGameOver() {
  for (int i = 0; i < grid.length; i++) {
    for (int j = 0; j < grid[0].length; j++) {
      if (grid[i][j] == 0) {
        return false;
      }
      if (i < grid.length - 1 && grid[i][j] == grid[i + 1][j]) {
        return false;
      }
      if (j < grid[0].length - 1 && grid[i][j] == grid[i][j + 1]) {
        return false;
      }
    }
  }
  return true;
}
