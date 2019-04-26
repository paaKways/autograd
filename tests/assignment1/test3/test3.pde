void setup() //runs once
{
  fullScreen(); //sets full screen
 background(0);
}

void draw() //runs forever
{
  //Draw paddles 
  fill(0, 255, 0);
  rect(0, 0, width/40, height/5); //draws a rectangle
  rect(39*width/40, 4*height/5, width/40, height/5);
  
  //Draw ball
  fill(255);
  ellipse(width/2, height/2, 40, 40); //draws a circle
  
  //write scores
  textSize(40); //set text size to 40
  text(0, width/4, height/2); //
  text(11, 3*width/4, height/2);
  
  }