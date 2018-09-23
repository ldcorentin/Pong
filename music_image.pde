//song
import ddf.minim.*;
import ddf.minim.analysis.*;

//image
import processing.core.*;
import processing.core.PApplet;
import processing.core.PImage; 

//--------------------------------------variable for the image--------------------------------------\\

PImage monImageGame;
PImage monImageRestart;

//--------------------------------------variable for the music--------------------------------------\\

AudioPlayer[] player = new AudioPlayer[4];
Minim minim;
FFT fft;
float alea;
int int_alea;
int buf_alea;
int bufferSize = 8;
int fftSize = floor(bufferSize*.9)+1;

//--------------------------------------variable for the game---------------------------------------\\

boolean gameover= false, right = false, left = false, d = false, q = false, y = false, n = false;
int topscore=0;
int bottomscore=0;
int time;
float changespeed=0;
Paddle bot;
Ball pongball;
Paddle top;

void setup()
{
  monImageGame = loadImage("Flamsteed Constellation Craters 01 by LRO.jpg");
  monImageRestart = loadImage("maxresdefault.jpg");
  
  //--------------------------------------boardgame--------------------------------------\\
  smooth();
  frameRate(100);
  noStroke();
  pongball= new Ball(color(255));
  bot=new Paddle();
  top=new Paddle();
  top.y=0;
  size(1000, 1000);
  //----------------------------------------music----------------------------------------\\
  minim = new Minim(this);
  player[0] = minim.loadFile("groove1.mp3");
  player[1] = minim.loadFile("groove2.mp3");
  player[2] = minim.loadFile("groove3.mp3");
  player[3] = minim.loadFile("groove4.mp3");

  alea = random(0, player.length);
  int_alea = int(alea);
  buf_alea = int_alea;
  
  player[int_alea].play();

  fft=new FFT(player[int_alea].bufferSize(), player[int_alea].sampleRate());
}

void keyPressed()
{
  if (keyCode == LEFT)  left = true;
  if (keyCode == RIGHT) right = true;
  if (key == 'q')       q=true;
  if (key == 'd' )      d=true;
  if(key == 'p')        noLoop();
  if(key == ' ')        loop();
}

void keyReleased()
{
  if (keyCode == LEFT)     left = false;
  if (keyCode == RIGHT)    right = false;
  if (key == 'q')          q=false;
  if (key == 'd')          d=false;
}

void draw()
{  
  if (gameover==false)
  {
    image(monImageGame, 0, 0);
    
    //--------------------------------------play music while the program is running--------------------------------------\\
    if(!player[int_alea].isPlaying())
    {
      alea = random(0, player.length);
      int_alea = int(alea);
    
      while(int_alea == buf_alea)
      {
        alea = random(0, player.length);
        int_alea = int(alea);
      }
      buf_alea = int_alea;
      player[int_alea].play();   
    }
    
    //background(0);
    bot.showThePaddle();
    top.showThePaddle();
    
    if (left==true)  bot.moveLeft();
    if (right==true) bot.moveRight();
    if (q==true)     top.moveLeft();
    if (d==true)     top.moveRight();

    pongball.ballSettingInMotion();
    pongball.bounce();
    pongball.showTheBall();
    
    if (pongball.positionY<-8)
    {
      gameover=true;
      bottomscore++;
    }
    if (pongball.positionY>1008)
    {
      gameover=true;
      topscore++;
    }
  }
  else //gameover==true, start or not a new party
  {
    image(monImageRestart, 0, 0);
    fill(0, 255, 0);
    changespeed=0;
    textSize(18);
    text("Top Player's Score: "+topscore, 415, 25);
    fill(0, 0, 255);
    text("Bottom Player's Score: "+bottomscore, 415, 975);
    textSize(36);
    fill(255, 0, 0);
    text("Game over ! Do you want to restart ? ", 185, 155);
    text("If yes, just click on the board game ", 185, 875);
    if (mousePressed==true)
    {
      pongball.positionX=int(random(200, 301));
      pongball.positionY=int(random(200, 301));
      int directionX=int(random(2));
      int directionY=int(random(2));
      
      if (directionX==0)  pongball.right=true;
      else                pongball.right=false; //directionX==1
      if (directionY==0)  pongball.up=true;
      else                pongball.up=false; //directionY==1, pongball.up=false;
      
      gameover=false;
    }
  }
}
class Paddle
{
  int x, y;
  
  public Paddle()
  {
    x=500;
    y=996;
  }
  
  void showThePaddle()
  {
    fill(46, 178, 253);
    rect(x, y, 120, 4);
  }
  
  void moveLeft()
  {
    if (x>=0)  x-=5;
  }
  void moveRight()
  {
    if (x<=880)  x+=5;
  }
}

class Ball
{
  int positionX, positionY;
  boolean up, right;
  color myColor;
  
  Ball(color newColor)
  {
    positionX=16;
    positionY=484;
    myColor = newColor;
    up=true;
    right=true;
  }
  
  void ballSettingInMotion()
  {
    if (up==true)     positionY=int(positionY-2-changespeed/2);
    else              positionY=int(positionY+2+changespeed/2); //up==false
    if (right==true)  positionX=int(positionX+1+changespeed);
    else              positionX=int(positionX-1-changespeed); //right==false
  }
  void bounce()
  {
    if (int(positionX)<0)  right=true;
    if (int(positionX)>1000)  right=false;
    if (get(int(positionX), int(positionY)-8)==color(46, 178, 253))  up=false;
    if (get(int(positionX), int(positionY)+8)==color(46, 178, 253))
    {
      up=true;
      changespeed+=0.5;
    }
  }
  
  void showTheBall()
  {
    fill(myColor);
    ellipse(positionX, positionY, 22, 22);
  }
}
