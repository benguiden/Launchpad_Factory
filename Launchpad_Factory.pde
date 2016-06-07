import themidibus.*; //Import the library
import ddf.minim.*;

MidiBus myBus; // The MidiBus

//Midi
int channel = 0;
int pitch=-1;
int playerVelocity = 127;

//Matrix
boolean matrix[][]; //Formula: x + (y*16)
boolean matrixPrevious[][];
int matrixVel[][];
int matrixVelPrevious[][];

//Speed
int tick, gameSpeed;

//Score
int score;

//All Games
int mode; //0-Rising Objects ; 1-

//Views
View view = new View(new PVector(), new PVector(width/4, width/4), 0, 0);

//First Game
ArrayList<RisingObject> fallingBlocks;
Object dodging;
float spawnDelay, spawnTick;


//Beat
float bpm = 128.0f;
Minim minim;
AudioPlayer music;


void setup() {
  size(640, 640);
  background(0);
  frameRate(30);
  noSmooth();
  
  //Varaibles
  //Music
  minim = new Minim(this);
  music = minim.loadFile("music.mp3");
  music.play();
  music.loop();
  
  
  //Matrix
  matrix = new boolean[9][8];
  matrixPrevious = new boolean[9][8];
  matrixVel = new int[9][8];
  matrixVelPrevious = new int[9][8];
  
  //Speed
  gameSpeed = 60;
  
  //Score
  score = 0;
  
  //All Games
  mode = 0;

  //First Game
  fallingBlocks = new ArrayList<RisingObject>();
    //Corners
    fallingBlocks.add(new RisingObject(0, 0, 0, 0, 15));
    fallingBlocks.add(new RisingObject(0, 7, 0, 0, 15));
    fallingBlocks.add(new RisingObject(7, 0, 0, 0, 15));
    fallingBlocks.add(new RisingObject(7, 7, 0, 0, 15));
  dodging = new Object(4, 4, 0, 0, 16);
  spawnDelay = 15f * (120f/bpm);
  spawnTick = spawnDelay;
  

  //Midi Setup
  myBus = new MidiBus(this, 0, 3); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
  for (int i=0; i<127; i++) myBus.sendNoteOff(channel, i, 127); //Kill all pixels
 
 

}

void draw() {
  background(0);
  
  //Variables
  //Speed
  tick--;
  if (tick<=0){
    tick=gameSpeed;

  }
  
  
  //Update
  //Update Mode 1
  if (mode==0){
    
    dodging.update();
    for (int i = fallingBlocks.size()-1; i >= 0; i--) {
      fallingBlocks.get(i).update();
      if (fallingBlocks.get(i).tick<=0){ //Check if active
        if ((fallingBlocks.get(i).pos.x>=8) || (fallingBlocks.get(i).pos.x<0) || (fallingBlocks.get(i).pos.y>=8) || (fallingBlocks.get(i).pos.y<0)) fallingBlocks.remove(i);
      }
      //Kill Player
      if ((round(fallingBlocks.get(i).pos.x) == dodging.pos.x) && (round(fallingBlocks.get(i).pos.y) == dodging.pos.y)){
        for (int j = fallingBlocks.size()-1; j >= 0; j--){
          if (fallingBlocks.get(j).move) fallingBlocks.remove(j);
        }
        break;
      } 
    }
    
    //Spawn Blocks
    if (spawnTick<=0){
      
      for (int i=0; i<2; i++){
        int row = int(random(4));
        int r = int(random(6));
      
        if (row==0) fallingBlocks.add(new RisingObject(1+r, 0, 0, 0, 127));
        else if (row==1) fallingBlocks.add(new RisingObject(1+r, 7, 0, 0, 127));
        else if (row==2) fallingBlocks.add(new RisingObject(0, 1+r, 0, 0, 127));
        else if (row==3) fallingBlocks.add(new RisingObject(7, 1+r, 0, 0, 127));
      
        spawnTick=spawnDelay;
      }
      
    }
    
    spawnTick--;
  }
  
  
  //Draw Matrix in window
  stroke(255);
  noFill();
  for (int x=0; x<32; x++){
    for (int y=0; y<16; y++){
      if (x%8==0) {
        stroke(255);
        line(float(width) * (float(x)/32.0f), 0, float(width) * (float(x)/32.0f), height/2);
      }
      if (y%8==0) {
        stroke(255);
        line(0, float(height/2) * (float(y)/16.0f), width, float(height/2) * (float(y)/16.0f));
      }
      stroke(159, 127, 159, 64);
   //   rect(float(width) * (float(x)/32.0f), float(height/2) * (float(y)/16.0f), float(width)/32.0f, float(height)/16.0f);
    }
  }
  
  
  //Draw Mode 1
  for (int i = fallingBlocks.size()-1; i >= 0; i--) {
    fallingBlocks.get(i).render(0, 0, float(width)/32.0f, float(width)/32.0f, view);
  }
  dodging.render(0, 0, float(width)/32.0f, float(width)/32.0f, view);
 
  
  
  drawMatrix(mode);
}



//Draw Matrix
void drawMatrix(int _mode){
  

  int amount=0;
  //Draw Grid
  for (int x=0; x<8; x++){
    for (int y=0; y<8; y++){
      
      //Mode 1
      //if (mode==0){
        
        color c = get(int(((x*float(width)/32.0f)+float(width)/64.0f) + ((float(_mode)/4.0f)*float(width))), int((y*float(height)/32.0f)+float(height)/64.0f));
        
        if (c == color(0)) matrix[x][y] = false;
        else matrix[x][y] = true;
        if (c == color(255, 255, 0)) matrixVel[x][y] = 127;
        else if (c == color(0, 255, 0)) matrixVel[x][y] = 16;
        else if (c == color(255, 0, 0)) matrixVel[x][y] = 15;
      

     if ((matrixPrevious[x][y] == false) && (matrix[x][y]==true)) myBus.sendNoteOn(channel, x + (y * 16), matrixVel[x][y]);
     if ((matrixPrevious[x][y] == true) && (matrix[x][y]==false)) myBus.sendNoteOff(channel, x + (y * 16), 127);
     
     if (matrixVel[x][y] != matrixVelPrevious[x][y]) myBus.sendNoteOn(channel, x + (y * 16), matrixVel[x][y]);
     
     matrixPrevious[x][y] = matrix[x][y];
     matrixVelPrevious[x][y] = matrixVel[x][y];

    }
  }

}

void noteOn(int _channel, int _pitch, int _velocity) {

  int x = _pitch%16;
  int y = _pitch/16;
  println("Pressed: " + str(x) + "," + str(y));
  
  //Mode 0
  if (mode == 0){
    for(int i=fallingBlocks.size()-1; i >= 0; i--){
      }
    //Move Player
    if ((x>dodging.pos.x) && (x<8)) dodging.pos.x++;
    if (x<dodging.pos.x) dodging.pos.x--;
    if (y>dodging.pos.y) dodging.pos.y++;
    if (y<dodging.pos.y) dodging.pos.y--;
  }
  
  
  //Change Mode
  if (x==8){
    mode = y;
  }
  
}
void noteOff(int _channel, int _pitch, int _velocity) {
  
}



