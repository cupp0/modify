//I think we need to abstract further to get more flexible behaivour
//from Generators. Right now, they only operate if a display sees them.
//We need them to operate if a modifier sees them too.

class NoiseGenerator extends Module{
  
  boolean cartesian = true;
  
  NoiseGenerator(){
    super();
    size = new PVector(99, 52);
    c = color(150, 100, 200);
    seeds.add(random(1000));
    name = "noise";
    
    cp5.addTextfield("w"+str(id))
      .setLabel("")
      .setPosition(4, 3)
      .setSize(20, 10)
      .setColor(color(255,0,0))
      .show()
      .setGroup("g"+str(id))      
      ;
      
    cp5.addTextfield("h"+str(id))
      .setLabel("")     
      .setPosition(4, 15)
      .setSize(20, 10)
      .setColor(color(255,0,0))
      .show()
      .setGroup("g"+str(id))
      ;
      
    cp5.addTextfield("noiseGenSeed"+str(id))
      .setLabel("") 
      .setText(str(seeds.size()-1))
      .setPosition(28, 15)
      .setSize(20, 10)
      .setColor(color(255,0,0))
      .show()
      .setGroup("g"+str(id))
      ;  
      
    cp5.addButton("build"+str(id))
      .setLabel("")
      .setPosition(28, 3)
      .setSize(10, 10)
      .plugTo(this, "changeDimensions")
      .setGroup("g"+str(id))
      ; 
      
    cp5.addRadioButton("noiseMode"+str(id))
      .setPosition(56, 3)
      .setSize(10, 10)
      .addItem("cart"+str(id),1)
      .addItem("pol"+str(id),2)
      .setGroup("g"+str(id))
      ;  
      
    cp5.addSlider("xStep"+str(id))
      .setLabel("x")
      .setPosition(8, 27)
      .setWidth(74)
      .setHeight(10)
      .setRange(0, .1)
      .setValue(.01)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))
      ;
      
    cp5.addSlider("yStep"+str(id))
      .setLabel("y")
      .setPosition(8, 39)
      .setWidth(74)
      .setHeight(10)
      .setRange(0, .1)
      .setValue(.01)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))
      ; 

    grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2-2, pos.y));
    
    outs = new OutputNode[1];
    modIns = new ModInput[2];
    outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
    modIns[0] = new ModInput(new PVector(id, 0, -1), new PVector(pos.x+size.x-4, pos.y+29), "xStep"+str(id));
    modIns[1] = new ModInput(new PVector(id, 1, -1), new PVector(pos.x+size.x-4, pos.y+41), "yStep"+str(id));
      
  }
  
  //clunky but ok. We need a way to distinguish manual slider changes from
  //those performed by Modifiers. Controller has a method isMousePressed(),
  // but 
  
  void cp5Handler(float val){
    if (cp5.getController("xStep"+str(id)).isMousePressed()){
      if (!modIns[0].pauseInput){
        modIns[0].baseVal = val;
        modIns[0].pauseInput = true;
      }
    }
    if (cp5.getController("yStep"+str(id)).isMousePressed()){
      if (!modIns[1].pauseInput){
        modIns[1].baseVal = val;
        modIns[1].pauseInput = true;
      }
    }
    headsUp();
  }
  
  void operate(){
    int out = outs[0].flowId;
    int w = stack.get(out).dataWidth;
    int h = stack.get(out).dataHeight;
    float xStep = cp5.getController("xStep"+str(id)).getValue();
    float yStep = cp5.getController("yStep"+str(id)).getValue();
    float seed = seeds.get(int(cp5.get(Textfield.class, "noiseGenSeed"+str(id)).getText()));
    float a = 0;
    
    for (int i = 0; i < w; i++){
      for (int j = 0; j < h; j++){
        if (cp5.getGroup("noiseMode"+str(id)).getArrayValue(1) == 1){
          a = PVector.angleBetween(new PVector(1, 0), new PVector(i-w/2, j-h/2));
          if (j > h/2){
            a = 2*PI-a;
          }
          stack.get(out).data[i+j*w] = map((float)noise.eval(seed+xStep*100*cos(a), seed+yStep*100*sin(a)), -1, 1, 0, 255);
        } else {
          stack.get(out).data[i+j*w] = map((float)noise.eval(seed+xStep*i, seed+yStep*j), -1, 1, 0, 255);
        }
      }
    }
    super.lookDown();
  }
  
  void changeDimensions(){   
    int w = int(cp5.get(Textfield.class, "w"+str(id)).getText());
    int h = int(cp5.get(Textfield.class, "h"+str(id)).getText());
    super.changeDataDimensions(w, h);
  }
  
  void headsUp(){
    super.headsUp();
  }

} 

class Math extends Module{
    
  Math(){
    super();
    size = new PVector(101, 48);
    c = color(150, 100, 200);
    seeds.add(random(1000));
    name = "math";
    cp5.addTextfield("w"+str(id))
      .setLabel("")
      .setPosition(5, 4)
      .setSize(20, 12)
      .setColor(color(255,0,0))
      .show()
      .setText("250")
      .setGroup("g"+str(id))      
      ;
      
    cp5.addTextfield("h"+str(id))
      .setLabel("")     
      .setPosition(5, 16)
      .setSize(20, 12)
      .setColor(color(255,0,0))
      .show()
      .setText("250")
      .setGroup("g"+str(id))
      ;
      
    cp5.addButton("build"+str(id))
      .setLabel("")
      .setPosition(29, 4)
      .setSize(10, 10)
      .plugTo(this, "changeDimensions")
      .setGroup("g"+str(id))
      ; 
    cp5.addTextfield("mathInput"+str(id))
      .setLabel("")
      .setPosition(29, 16)
      .setSize(69, 12)
      .setColor(color(255,0,0))
      .show()
      .setText("xs")
      .setGroup("g"+str(id))      
      ;
      
    cp5.addTextfield("rangeMinX"+str(id))
      .setLabel("")
      .setPosition(5, 32)
      .setSize(15, 12)
      .setColor(color(255,0,0))
      .show()
      .setText("-10")
      .setGroup("g"+str(id))      
      ;
      
    cp5.addTextfield("rangeMinY"+str(id))
      .setLabel("")     
      .setPosition(23, 32)
      .setSize(15, 12)
      .setColor(color(255,0,0))
      .show()
      .setText("-10")
      .setGroup("g"+str(id))
      ;
      
    cp5.addTextfield("rangeMaxX"+str(id))
      .setLabel("")
      .setPosition(68, 32)
      .setSize(15, 12)
      .setColor(color(255,0,0))
      .show()
      .setText("10")
      .setGroup("g"+str(id))      
      ;
      
    cp5.addTextfield("rangeMaxY"+str(id))
      .setLabel("")     
      .setPosition(83, 32)
      .setSize(15, 12)
      .setColor(color(255,0,0))
      .show()
      .setText("10")
      .setGroup("g"+str(id))
      ;   
      
    cp5.addButton("evaluate"+str(id))
      .setLabel("")
      .setPosition(45, 32)
      .setSize(10, 10)
      .plugTo(this, "headsUp")
      .setGroup("g"+str(id))
      ;   
      
    grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2-2, pos.y));
    
    outs = new OutputNode[1];
    outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
  
  }
  
  void operate(){
    //super.operate();
    int out = outs[0].flowId;
    int w = stack.get(out).dataWidth;
    int h = stack.get(out).dataHeight;
    String text = cp5.get(Textfield.class, "mathInput"+str(id)).getText();
    int minX = int(cp5.get(Textfield.class, "rangeMinX"+str(id)).getText());
    int minY = int(cp5.get(Textfield.class, "rangeMinY"+str(id)).getText());
    int maxX = int(cp5.get(Textfield.class, "rangeMaxX"+str(id)).getText());
    int maxY = int(cp5.get(Textfield.class, "rangeMaxY"+str(id)).getText());
    Expression exp = new Expression(text);
    exp.evaluateOverField(minX, minY, maxX, maxY, w, h);
    for (int i = 0; i < w; i++){
      for (int j = 0; j < h; j++){
        stack.get(out).data[i+j*w] = map(exp.data[i+j*w], exp.min, exp.max, 0, 255);
      }
    }
    super.lookDown();
  }
  
  void changeDimensions(){   
    int w = int(cp5.get(Textfield.class, "w"+str(id)).getText());
    int h = int(cp5.get(Textfield.class, "h"+str(id)).getText());
    super.changeDataDimensions(w, h);
  }
  
  void headsUp(){
    super.headsUp();
  }
} 

public class Image extends Module{
  
  PImage imageOut;
  
  Image(){
    super();
    size = new PVector(22, 22);
    c = color(150, 100, 200);
    name = "image";
    cp5.addButton("getImage"+str(id))
      .setLabel("")
      .setPosition(10, 10)
      .setSize(10, 10)
      .plugTo(this, "getImage")
      .setGroup("g"+str(id))
      ; 

    grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2-2, pos.y));    
    outs = new OutputNode[1];
    outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));     
  }
  
  void getImage(){
    selectInput("Select a file to process:", "fileSelected", null, this); 
  }
  
  void fileSelected(File selection) {
    if (selection == null) {
      println("Window was closed or the user hit cancel.");
    } else {
      imageOut = loadImage(selection.getAbsolutePath());      
      changeDimensions();
      headsUp();      
    }
  }
  
  void operate(){
    if (imageOut != null){
      imageOut.loadPixels();
      for (int i = 0; i < imageOut.width; i++){
        for (int j = 0; j < imageOut.height; j++){
          stack.get(outs[0].flowId).data[i+j*imageOut.width] = imageOut.pixels[i+j*imageOut.width] & 0xFF;
        }
      }
      imageOut.updatePixels();
      super.lookDown();
    }
  }
  
  void changeDimensions(){
    int w = imageOut.width;
    int h= imageOut.height;
    super.changeDataDimensions(w, h);
  }
  
  void headsUp(){
    super.headsUp();
  }

} 
