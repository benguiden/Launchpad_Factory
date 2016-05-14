import themidibus.*; //Import the library

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

//First Game
ArrayList<Object> fallingBlocks;


void setup() {
  size(400, 400);
  background(0);
  frameRate(30);
  
  //Varaibles
  //Matrix
  matrix = new boolean[9][8];
  matrixPrevious = new boolean[9][8];
  matrixVel = new int[9][8];
  matrixVelPrevious = new int[9][8];
  
  //Speed
  gameSpeed = 30;
  tick = gameSpeed;
  
  //Score
  score = 0;

  //First Game
  fallingBlocks = new ArrayList<Object>();
  fallingBlocks.add(new Object(1, 4, 0, -1f, 127));

  //Midi Setup
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
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
    tick();
  }
  
  
  
  //Draw Matrix in window
  stroke(255);
  noFill();
  for (int x=0; x<9; x++){
    for (int y=0; y<8; y++){
      rect(float(width) * (float(x)/9.0f), float(height) * (float(y)/9.0f), float(width)/9.0f, float(height)/9.0f);
      if (matrix[x][y]){
        fill(255, 255, 0);
        rect(float(width) * (float(x)/9.0f), float(height) * (float(y)/9.0f), float(width)/9.0f, float(height)/9.0f);
        noFill();
      }
   
    }
  }
  
  
}

//Run every tick, it acts like a slow draw method
void tick(){
  //Increase score
  score++;
  
  //First Game
  for (int i = fallingBlocks.size()-1; i >= 0; i--) {
    fallingBlocks.get(i).update(matrix);
    fallingBlocks.get(i).launchpadRefresh( matrix, matrixVel);
  }
  
  drawMatrix();
  
}


//Draw Matrix
void drawMatrix(){
  
  for (int x=0; x<9; x++){
    for (int y=0; y<8; y++){

     if ((matrixPrevious[x][y] == false) && (matrix[x][y]==true)) myBus.sendNoteOn(channel, x + (y * 16), matrixVel[x][y]);
     if ((matrixPrevious[x][y] == true) && (matrix[x][y]==false)) myBus.sendNoteOff(channel, x + (y * 16), 127);
      
     matrixPrevious[x][y] = matrix[x][y];
     
      
    }
  }
  
}

void noteOn(int _channel, int _pitch, int _velocity) {
  pitch=_pitch;
  println("Pitch:"+pitch);
  
  PVector pitchPos = new PVector(pitch%16, int(pitch/16));
  
  for (int i = fallingBlocks.size()-1; i >= 0; i--) {
    if ((pitchPos.x == fallingBlocks.get(i).pos.x) && (pitchPos.y == fallingBlocks.get(i).pos.y)){
      fallingBlocks.get(i).floatPos.y=8;
    } 
  } 
}
void noteOff(int _channel, int _pitch, int _velocity) {
  
}



