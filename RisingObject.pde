//This class is for the first game mode, the pixels will rise to the top of the matrix, if they go past the top, it's game over
//If you press a pixel it will fall back down top the bottom of the matrix
class RisingObject extends Object{
  
  //Variables
  
  
  //Constructors
  RisingObject(int _x, int _y, float _xspd, float _yspd, int _velo){
    super(_x, _y, _xspd, _yspd, _velo);
  }
  
  RisingObject(int _x, int _y){
    super( _x, _y);
  }
  
  //Object Update
  void update(boolean[][] matrix){
    super.update(matrix);
    //Check position to change velo
    if (pos.y==7) velo = 96;
    else velo = 127;
  }
  
  //Refresh with Launchpad
  void launchpadRefresh(boolean[][] matrix, int[][] matrixVelo){
    super.launchpadRefresh(matrix, matrixVelo);
  }

}
