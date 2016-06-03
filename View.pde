class View{
  //Variables
  
  PVector pos, size;
  int portX, portY;
  
  //Constructor
  View(PVector _pos, PVector _size, int _portX, int _portY){
    pos = new PVector(_pos.x, _pos.y);
    size = new PVector(_size.x, _size.y);
    portX = _portX;
    portY = _portY;
  }
}

void rectView(float x, float y, float _width, float _height, View view){
  rect(x + view.pos.x + view.portX, y + view.pos.y + view.portY, _width, _height);
}
