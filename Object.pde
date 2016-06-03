//This class acts like a game object, they have a position, speed, light, and other things
class Object {
  //Varaibles
  PVector pos, spd;
  int velo; //15 - Red ; 16 - Green ; 19 - Orange ; 127 - Yellow


  //Constructors
  Object(int _x, int _y, float _xspd, float _yspd, int _velo) {
    pos = new PVector( _x, _y);
    spd = new PVector( _xspd, _yspd);
    velo = _velo;
  }

  Object(int _x, int _y) {
    pos = new PVector( _x, _y);
    spd = new PVector();
    velo = 0;
  }

  //Render
  void render(float cellOffsetx, float cellOffsety, float cellWidth, float cellHeight, View view) {
    if (velo == 15) fill(255, 0, 0); //Red
    else if (velo == 16) fill(0, 255, 0); //Green
    else if (velo == 19) fill(255, 127, 0); //Orange
    else fill(255, 255, 0); //Yellow

    noStroke();
    rectView(cellOffsetx + (pos.x * cellWidth), cellOffsety + (round(pos.y) * cellHeight), cellWidth, cellHeight, view);
    
  }

  //Update
  void update() {
    pos.add(spd);
  }
}

