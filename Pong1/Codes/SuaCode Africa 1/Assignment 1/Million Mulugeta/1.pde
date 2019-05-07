//maxX = 854, maxY = 480

float screenWidth = 854; //set to your maxX
float screenHeight = 480; //set to your maxY

void setup() //runs once
{
  fullScreen(); //Sets the program to run in full screen mode
  
}

void draw() //runs forever
{
  background(0); // sets background bkacj
 stroke(0,255,0); //sets the color of the outline of shapes drawn below this code below green
  fill(255,255,0); //sets the color of paddles to yellow
  rect(3,30,20,70); // draws the left paddle
  rect(830,190,20,70); // draws right paddle
  fill(0,255,255); // sets the color to light blue
  ellipse(427,240,40,40); // draws the ball of pong game
  fill(128); //sets the color of text drawn below this code black
  textSize(40); //sets text size
  text("2",347,35); //score of player one
  text("6",477,35); //score of player two
}
