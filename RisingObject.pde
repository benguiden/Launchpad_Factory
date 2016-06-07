//This class is for the first game mode, the pixels will rise to the top of the matrix, if they go past the top, it's game over
//If you press a pixel it will fall back down top the bottom of the matrix
class RisingObject extends Object{
  
  //Variables
  boolean rise=true;
  boolean move;
  float tick;
  
  //Constructors
  RisingObject(int _x, int _y, float _xspd, float _yspd, int _velo){
    super(_x, _y, _xspd, _yspd, _velo);
    tick = 30f * (120f/bpm);
    if ((pos.x == 0) && (pos.y==0)) move = false;
    else if ((pos.x == 0) && (pos.y==7)) move = false;
    else if ((pos.x == 7) && (pos.y==0)) move = false;
    else if ((pos.x == 7) && (pos.y==7)) move = false;
    else move = true;
  }
  
  RisingObject(int _x, int _y){
    super( _x, _y);
    tick = 30f * (120f/bpm);
    if ((pos.x == 0) && (pos.y==0)) move = false;
    else if ((pos.x == 0) && (pos.y==7)) move = false;
    else if ((pos.x == 7) && (pos.y==0)) move = false;
    else if ((pos.x == 7) && (pos.y==7)) move = false;
    else move = true;
  }
  
  //Object Update
  void update(){
    if (move){
      super.update();
    
      if (tick<=0){
        velo = 15;
        if (pos.x==0) spd.x = 0.5f * (120f/bpm);
        else if (pos.x==7) spd.x = -0.5f * (120f/bpm);
        else if (pos.y==0) spd.y = 0.5f * (120f/bpm);
        else if (pos.y==7) spd.y = -0.5f * (120f/bpm);
      }
      if (move) tick--;
    }
  }    
    
  
}
