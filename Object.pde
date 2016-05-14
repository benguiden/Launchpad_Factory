//This class acts like a game object, they have a position, speed, light, and other things
class Object{
  //Varaibles
  PVector pos, floatPos, posPrevious, spd;
  int velo;
  
  
  //Constructors
  Object(int _x, int _y, float _xspd, float _yspd, int _velo){
    pos = new PVector( _x, _y);
    floatPos = new PVector( float(_x), float(_y));
    spd = new PVector( _xspd, _yspd);
    velo = _velo;
    
    posPrevious = pos;
  }
  
  Object(int _x, int _y){
    pos = new PVector( _x, _y);
    floatPos = new PVector( float(_x), float(_y));
    spd = new PVector();
    velo = 0;
    
    posPrevious = pos;
  }
  
  //Update
  void update(boolean[][] matrix){
    floatPos.add(spd);
    pos = new PVector(int(floatPos.x), int(floatPos.y));
    if ((posPrevious.x != pos.x) || (posPrevious.y != pos.y)){
      matrix[int(posPrevious.x)][int(posPrevious.y)] = false;
      posPrevious = new PVector(pos.x, pos.y);
    }
  }
  
  //Refresh with Launchpad
  void launchpadRefresh(boolean[][] matrix, int[][] matrixVelo){
    matrix[int(pos.x)][int(pos.y)] = true;
    matrixVelo[int(pos.x)][int(pos.y)] = velo;
  }
}
