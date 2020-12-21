class Displayer extends Module{
  
  boolean connectedToGenerator = false;  
  PImage img;
  boolean recording = false;
  
  Displayer(){
    super();
    size = new PVector(250, 274);
    c = color(200, 100, 200);
    name = "display";
    isDisplay = true;
    
    cp5.addButton("record"+str(id))
      .setLabel("")
      .setPosition(size.x-18, 5)
      .setSize(15, 15)
      .setColorBackground(color(100, 0, 0))
      .plugTo(this, "record")
      .setGroup("g"+str(id))
      ; 
    
    ins = new InputNode[4];
    
    ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
    ins[1] = new InputNode(new PVector(id, 1), new PVector(pos.x+15, pos.y));
    ins[2] = new InputNode(new PVector(id, 2), new PVector(pos.x+25, pos.y));
    ins[3] = new InputNode(new PVector(id, 3), new PVector(pos.x+35, pos.y));
    
    ins[1].c = color(255, 0, 0);
    ins[2].c = color(0, 255, 0);
    ins[3].c = color(0, 0, 255);
    
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
  
  void record(){
    if (recording){
      recording = false;
      cp5.getController("record"+str(id)).setColorBackground(color(100, 0, 0));
    } else {
      recording = true;
      cp5.getController("record"+str(id)).setColorBackground(color(200, 0, 0));
    }
  }
  
  void changeDataDimensions(int w, int h){  
    //img.resize(w, h); 
    //size = new PVector(w, 25);
    //grabber.pos = new PVector(pos.x+size.x/2, pos.y);
  }
  
  void operate(){
    super.operate();
    int in0 = ins[0].flowId;
    int in1 = ins[1].flowId;
    int in2 = ins[2].flowId;
    int in3 = ins[3].flowId;
    int w =  img.width;
    int h =  img.height;
   
    img.loadPixels();    
    //if any rgb channels are live, override input 1
    if (in1 >= 1 || in2 >= 1 || in3 >= 1){
      for (int i = 0; i < w; i++){
        for (int j = 0; j < h; j++){
          int loc = i+j*w;
          img.pixels[loc] = color(stack.get(in1).data[loc], stack.get(in2).data[loc], stack.get(in3).data[loc]);
        }
      }      
    } else { // grayscale
      for (int i = 0; i < w; i++){
        for (int j = 0; j < h; j++){
          int loc = i+j*w;
          img.pixels[loc] = color(stack.get(in0).data[loc]%256); //should we try to get rid of %256?
        }
      }
    }
    img.updatePixels();
  }
  
  void display(){
    super.display();
    if ((ins[0].flowId >= 1 || ins[1].flowId >= 1 || ins[2].flowId >= 1 || ins[3].flowId >= 1) && (ins[0].lookUp || ins[1].lookUp || ins[2].lookUp || ins[3].lookUp)){
      operate();
      for (InputNode n : ins){
        n.lookUp = false;
      }
    }
    image(img, pos.x, pos.y+24);
    if (recording){
      img.save(str(frameCount)+".tif");
    }
  }
  
  void headsUp(){
    super.headsUp();
  }
  
}
