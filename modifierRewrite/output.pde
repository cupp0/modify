class Displayer extends Module{
  
  boolean connectedToGenerator = false;  
  PImage img;
  
  Displayer(){
    super();
    size = new PVector(250, 25);
    c = color(200, 100, 200);
    name = "display";
    isDisplay = true;
    
    ins = new InputNode[1];
    ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
    
    grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2, pos.y));
    initDisplay();
  }
  
  void initDisplay(){ 
    int w =  250;
    int h =  250;
    img = createImage(w, h, RGB);
    img.loadPixels();
    for (int i = 0; i < img.pixels.length; i++) {
      img.pixels[i] = color(0); 
    }
    img.updatePixels();
  }
  
  void changeDataDimensions(int w, int h){  
    img.resize(w, h); 
    size = new PVector(w, 25);
    grabber.pos = new PVector(pos.x+size.x/2, pos.y);
  }
  
  void operate(){
    super.operate();
    int w =  img.width;
    int h =  img.height;
    img.loadPixels();
    for (int i = 0; i < w; i++){
      for (int j = 0; j < h; j++){
        img.pixels[i+j*w] = color(stack.get(ins[0].flowId).data[i+j*w]%256);
      }
    }
    img.updatePixels();
  }
  
  void display(){
    super.display();
    if (ins[0].flowId >= 0 && ins[0].lookUp){
      operate();
      ins[0].lookUp = false;
    }
    image(img, pos.x, pos.y+25);
  }
  
  void headsUp(){
    super.headsUp();
  }
  
}
