PFont topBar;
int timer;
int tick;
int rate = 1;
Cell[][] cells;
int gameHeight;

void setup() { 
  size(1000, 1000);
  frameRate(rate);
  gameHeight = 800;
  background(255, 165, 0, 128);
  topBar = createFont("The 2048 Game!    Timer: " + timer, 20);
  textFont(topBar);

  // initializes the cells with a starter game piece with value of either 2 or 4.
  cells = new Cell[4][4];
  int initRow = (int) (random(cells.length));
  int initCol = (int) (random(cells[0].length));
  float initValue = random(1);
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[0].length; j++) {
      if (i == initRow && j == initCol) {
        if (initValue < 0.75) {
          cells[i][j] = new Cell(2);
        } else {
          cells[i][j] = new Cell(4);
        }
      } else {
        cells[i][j] = new Cell(0); // initialize to nothing
      }
    }
  }
} 

void draw() {
  background(255, 165, 0, 128);

  // draws text area and texts in it
  fill(211);    // grey rectangle = background for information
  noStroke();
  rect(0, 0, width, (height - gameHeight) / 2); // 100/900 split
  fill(255);  // Text
  text("The 2048 Game!    Timer: " + timer, 10, (height - gameHeight) / 4);

  // draws gameBoard
  fill(220, 130, 0);
  rect(width / 10, (height - gameHeight) / 2 + height / 20, 
    width - width / 5, height - (height / 5));

  // if any key is pressed
  //this.keyPressed();

  // draws the cells 
  this.drawCells();

  // increments timer based on tick rate
  if ((frameCount % rate) == 0) { 
    timer++;
  }
}

void keyPressed() throws IllegalArgumentException {
  if (key == CODED) {
    if (keyCode == LEFT) {
      boolean changesMade = false;
      System.out.println("left");
      for (int i = 0; i < cells.length; i++) {
        //boolean mergeable = true;
        for (int j = 0; j < cells[i].length; j++) {
          if (cells[i][j].value > 0) {
            int currRow = i;
            int currCol = j;
            // merge if cell at right can be merged to the current one, and none of the
            // past cells were merged
            // problem 4-2-2-2 doesn't merge the two 2's when pressing left.
            // What if 4-4-2-2, after the first merge, it will stop merging :( 
            // The cases should be: 1. current one and next one are the same, so merge. 2. current one is not same as next one -> check later ones 
            //System.out.println(mergeable);
            // Say 4-0-0-4, process will be: next is 0, check if next is also 0 (true), check if next is also 0 (true)
            // check next... (false), stops and check if equal
            while (currCol + 1 < cells[i].length) {
              if (cells[currRow][currCol + 1].value == cells[currRow][currCol].value) {
                cells[currRow][currCol] = new Cell(cells[currRow][currCol].value * 2);
                cells[currRow][currCol + 1] = new Cell(0);
                //mergeable = false;
                currCol ++;
                changesMade = true;
              } else if (cells[currRow][currCol + 1].value == 0 && cells[currRow][currCol].value > 0) {
                currCol ++;
                while (currCol + 1 < cells[i].length) {
                  if (cells[currRow][currCol + 1].value == cells[currRow][j].value) {
                    cells[currRow][j] = new Cell(cells[currRow][j].value * 2);
                    cells[currRow][currCol + 1] = new Cell(0);
                    changesMade = true;
                    break;
                  }
                  else if (cells[currRow][currCol + 1].value == 0) {
                    currCol ++;
                  }
                  else {
                    break;
                  }
                }
                // reset
                currCol = j + 1;
              }
              /*else if (cells[currRow][currCol + 1].value != cells[currRow][currCol].value && cells[currRow][currCol + 1].value > 0) {
               mergeable = false;
               break;*/
              /*
              else {
               currCol ++;
               }*/
               currCol ++;
            }
            // reset currCol to j again for next while loop
            currCol = j;
            boolean moveable = true;
            // move current cell to the left if there is nothing there
            while (currCol - 1 >= 0 && moveable) {
              if (cells[currRow][currCol - 1].value != 0) {
                moveable = false;
                break;
              } else {
                cells[currRow][currCol - 1] = cells[currRow][currCol];
                cells[currRow][currCol] = new Cell(0);
                currCol --;
                changesMade = true;
              }
            }
          }
        }
      }
      if (changesMade) {
        this.generateNewCell();
      }
    } else if (keyCode == RIGHT) {
      boolean changesMade = true;
      System.out.println("right");
      for (int i = 0; i < cells.length; i++) {
        //boolean mergeable = true;
        for (int j = cells[i].length - 1; j > -1; j--) {
          if (cells[i][j].value > 0) {
            int currRow = i;
            int currCol = j;
            // merge if cell at left can be merged to the current one, and none of the
            // past cells were merged
            while (currCol - 1 > 0) {
              if (cells[currRow][currCol - 1].value == cells[currRow][currCol].value) {
                cells[currRow][currCol] = new Cell(cells[currRow][currCol].value * 2);
                cells[currRow][currCol - 1] = new Cell(0);
                //mergeable = false;
                currCol --;
                changesMade = true;
              }
              else if (cells[currRow][currCol - 1].value == 0) {
                currCol --;
                while (currCol - 1 > 0) {
                  if (cells[currRow][currCol - 1].value == cells[currRow][j].value) {
                    cells[currRow][j] = new Cell(cells[currRow][j].value * 2);
                    cells[currRow][currCol - 1] = new Cell(0);
                    changesMade = true;
                    break;
                  }
                  else if (cells[currRow][currCol - 1].value == 0) {
                    currCol --;
                  }
                  else {
                    break;
                  }
                }
                 // reset
                currCol = j - 1;
              }/* else if (cells[currRow][currCol - 1].value != cells[currRow][currCol].value && cells[currRow][currCol - 1].value > 0) {
               mergeable = false;
               break;
               }*/

              /*else {
               currCol --;
               }*/
              currCol --;
            }
            // reset currCol to j again for next while loop
            currCol = j;
            boolean moveable = true;
            // move current cell to the right if there is nothing there
            while (currCol + 1 < cells[currRow].length && moveable) {
              if (cells[currRow][currCol + 1].value != 0) {
                moveable = false;
                break;
              } else {
                cells[currRow][currCol + 1] = cells[currRow][currCol];
                cells[currRow][currCol] = new Cell(0);
                currCol ++;
                changesMade = true;
              }
            }
          }
        }
      }
      if (changesMade) {
        this.generateNewCell();
      }
    } else if (keyCode == UP) {
      boolean changesMade = true;
      System.out.println("up");
      for (int i = 0; i < cells.length; i++) {
        //boolean mergeable = true;
        for (int j = 0; j < cells[i].length; j++) {
          if (cells[i][j].value > 0) {
            int currRow = i;
            int currCol = j;
            // merge if cell at bot can be merged to the current one, and none of the
            // past cells were merged
            while (currRow + 1 < cells.length) {
              if (cells[currRow + 1][currCol].value == cells[currRow][currCol].value) {
                cells[currRow][currCol] = new Cell(cells[currRow][currCol].value * 2);
                cells[currRow + 1][currCol] = new Cell(0);
                //mergeable = false;
                currRow ++;
                changesMade = true;
              }
              else if (cells[currRow + 1][currCol].value == 0) {
                currRow ++;
                while (currRow + 1 < cells.length) {
                  if (cells[currRow + 1][currCol].value == cells[i][currCol].value) {
                    cells[i][currCol] = new Cell(cells[i][currCol].value * 2);
                    cells[currRow + 1][currCol] = new Cell(0);
                    changesMade = true;
                    break;
                  }
                  else if (cells[currRow + 1][currCol].value == 0) {
                    currCol ++;
                  }
                  else {
                    break;
                  }
                }
                 // reset
                currRow = i + 1;
              }/* else if (cells[currRow + 1][currCol].value != cells[currRow][currCol].value && cells[currRow + 1][currCol].value > 0) {
               mergeable = false;
               break;
               }*/

              /*else {
               currRow ++;
               }*/
              currRow ++;
            }
            // reset currRow to i again for next while loop
            currRow = i;
            boolean moveable = true;
            // move current cell to the top if there is nothing there
            while (currRow - 1 >= 0 && moveable) {
              if (cells[currRow - 1][currCol].value != 0) {
                moveable = false;
                break;
              } else {
                cells[currRow - 1][currCol] = cells[currRow][currCol];
                cells[currRow][currCol] = new Cell(0);
                currRow --;
                changesMade = true;
              }
            }
          }
        }
      }
      if (changesMade) {
        this.generateNewCell();
      }
    } else if (keyCode == DOWN) {
      boolean changesMade = true;
      System.out.println("down");
      for (int i = cells.length - 1; i > -1; i--) {
        //boolean mergeable = true;
        for (int j = 0; j < cells[i].length; j++) {
          if (cells[i][j].value > 0) {
            int currRow = i;
            int currCol = j;
            // merge if cell at top can be merged to the current one, and none of the
            // past cells were merged
            while (currRow - 1 > 0) {
              if (cells[currRow - 1][currCol].value == cells[currRow][currCol].value) {
                cells[currRow][currCol]  = new Cell(cells[currRow][currCol].value * 2);
                cells[currRow - 1][currCol] = new Cell(0);
                //mergeable = false;
                currRow --;
                changesMade = true;
              }
              else if (cells[currRow - 1][currCol].value == 0) {
                currRow --;
                while (currRow - 1 > 0) {
                  if (cells[currRow - 1][currCol].value == cells[i][currCol].value) {
                    cells[i][currCol] = new Cell(cells[i][currCol].value * 2);
                    cells[currRow - 1][currCol] = new Cell(0);
                    changesMade = true;
                    break;
                  }
                  else if (cells[currRow - 1][currCol].value == 0) {
                    currRow --;
                  }
                  else {
                    break;
                  }
                }
                 // reset
                currRow = i - 1;
              }/* else if (cells[currRow - 1][currCol].value != cells[currRow][currCol].value && cells[currRow - 1][currCol].value > 0) {
               mergeable = false;
               break;
               }*/
              /*else {
               currRow --;
               }*/
              currRow --;
            }
            // reset currRow to i again for next while loop
            currRow = i;
            boolean moveable = true;
            // move current cell to the bot if there is nothing there
            while (currRow + 1 < cells.length && moveable) {
              if (cells[currRow + 1][currCol].value != 0) {
                moveable = false;
                break;
              } else {
                cells[currRow + 1][currCol] = cells[currRow][currCol];
                cells[currRow][currCol] = new Cell(0);
                currRow ++;
                changesMade = true;
              }
            }
          }
        }
      }
      if (changesMade) {
        this.generateNewCell();
      }
    } else {
      throw new IllegalArgumentException("Key cannot be identified");
    }
  }
}

// creates new cell
void generateNewCell() {
  int i = (int) (random(cells.length));
  int j = (int) (random(cells[0].length));
  float initValue = random(1);
  while (cells[i][j].value != 0) {
    i = (int) (random(cells.length));
    j = (int) (random(cells[0].length));
  }
  if (initValue < 0.75) {
    cells[i][j] = new Cell(2);
  } else {
    cells[i][j] = new Cell(4);
  }
}

// draws the cells of the game per tick
void drawCells() {
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[i].length; j++) {
      stroke(100, 130, 0, 40); // 25% opacity of background for game cell with no value
      noFill();
      rect(width / 10 + j * (width - width / 5) / cells[i].length, 
        ((height - gameHeight) / 2 + height / 20) + i * (height - height / 5) / cells.length
        , (width - width / 5) / cells[i].length, gameHeight / cells.length);
      if (cells[i][j].value != 0) {
        fill(cells[i][j].getColor(cells[i][j].value));
        rect(width / 10 + j * (width - width / 5) / cells[i].length, 
          ((height - gameHeight) / 2 + height / 20) + i * (height - height / 5) / cells.length
          , (width - width / 5) / cells[i].length, gameHeight / cells.length);
        fill(0);
        text(cells[i][j].value, (width / 10) * 2 + j * (width - width / 5) / cells[i].length, 
          ((height - gameHeight) + height / 20) + i * (height - height / 5) / cells.length
          );
      }
    }
  }
}

// Represents the game board for 2048
class Cell {
  int value;
  color itsColor;

  public Cell(int value) {
    this.value = value;
    this.itsColor = getColor(value);
  }

  color getColor(int v) {
    double i = (double)(((long)(log(v) / log(2)))/32);
    System.out.println(log(v));
    return color((int) i * 255, 60, (int) i * 255);
  }
}
