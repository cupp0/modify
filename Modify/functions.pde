/*

all modules that have inputs and outputs

Definitely a categorical split, function vs. composition. All these Modules either
perform an operation on a single input in order to change it or compose two inputs
into one. In order to build a Module, you could use this template class and add the
appropriate UI elements to modify.pde :)

TEMPLATE:

class Template extends Module{
  
  Template(){
    super();
    name = "template";
    size = new PVector(74, 26);
    c = color(50, 100, 150);
      
    cp5.addSlider("amount"+str(id))
      .setLabel("")
      .setPosition(3, 8)
      .setWidth(64)
      .setHeight(10)
      .setRange(0, 100)
      .setValue(10)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;  

     //these are the nodes that allow the user to interact with the module 
      
     grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2, pos.y));    
     ins = new InputNode[1];
     outs = new OutputNode[1];
     modIns = new ModInput[1];
    
     ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
     outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
     modIns[0] = new ModInput(new PVector(id, 0, -1), new PVector(pos.x+size.x-4, pos.y+45), "amount"+str(id));  
  }
  
  //handles UI interaction and tells modules below that something above them is changing
  void cp5Handler(float val){
    if (cp5.getController("amount"+str(id)).isMousePressed()){
      if (!modIns[0].pauseInput){
        modIns[0].baseVal = val;
        modIns[0].pauseInput = true;
      }
    }
    super.headsUp();
  }
  
  //this is the form of every operate in Module extensions that have ins and outs. 
  //super.operate() checks modules above to see if they need updated before performing 
  //the operation. super.lookDown() makes sure Modules below know that everything above
  //them is up to date
  
  void operate(){
    super.operate();
    int in = ins[0].flowId;
    int out = outs[0].flowId;
    int w = stack.get(in).dataWidth;
    int h = stack.get(in).dataHeight;
    float val = cp5.getController("amount"+str(id)).getValue();
      
    //adds the value of the slider to all the "pixels" in the input data
    //and writes those values to the output data
    for (int i = 0; i < w; i++){
      for (int j = 0; j < h; j++){
        stack.get(out).data[i+j*w] = stack.get(in).data[i+j*w]+val;
      }
    }
      
    super.lookDown();
  }
}

*/

class Subsection extends Module{
  
  Subsection(){
    super();
    name = "subsection";
    size = new PVector(104, 64);
    c = color(50, 100, 150);
     
    cp5.addSlider("topLeftX"+str(id))
      .setLabel("")
      .setPosition(6, 8)
      .setWidth(90)
      .setHeight(10)
      .setRange(0, 250)
      .setValue(0)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;
      
    cp5.addSlider("topLeftY"+str(id))
      .setLabel("")
      .setPosition(6, 20)
      .setWidth(90)
      .setHeight(10)
      .setRange(0, 250)
      .setValue(0)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;  
    
    cp5.addSlider("bottomRightX"+str(id))
      .setLabel("")
      .setPosition(6, 36)
      .setWidth(90)
      .setHeight(10)
      .setRange(0, 250)
      .setValue(250)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;
      
    cp5.addSlider("bottomRightY"+str(id))
      .setLabel("")
      .setPosition(6, 48)
      .setWidth(90)
      .setHeight(10)
      .setRange(0, 250)
      .setValue(250)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;  

     //these are the nodes that allow the user to interact with the module 
      
     grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2, pos.y));    
     ins = new InputNode[1];
     outs = new OutputNode[1];
     modIns = new ModInput[4];
    
     ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
     outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
     modIns[0] = new ModInput(new PVector(id, 0, -1), new PVector(pos.x+size.x-4, pos.y+10), "topLeftX"+str(id));  
     modIns[1] = new ModInput(new PVector(id, 1, -1), new PVector(pos.x+size.x-4, pos.y+22), "topLeftY"+str(id));  
     modIns[2] = new ModInput(new PVector(id, 2, -1), new PVector(pos.x+size.x-4, pos.y+38), "bottomRightX"+str(id));  
     modIns[3] = new ModInput(new PVector(id, 3, -1), new PVector(pos.x+size.x-4, pos.y+50), "bottomRightY"+str(id));  
  }
  
  //handles UI interaction and tells modules below that something above them is changing
  void cp5Handler(float val){
    if (cp5.getController("topLeftX"+str(id)).isMousePressed()){
      if (!modIns[0].pauseInput){
        modIns[0].baseVal = val;
        modIns[0].pauseInput = true;
      }
    }
    if (cp5.getController("topLeftY"+str(id)).isMousePressed()){
      if (!modIns[1].pauseInput){
        modIns[1].baseVal = val;
        modIns[1].pauseInput = true;
      }
    }
    if (cp5.getController("bottomRightX"+str(id)).isMousePressed()){
      if (!modIns[2].pauseInput){
        modIns[2].baseVal = val;
        modIns[2].pauseInput = true;
      }
    }
    if (cp5.getController("bottomRightY"+str(id)).isMousePressed()){
      if (!modIns[3].pauseInput){
        modIns[3].baseVal = val;
        modIns[3].pauseInput = true;
      }
    }
    super.headsUp();
  }
  
  //this is the form of every operate in Module extensions that have ins and outs. 
  //super.operate() checks modules above to see if they need updated before performing 
  //the operation. super.lookDown() makes sure Modules below know that everything above
  //them is up to date
  
  void operate(){
    super.operate();
    int in = ins[0].flowId;
    int out = outs[0].flowId;
    int w = stack.get(in).dataWidth;
    int h = stack.get(in).dataHeight;
    PVector tl = new PVector(cp5.getController("topLeftX"+str(id)).getValue(), cp5.getController("topLeftY"+str(id)).getValue());
    PVector br = new PVector(cp5.getController("bottomRightX"+str(id)).getValue(), cp5.getController("bottomRightY"+str(id)).getValue());
    float xInc = (float)((int)br.x-(int)tl.x)/w;
    float yInc = (float)((int)br.y-(int)tl.y)/h;
    
    for (int i = 0; i < w; i++){
      for (int j = 0; j < h; j++){
        int x = (int)map(i, 0, w, tl.x, br.x);
        int y = (int)map(j, 0, h, tl.y, br.y);
        stack.get(out).data[i+j*w] = stack.get(in).data[constrain(x+y*w, 0, w*h-1)];
      }
    }  
 
    super.lookDown();
  }
}
class Translate extends Module{
  
  Translate(){
    super();
    name = "translate";
    size = new PVector(104, 36);
    c = color(50, 100, 150);
     
    cp5.addSlider("x"+str(id))
      .setLabel("")
      .setPosition(6, 8)
      .setWidth(90)
      .setHeight(10)
      .setRange(-250, 250)
      .setValue(0)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;
      
    cp5.addSlider("y"+str(id))
      .setLabel("")
      .setPosition(6, 20)
      .setWidth(90)
      .setHeight(10)
      .setRange(-250, 250)
      .setValue(0)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;   

     //these are the nodes that allow the user to interact with the module 
      
     grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2, pos.y));    
     ins = new InputNode[1];
     outs = new OutputNode[1];
     modIns = new ModInput[2];
    
     ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
     outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
     modIns[0] = new ModInput(new PVector(id, 0, -1), new PVector(pos.x+size.x-4, pos.y+10), "x"+str(id));  
     modIns[1] = new ModInput(new PVector(id, 1, -1), new PVector(pos.x+size.x-4, pos.y+22), "y"+str(id));  
}
  
  //handles UI interaction and tells modules below that something above them is changing
  void cp5Handler(float val){
    if (cp5.getController("x"+str(id)).isMousePressed()){
      if (!modIns[0].pauseInput){
        modIns[0].baseVal = val+250;
        modIns[0].pauseInput = true;
      }
    }
    if (cp5.getController("y"+str(id)).isMousePressed()){
      if (!modIns[1].pauseInput){
        modIns[1].baseVal = val+250;
        modIns[1].pauseInput = true;
      }
    }
    super.headsUp();
  }
  
  //this is the form of every operate in Module extensions that have ins and outs. 
  //super.operate() checks modules above to see if they need updated before performing 
  //the operation. super.lookDown() makes sure Modules below know that everything above
  //them is up to date
  
  void operate(){
    super.operate();
    int in = ins[0].flowId;
    int out = outs[0].flowId;
    int w = stack.get(in).dataWidth;
    int h = stack.get(in).dataHeight;
    int dataSize = w*h;
    int xTrans = (int)cp5.getController("x"+str(id)).getValue();
    int yTrans = (int)cp5.getController("y"+str(id)).getValue();
    
    for (int i = 0; i < w; i++){
      for (int j = 0; j < h; j++){
        stack.get(out).data[i+j*w] = stack.get(in).data[(dataSize+(i-xTrans)+(j-yTrans)*w)%dataSize];
      }
    }  
 
    super.lookDown();
  }
}
class Interval extends Module{
  
  boolean onTheLookout = false;
  
  Interval(){
    super();
    name = "interval";
    size = new PVector(104, 24);
    c = color(200);
        
    cp5.addSlider("interval"+str(id))
      .setLabel("")
      .setPosition(6, 8)
      .setWidth(90)
      .setHeight(10)
      .setRange(1, 250)
      .setValue(30)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;
      
     grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2, pos.y));    
     ins = new InputNode[1];
     outs = new OutputNode[1];
     modIns = new ModInput[1];
    
     ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
     outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
     modIns[0] = new ModInput(new PVector(id, 0, -1), new PVector(pos.x+size.x-4, pos.y+10), "interval"+str(id));  
}
  
  //handles UI interaction and tells modules below that something above them is changing
  void cp5Handler(float val){
    if (cp5.getController("interval"+str(id)).isMousePressed()){
      if (!modIns[0].pauseInput){
        modIns[0].baseVal = val;
        modIns[0].pauseInput = true;
      }
    }
    super.headsUp();
  }
  
  void headsUp(){
    if (super.allSystemsGo() && frameCount%(int)cp5.getController("interval"+str(id)).getValue() == 0){
      super.headsUp();
    }
  }
  
  void display(){
    super.display();
    if (super.allSystemsGo() && frameCount%(int)cp5.getController("interval"+str(id)).getValue() == 0){
      super.headsUp();
    }
  }
  
  void operate(){
    super.operate();
    if (frameCount%(int)cp5.getController("interval"+str(id)).getValue() == 0){
      int in = ins[0].flowId;
      int out = outs[0].flowId;
      int w = stack.get(in).dataWidth;
      int h = stack.get(in).dataHeight;
      
      //just passes the data from its input to its output, but will only get cued by headsUp()
      //every so often
      for (int i = 0; i < w; i++){
        for (int j = 0; j < h; j++){
          stack.get(out).data[i+j*w] = stack.get(in).data[i+j*w];
        }
      }  
    }
    super.lookDown();
  }
}

class Blur extends Module{
  
  Blur(){
    super();
    name = "blur";
    size = new PVector(104, 24);
    c = color(50, 100, 150);
     
    cp5.addSlider("radius"+str(id))
      .setLabel("")
      .setPosition(6, 8)
      .setWidth(90)
      .setHeight(10)
      .setRange(0, 10)
      .setValue(0)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;
      
    
     grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2, pos.y));    
     ins = new InputNode[2];
     outs = new OutputNode[1];
     modIns = new ModInput[1];
    
     ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
     ins[1] = new InputNode(new PVector(id, 1), new PVector(pos.x+size.x-4, pos.y));
     outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
     modIns[0] = new ModInput(new PVector(id, 0, -1), new PVector(pos.x+size.x-4, pos.y+10), "radius"+str(id));  
  }
  
  //handles UI interaction and tells modules below that something above them is changing
  void cp5Handler(float val){
    if (cp5.getController("radius"+str(id)).isMousePressed()){
      if (!modIns[0].pauseInput){
        modIns[0].baseVal = val;
        modIns[0].pauseInput = true;
      }
    }
    super.headsUp();
  }
  
  //this is the form of every operate in Module extensions that have ins and outs. 
  //super.operate() checks modules above to see if they need updated before performing 
  //the operation. super.lookDown() makes sure Modules below know that everything above
  //them is up to date
  
  void operate(){
    super.operate();
    int in1 = ins[0].flowId;
    int in2 = ins[1].flowId;
    int out = outs[0].flowId;
    int w = stack.get(in1).dataWidth;
    int h = stack.get(in1).dataHeight;
    int radius = (int)cp5.getController("radius"+str(id)).getValue();
    
    for (int i = 0; i < w; i++){
      for (int j = 0; j < h; j++){
        if (stack.get(in2).data[i+j*w] == 255){
          float sum = 0;
          for (int x = -radius; x <= radius; x++){
            for (int y = -radius; y <= radius; y++){
              int a = constrain(i+x, 0, w-1);
              int b = constrain(j+y, 0, h-1);
              sum+=stack.get(in1).data[a+b*w];
            }          
          }
          stack.get(out).data[i+j*w] = sum/pow(2*radius+1, 2);
        } else {
          stack.get(out).data[i+j*w] = stack.get(in1).data[i+j*w];
        }
      }
    }  
 
    super.lookDown();
  }
}

class Compare extends Module{
  
  boolean maskMode = true;
  
  Compare(){
    super();
    name = "compare";
    size = new PVector(74, 58);
    c = color(50, 150, 100);

    float[] arr = {1, 0, 0};
    cp5.addRadioButton("comparisons"+str(id))
      .setPosition(3, 10)
      .addItem("= "+str(id), 0)
      .addItem("< "+str(id), 1)
      .addItem("> "+str(id), 2)
      .setGroup("g"+str(id))
      .setArrayValue(arr);
      ;
      
    cp5.addSlider("equalityThreshold"+str(id))
      .setLabel("")
      .setPosition(3, 42)
      .setWidth(64)
      .setHeight(10)
      .setRange(0, 100)
      .setValue(10)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;  
      
     cp5.addButton("maskMode"+str(id))
      .setLabel("mode")
      .setPosition(37, 15)
      .setSize(15, 15)
      .plugTo(this, "maskMode")
      .setGroup("g"+str(id))
      ;  
      
     grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2, pos.y));
    
     ins = new InputNode[2];
     outs = new OutputNode[1];
     modIns = new ModInput[1];
    
     ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
     ins[1] = new InputNode(new PVector(id, 1), new PVector(pos.x+size.x-4, pos.y));
     outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
     modIns[0] = new ModInput(new PVector(id, 0, -1), new PVector(pos.x+size.x-4, pos.y+45), "equalityThreshold"+str(id));  
  }
  
  void cp5Handler(float val){
    if (cp5.getController("equalityThreshold"+str(id)).isMousePressed()){
      if (!modIns[0].pauseInput){
        modIns[0].baseVal = val;
        modIns[0].pauseInput = true;
      }
    }
    super.headsUp();
  }
  
  void maskMode(){
    maskMode = flick(maskMode);
    super.headsUp();
  }
  
  //this is the form of every operate in Module extensions that have ins and outs. 
  //super.operate() checks modules above to see if they need updated before performing 
  //the operation. super.lookDown() makes sure Modules below know that their Flows are 
  //up to date.
  
  void operate(){
    super.operate();
    int in1 = ins[0].flowId;
    int in2 = ins[1].flowId;
    int w = stack.get(in1).dataWidth;
    int h = stack.get(in1).dataHeight;
    float thresh = cp5.getController("equalityThreshold"+str(id)).getValue();
    int type = (int)cp5.getGroup("comparisons"+str(id)).getValue();
    int out = outs[0].flowId;
    if (maskMode){
      for (int i = 0; i < w; i++){
        for (int j = 0; j < h; j++){
          switch(type){
          case 0 :
            if (abs(stack.get(in1).data[i+j*w]-stack.get(in2).data[i+j*w])<thresh){
              stack.get(out).data[i+j*w] = 255;
            } else {
              stack.get(out).data[i+j*w] = 0;
            }
            break;
          case 1 :
            if (stack.get(in1).data[i+j*w] < stack.get(in2).data[i+j*w]){
              stack.get(out).data[i+j*w] = 255;
            } else {
              stack.get(out).data[i+j*w] = 0;
            }
            break;
          case 2 :
            if (stack.get(in1).data[i+j*w] > stack.get(in2).data[i+j*w]){
              stack.get(out).data[i+j*w] = 255;
            } else {
              stack.get(out).data[i+j*w] = 0;
            }
            break;  
          }
        }
      }
    } else {
      for (int i = 0; i < w; i++){
        for (int j = 0; j < h; j++){
          switch(type){
          case 0 :
            if (abs(stack.get(in1).data[i+j*w]-stack.get(in2).data[i+j*w])<thresh){
              stack.get(out).data[i+j*w] = stack.get(in1).data[i+j*w];
            } else {
              stack.get(out).data[i+j*w] = stack.get(in2).data[i+j*w];
            }
            break;
          case 1 :
            if (stack.get(in1).data[i+j*w] < stack.get(in2).data[i+j*w]){
              stack.get(out).data[i+j*w] = stack.get(in1).data[i+j*w];
            } else {
              stack.get(out).data[i+j*w] = stack.get(in2).data[i+j*w];
            }
            break;
          case 2 :
            if (stack.get(in1).data[i+j*w] > stack.get(in2).data[i+j*w]){
              stack.get(out).data[i+j*w] = stack.get(in1).data[i+j*w];
            } else {
              stack.get(out).data[i+j*w] = stack.get(in2).data[i+j*w];
            }
            break;  
          }
        }
      }
    }
    super.lookDown();
  }
  
  void headsUp(){
    super.headsUp();
  }  
}

class Util extends Module{
  
  boolean inverting = false;
  
  Util(){
    super();
    size = new PVector(74, 56);
    c = color(50, 100, 150);
    name = "util";

    cp5.addSlider("times"+str(id))
      .setLabel("")
      .setPosition(3, 8)
      .setWidth(64)
      .setHeight(10)
      .setRange(0, 255)
      .setValue(1)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;  
     
    cp5.addSlider("fineTimes"+str(id))
      .setLabel("")
      .setPosition(3, 20)
      .setWidth(64)
      .setHeight(10)
      .setRange(0, 1)
      .setValue(1)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;    
      
    cp5.addSlider("plus"+str(id))
      .setLabel("")
      .setPosition(3, 32)
      .setWidth(64)
      .setHeight(10)
      .setRange(0, 255)
      .setValue(0)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;  
      
    cp5.addButton("invert"+str(id))
      .setLabel("")
      .setPosition(3, 44)
      .setSize(10, 10)
      .plugTo(this, "invert")
      .setGroup("g"+str(id))
      ;   
      
     grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2, pos.y));
    
     ins = new InputNode[1];
     outs = new OutputNode[1];
     modIns = new ModInput[3];
    
     ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
     outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
     modIns[0] = new ModInput(new PVector(id, 0, -1), new PVector(pos.x+size.x-4, pos.y+11), "times"+str(id));  
     modIns[1] = new ModInput(new PVector(id, 1, -1), new PVector(pos.x+size.x-4, pos.y+23), "fineTimes"+str(id));  
     modIns[2] = new ModInput(new PVector(id, 2, -1), new PVector(pos.x+size.x-4, pos.y+35), "plus"+str(id));  
  }
  
  void invert(){
    inverting = flick(inverting);
    super.headsUp();
  }
  
  void cp5Handler(float val){
    if (cp5.getController("times"+str(id)).isMousePressed()){
      if (!modIns[0].pauseInput){
        modIns[0].baseVal = val;
        modIns[0].pauseInput = true;
      }
    }
    if (cp5.getController("fineTimes"+str(id)).isMousePressed()){
      if (!modIns[1].pauseInput){
        modIns[1].baseVal = val;
        modIns[1].pauseInput = true;
      }
    }
    if (cp5.getController("plus"+str(id)).isMousePressed()){
      if (!modIns[2].pauseInput){
        modIns[2].baseVal = val;
        modIns[2].pauseInput = true;
      }
    }
    super.headsUp();
  }
  
  //this is the form of every operate in Module extensions that have ins and outs. 
  //super.operate() checks modules above to see if they need updated before performing 
  //the operation. super.lookDown() makes sure Modules below know that their Flows are 
  //up to date.
  void operate(){
    super.operate();
    int in = ins[0].flowId;
    int w = stack.get(in).dataWidth;
    int h = stack.get(in).dataHeight;
    float mult = cp5.getController("times"+str(id)).getValue()*cp5.getController("fineTimes"+str(id)).getValue();
    float plus = cp5.getController("plus"+str(id)).getValue();
    int out = outs[0].flowId;
    for (int i = 0; i < w; i++){
      for (int j = 0; j < h; j++){
        if (inverting){
          stack.get(out).data[i+j*w] = (255-mult*stack.get(in).data[i+j*w]+plus)%256;
        } else {
          stack.get(out).data[i+j*w] = (mult*stack.get(in).data[i+j*w]+plus)%256;
        }
      }
    }
    super.lookDown();
  } 
}


class Mask extends Module{
  
  Mask(){
    super();
    size = new PVector(74, 36);
    c = color(50, 150, 100);
    name = "mask";
    cp5.addSlider("target"+str(id))
      .setLabel("")
      .setPosition(3, 8)
      .setWidth(64)
      .setHeight(10)
      .setRange(0, 255)
      .setValue(10)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;  
      
    cp5.addSlider("range"+str(id))
      .setLabel("")
      .setPosition(3, 20)
      .setWidth(64)
      .setHeight(10)
      .setRange(0, 100)
      .setValue(10)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;    
      
     grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2, pos.y));
    
     ins = new InputNode[3];
     outs = new OutputNode[1];
     modIns = new ModInput[2];
    
     ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
     ins[1] = new InputNode(new PVector(id, 1), new PVector(pos.x+12, pos.y));
     ins[2] = new InputNode(new PVector(id, 2), new PVector(pos.x+size.x-4, pos.y));
     outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
     modIns[0] = new ModInput(new PVector(id, 0, -1), new PVector(pos.x+size.x-4, pos.y+11), "target"+str(id));  
     modIns[1] = new ModInput(new PVector(id, 1, -1), new PVector(pos.x+size.x-4, pos.y+23), "range"+str(id));  
  }
  
  void cp5Handler(float val){
    if (cp5.getController("target"+str(id)).isMousePressed()){
      if (!modIns[0].pauseInput){
        modIns[0].baseVal = val;
        modIns[0].pauseInput = true;
      }
    }
    if (cp5.getController("range"+str(id)).isMousePressed()){
      if (!modIns[1].pauseInput){
        modIns[1].baseVal = val;
        modIns[1].pauseInput = true;
      }
    }
    super.headsUp();
  }
  
  void operate(){
    super.operate();
    int in1 = ins[0].flowId;
    int in2 = ins[1].flowId;
    int in3 = ins[2].flowId;
    int w = stack.get(in1).dataWidth;
    int h = stack.get(in1).dataHeight;
    float target = cp5.getController("target"+str(id)).getValue();
    float range = (int)cp5.getController("range"+str(id)).getValue();
    int out = outs[0].flowId;
    for (int i = 0; i < w; i++){
      for (int j = 0; j < h; j++){
        if (abs(target-stack.get(in3).data[i+j*w])< range){
          stack.get(out).data[i+j*w] = stack.get(in1).data[i+j*w];
        } else {
          stack.get(out).data[i+j*w] = stack.get(in2).data[i+j*w];
        }
      }
    }
    super.lookDown();
  }
  
  void headsUp(){
    super.headsUp();
  }  
}

class Combine extends Module{
  
  String expString = "xy+2/";
  Expression exp = new Expression(expString);
  
  Combine(){
    super();
    size = new PVector(100, 44);
    c = color(50, 150, 100);
    name = "combine";
    cp5.addTextfield("mathUtilText"+str(id))
      .setLabel("")     
      .setPosition(6, 6)
      .setSize(50, 12)
      .setColor(color(255,0,0))
      .show()
      .setText(expString)
      .setGroup("g"+str(id))
      ;
      
    cp5.addButton("evaluate"+str(id))
      .setLabel("")
      .setPosition(6, 19)
      .setSize(10, 10)
      .plugTo(this, "updateString")
      .setGroup("g"+str(id))
      ; 
      
    cp5.addSlider("multiplier"+str(id))
      .setLabel("")
      .setPosition(6, 30)
      .setWidth(88)
      .setHeight(10)
      .setRange(0, 255)
      .setValue(1)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;    
      
     grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2, pos.y));
    
     ins = new InputNode[2];
     outs = new OutputNode[1];
     modIns = new ModInput[1];
    
     ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
     ins[1] = new InputNode(new PVector(id, 1), new PVector(pos.x+size.x-4, pos.y));
     outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
     modIns[0] = new ModInput(new PVector(id, 0, -1), new PVector(pos.x+size.x-4, pos.y+32), "multiplier"+str(id));

  }
  
  void cp5Handler(float val){
    if (cp5.getController("multiplier"+str(id)).isMousePressed()){
      if (!modIns[0].pauseInput){
        modIns[0].baseVal = val;
        modIns[0].pauseInput = true;
      }
    }
    super.headsUp();
  }
  
  void updateString(){
    exp.text = cp5.get(Textfield.class, "mathUtilText"+str(id)).getText();
    super.headsUp();
  }
  
  void operate(){
    super.operate();
    int in1 = ins[0].flowId;
    int in2 = ins[1].flowId;
    int out = outs[0].flowId;
    int w = stack.get(out).dataWidth;
    int h = stack.get(out).dataHeight;
    float mult = cp5.getController("multiplier"+str(id)).getValue();
    exp.evaluateModule(in1, in2, out, w, h, mult);
    super.lookDown();
  }
  
  void headsUp(){
    super.headsUp();
  }  
}

class Gate extends Module{
    
  Gate(){
    super();
    size = new PVector(111, 36);
    c = color(50, 100, 150);
    name = "gate";  
    cp5.addSlider("gateLow"+str(id))
      .setLabel("")
      .setPosition(3, 20)
      .setWidth(100)
      .setHeight(10)
      .setRange(0, 255)
      .setValue(0)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;
    cp5.addSlider("gateHigh"+str(id))
      .setLabel("")
      .setPosition(3, 8)
      .setWidth(100)
      .setHeight(10)
      .setRange(0, 255)
      .setValue(255)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;

    grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2-2, pos.y));
    
    ins = new InputNode[1];
    outs = new OutputNode[1];
    modIns = new ModInput[2];
    
    ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
    outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
    modIns[0] = new ModInput(new PVector(id, 0, -1), new PVector(pos.x+size.x-4, pos.y+10), "gateHigh"+str(id));
    modIns[1] = new ModInput(new PVector(id, 1, -1), new PVector(pos.x+size.x-4, pos.y+22), "gateLow"+str(id));

  }
  
  //clunky but ok. We need a way to distinguish manual slider changes from
  //those performed by Modifiers. Controller has a method isMousePressed(),
  // but 
  
  void cp5Handler(float val){
    if (cp5.getController("gateHigh"+str(id)).isMousePressed()){
      if (!modIns[0].pauseInput){
        modIns[0].baseVal = val;
        modIns[0].pauseInput = true;
      }
    }
    if (cp5.getController("gateLow"+str(id)).isMousePressed()){
      if (!modIns[1].pauseInput){
        modIns[1].baseVal = val;
        modIns[1].pauseInput = true;
      }
    }
    super.headsUp();
  }
  
  void operate(){
    super.operate();
    int in = ins[0].flowId;
    int out = outs[0].flowId;
    int w = stack.get(in).dataWidth;
    int h = stack.get(in).dataHeight;
    float low = cp5.getController("gateLow"+str(id)).getValue();
    float high = cp5.getController("gateHigh"+str(id)).getValue();
    for (int i = 0; i < w; i++){
      for (int j = 0; j < h; j++){
        if (stack.get(in).data[i+j*w] < low){
          stack.get(out).data[i+j*w] = 0;
        }else if (stack.get(in).data[i+j*w] > high){
          stack.get(out).data[i+j*w] = 255;
        } else {
          stack.get(out).data[i+j*w] = stack.get(in).data[i+j*w];
        }
      }
    }
    super.lookDown();
  }
}

class Feedback extends Module{
  
  //FeedbackIn fbInput;
  //FeedbackOut fbOutput;

  
  Feedback(){
    super();
    size = new PVector(111, 24);
    c = color(200);
    name = "feedback";  
    isFeedback = true;
  
    cp5.addSlider("rate"+str(id))
      .setLabel("")
      .setPosition(6, 8)
      .setWidth(100)
      .setHeight(10)
      .setRange(1, 60)
      .setValue(1)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;

    grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2-2, pos.y));
    
    ins = new InputNode[2];
    outs = new OutputNode[2];
    
    ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
    ins[1] = new InputNode(new PVector(id, 1), new PVector(pos.x+size.x-4, pos.y));
    outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
    outs[1] = new OutputNode(new PVector(id, 1), new PVector(pos.x+size.x-4, pos.y+size.y-4));
    outs[1].flowId = outs[0].flowId;
    //fbInput = new FeedbackIn(new PVector(id, 0), new PVector(pos.x+size.x-4, pos.y));
    //fbOutput = new FeedbackOut(new PVector(id, 0), new PVector(pos.x+size.x-4, pos.y+size.y-4));

  }
  
  void headsUp(){
    for (PVector p : outs[0].receivers){
      modules.get((int)p.x).ins[(int)p.y].lookUp = true;
    }      
    for (PVector p : outs[0].receivers){
      if (!modules.get((int)p.x).isDisplay){
        modules.get((int)p.x).headsUp();
      }
    }
    for (PVector p : outs[1].receivers){
      modules.get((int)p.x).ins[(int)p.y].lookUp = true;
    }  
    for (PVector p : outs[1].receivers){
      if (!modules.get((int)p.x).isDisplay){
        modules.get((int)p.x).headsUp();
      }
    }
  }
  
  void operate(){
    //println(ins[0].lookUp);
    int in1 = ins[0].flowId;
    int in2 = ins[1].flowId;
    int out = outs[0].flowId;
    int w = stack.get(in1).dataWidth;
    int h = stack.get(in1).dataHeight;
    if (ins[0].lookUp){
      if (modules.get((int)ins[0].sender.x).allSystemsGo()){
        modules.get((int)ins[0].sender.x).operate();
      }
      arrayCopy(stack.get(in1).data, stack.get(out).data);
    } else {     
      modules.get((int)ins[1].sender.x).operate();
      arrayCopy(stack.get(in2).data, stack.get(out).data);
    }
    super.lookDown();
  }
  
  void feedbackPrimer(){
    if (frameCount%(int)cp5.getController("rate"+str(id)).getValue() == 0){
      headsUp();
    }
  }
  
  void changeDataDimensions(){
    return;
  }
  
  void display(){
    super.display();
  }
}


class Blend extends Module{
    
  Blend(){
    super();
    size = new PVector(111, 24);
    c = color(50, 150, 100);
    name = "blend";  
    
    cp5.addSlider("amount"+str(id))
      .setLabel("")
      .setPosition(3, 8)
      .setWidth(100)
      .setHeight(10)
      .setRange(0, 1)
      .setValue(.5)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;

    grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2-2, pos.y));
    
    ins = new InputNode[2];
    outs = new OutputNode[1];
    modIns = new ModInput[1];
    
    ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
    ins[1] = new InputNode(new PVector(id, 1), new PVector(pos.x+size.x-4, pos.y));
    outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
    modIns[0] = new ModInput(new PVector(id, 0, -1), new PVector(pos.x+size.x-4, pos.y+10), "amount"+str(id));
  }
  
  void cp5Handler(float val){
    if (cp5.getController("amount"+str(id)).isMousePressed()){
      if (!modIns[0].pauseInput){
        modIns[0].baseVal = val;
        modIns[0].pauseInput = true;
      }
    }
    super.headsUp();
  }
  
  void operate(){
    super.operate();
    int in1 = ins[0].flowId;
    int in2 = ins[1].flowId;
    int out = outs[0].flowId;
    int w = stack.get(in1).dataWidth;
    int h = stack.get(in1).dataHeight;
    float blend = cp5.getController("amount"+str(id)).getValue();
    for (int i = 0; i < w; i++){
      for (int j = 0; j < h; j++){
        stack.get(out).data[i+j*w] = blend*stack.get(in2).data[i+j*w]+(1-blend)*stack.get(in1).data[i+j*w];
      }
    }
    super.lookDown();
  }
  
  void headsUp(){
    super.headsUp();
  }
}

class Rotate extends Module{
    
  Rotate(){
    super();
    size = new PVector(111, 24);
    c = color(50, 100, 150);
    name = "rotate";  
    
    cp5.addSlider("amount"+str(id))
      .setLabel("")
      .setPosition(3, 8)
      .setWidth(100)
      .setHeight(10)
      .setRange(-2*PI, 2*PI)
      .setValue(0)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;

    grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2-2, pos.y));
    
    ins = new InputNode[1];
    outs = new OutputNode[1];
    modIns = new ModInput[1];
    
    ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
    outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
    modIns[0] = new ModInput(new PVector(id, 0, -1), new PVector(pos.x+size.x-4, pos.y+10), "amount"+str(id));
  }
  
  void cp5Handler(float val){
    if (cp5.getController("amount"+str(id)).isMousePressed()){
      if (!modIns[0].pauseInput){
        //um. i dunno why i have to add .1 here. but i do
        modIns[0].baseVal = val+.1;
        modIns[0].pauseInput = true;
      }
    }
    super.headsUp();
  }
  
  void operate(){
    super.operate();
    int in = ins[0].flowId;
    int out = outs[0].flowId;
    int w = stack.get(in).dataWidth;
    int h = stack.get(in).dataHeight;
    float amount = cp5.getController("amount"+str(id)).getValue();
    for (int i = 0; i < w; i++){
      for (int j = 0; j < h; j++){
        PVector rotation = rotatePV(new PVector(i, j), new PVector(w/2, h/2), amount);
        stack.get(out).data[i+j*w] = stack.get(in).data[((w*h-1)+(int)rotation.x+(int)rotation.y*w)%(w*h-1)];
      }
    }
    super.lookDown();
  }
  
  void headsUp(){
    super.headsUp();
  }
}

class CheapStatic extends Module{
    
  CheapStatic(){
    super();
    size = new PVector(111, 24);
    c = color(50, 100, 150);
    name = "static";  
    
    cp5.addSlider("amount"+str(id))
      .setLabel("")
      .setPosition(3, 8)
      .setWidth(100)
      .setHeight(10)
      .setRange(0, 100)
      .setValue(0)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;

    grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2-2, pos.y));
    
    ins = new InputNode[1];
    outs = new OutputNode[1];
    modIns = new ModInput[1];
    
    ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
    outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
    modIns[0] = new ModInput(new PVector(id, 0, -1), new PVector(pos.x+size.x-4, pos.y+10), "amount"+str(id));
  }
  
  void cp5Handler(float val){
    if (cp5.getController("amount"+str(id)).isMousePressed()){
      if (!modIns[0].pauseInput){
        //why do we have to add to val if the slider min val < 0
        modIns[0].baseVal = val+.1;
        modIns[0].pauseInput = true;
      }
    }
    super.headsUp();
  }
  
  void operate(){
    super.operate();
    int in = ins[0].flowId;
    int out = outs[0].flowId;
    int w = stack.get(in).dataWidth;
    int h = stack.get(in).dataHeight;
    float amount = cp5.getController("amount"+str(id)).getValue();
    for (int i = 0; i < w; i++){
      for (int j = 0; j < h; j++){
        stack.get(out).data[i+j*w] = (stack.get(in).data[i+j*w]+random(amount)-amount/2)%256;
      }
    }
    super.lookDown();
  }
  
  void headsUp(){
    super.headsUp();
  }
}

class Redux extends Module{
    
  Redux(){
    super();
    size = new PVector(111, 24);
    c = color(50, 100, 150);
    name = "redux";  
    cp5.addSlider("res"+str(id))
      .setLabel("")
      .setPosition(3, 8)
      .setWidth(100)
      .setHeight(10)
      .setRange(1, 63)
      .setValue(1)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;

    grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2-2, pos.y));
    
    ins = new InputNode[1];
    outs = new OutputNode[1];
    modIns = new ModInput[1];
    
    ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
    outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
    modIns[0] = new ModInput(new PVector(id, 0, -1), new PVector(pos.x+size.x-4, pos.y+10), "res"+str(id));

  }
  
  void cp5Handler(float val){
    if (cp5.getController("res"+str(id)).isMousePressed()){
      if (!modIns[0].pauseInput){
        modIns[0].baseVal = val;
        modIns[0].pauseInput = true;
      }
    }
    super.headsUp();
  }
  
  void operate(){
    super.operate();
    int in = ins[0].flowId;
    int out = outs[0].flowId;
    int w = stack.get(in).dataWidth;
    int h = stack.get(in).dataHeight;
    int res = (int)cp5.getController("res"+str(id)).getValue();
    for (int i = 0; i < w; i+=res){
      for (int j = 0; j < h; j+=res){
        for (int x = 0; x < res; x++){
          for (int y = 0; y < res; y++){
            if (i+x < w && j+y < h) {
              stack.get(out).data[(i+x)+(j+y)*w] = stack.get(in).data[i+j*w];
            }
          }
        }
      }
    }
    super.lookDown();
  }
  
  void headsUp(){
    super.headsUp();
  }
}

class Quantize extends Module{
    
  Quantize(){
    super();
    size = new PVector(111, 24);
    c = color(50, 100, 150);
    name = "quantize";  
    cp5.addSlider("res"+str(id))
      .setLabel("")
      .setPosition(3, 8)
      .setWidth(100)
      .setHeight(10)
      .setRange(1, 63)
      .setValue(1)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;

    grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2-2, pos.y));
    
    ins = new InputNode[1];
    outs = new OutputNode[1];
    modIns = new ModInput[1];
    
    ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
    outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
    modIns[0] = new ModInput(new PVector(id, 0, -1), new PVector(pos.x+size.x-4, pos.y+10), "res"+str(id));

  }
  
  //clunky but ok. We need a way to distinguish manual slider changes from
  //those performed by Modifiers. Controller has a method isMousePressed(),
  // but 
  
  void cp5Handler(float val){
    if (cp5.getController("res"+str(id)).isMousePressed()){
      if (!modIns[0].pauseInput){
        modIns[0].baseVal = val;
        modIns[0].pauseInput = true;
      }
    }
    super.headsUp();
  }
  
  void operate(){
    super.operate();
    int in = ins[0].flowId;
    int out = outs[0].flowId;
    int w = stack.get(in).dataWidth;
    int h = stack.get(in).dataHeight;
    float res = (int)cp5.getController("res"+str(id)).getValue();
    for (int i = 0; i < w; i++){
      for (int j = 0; j < h; j++){
        stack.get(out).data[i+j*w] = stack.get(in).data[i+j*w]-stack.get(in).data[i+j*w]%res;
      }
    }
    super.lookDown();
  }
  
}

class Boundary extends Module{
    
  Boundary(){
    super();
    size = new PVector(111, 36);
    c = color(50, 100, 150);
    name = "boundary";  
    cp5.addSlider("differenceThresh"+str(id))
      .setLabel("")
      .setPosition(3, 8)
      .setWidth(100)
      .setHeight(10)
      .setRange(1, 255)
      .setValue(1)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;
    cp5.addSlider("thickness"+str(id))
      .setLabel("")
      .setPosition(3, 20)
      .setWidth(100)
      .setHeight(10)
      .setRange(1, 25)
      .setValue(3)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;

    grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2-2, pos.y));
    
    ins = new InputNode[1];
    outs = new OutputNode[1];
    modIns = new ModInput[2];
    
    ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
    outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
    modIns[0] = new ModInput(new PVector(id, 0, -1), new PVector(pos.x+size.x-4, pos.y+10), "differenceThresh"+str(id));
    modIns[1] = new ModInput(new PVector(id, 1, -1), new PVector(pos.x+size.x-4, pos.y+22), "thickness"+str(id));

  }
  
  //clunky but ok. We need a way to distinguish manual slider changes from
  //those performed by Modifiers. Controller has a method isMousePressed(),
  // but 
  
  void cp5Handler(float val){
    if (cp5.getController("differenceThresh"+str(id)).isMousePressed()){
      if (!modIns[0].pauseInput){
        modIns[0].baseVal = val;
        modIns[0].pauseInput = true;
      }
    }
    if (cp5.getController("thickness"+str(id)).isMousePressed()){
      if (!modIns[1].pauseInput){
        modIns[1].baseVal = val;
        modIns[1].pauseInput = true;
      }
    }
    super.headsUp();
  }
  
  //fine for now
  void operate(){
    super.operate();
    int in = ins[0].flowId;
    int out = outs[0].flowId;
    int w = stack.get(in).dataWidth;
    int h = stack.get(in).dataHeight;
    int thresh = (int)cp5.getController("differenceThresh"+str(id)).getValue();
    int tol = (int)cp5.getController("thickness"+str(id)).getValue();
  
    for (int i = 0; i < w; i++){
      for (int j = 0; j < h; j++){
        for (int x = 0; x < tol; x++){
          for (int y = 0; y < tol; y++){
            if (abs(stack.get(in).data[i+j*w]-stack.get(in).data[constrain((i+x)+(j+y)*w, 0, w*h-1)]) > thresh || abs(stack.get(in).data[i+j*w]-stack.get(in).data[constrain((i-x)+(j-y)*w, 0, w*h-1)]) > thresh){
              stack.get(out).data[i+j*w] = 255; 
              x=tol+1;
              y=tol+1;
            } else {
              stack.get(out).data[i+j*w] = 0; 
            }
          }
        }
      }
    }
    super.lookDown();
  }
  
  void headsUp(){
    super.headsUp();
  }
}

public class threeD extends Module{
    
  PGraphics buffer;
  //680x383
  PImage tex = loadImage("carl.png");
  boolean carl = false;
  
  threeD(){
    super();    
    size = new PVector(111, 110);
    c = color(50, 150, 100);
    name = "3D";  
    
    cp5.addSlider("zoom"+str(id))
      .setLabel("")
      .setPosition(3, 8)
      .setWidth(100)
      .setHeight(10)
      .setRange(0, 2000)
      .setValue(500)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;     
    cp5.addSlider("cameraYaw"+str(id))
      .setLabel("")
      .setPosition(3, 20)
      .setWidth(100)
      .setHeight(10)
      .setRange(-PI/2, -.01)
      .setValue(0)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;
    cp5.addSlider("cameraPitch"+str(id))
      .setLabel("")
      .setPosition(3, 32)
      .setWidth(100)
      .setHeight(10)
      .setRange(-8*PI, 8*PI)
      .setValue(0)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;
      
    cp5.addSlider("cameraPan"+str(id))
      .setLabel("")
      .setPosition(3, 44)
      .setWidth(100)
      .setHeight(10)
      .setRange(-1000, 1000)
      .setValue(0)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;
    cp5.addSlider("cameraHeight"+str(id))
      .setLabel("")
      .setPosition(3, 56)
      .setWidth(100)
      .setHeight(10)
      .setRange(-1000, 1000)
      .setValue(0)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;  
      
    
    cp5.addSlider("resolution"+str(id))
      .setLabel("")
      .setPosition(3, 74)
      .setWidth(100)
      .setHeight(10)
      .setRange(2, 25)
      .setValue(5)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ; 
      
    cp5.addButton("carl"+str(id))
      .setLabel("texture on/off")
      .setPosition(45, 88)
      .setWidth(20)
      .setHeight(20)
      .plugTo(this, "carl")
      .setGroup("g"+str(id))      
      ;    

    grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2-2, pos.y));
    
    ins = new InputNode[3];
    outs = new OutputNode[1];
    modIns = new ModInput[5];
    
    ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
    ins[1] = new InputNode(new PVector(id, 1), new PVector(pos.x+14, pos.y));
    ins[2] = new InputNode(new PVector(id, 2), new PVector(pos.x+size.x-4, pos.y));
    outs[0] = new OutputNode(new PVector(id, 0), new PVector(pos.x, pos.y+size.y-4));
    
    modIns[0] = new ModInput(new PVector(id, 0, -1), new PVector(pos.x+size.x-4, pos.y+11), "zoom"+str(id));
    modIns[1] = new ModInput(new PVector(id, 1, -1), new PVector(pos.x+size.x-4, pos.y+23), "cameraYaw"+str(id));
    modIns[2] = new ModInput(new PVector(id, 2, -1), new PVector(pos.x+size.x-4, pos.y+35), "cameraPitch"+str(id));
    modIns[3] = new ModInput(new PVector(id, 3, -1), new PVector(pos.x+size.x-4, pos.y+47), "cameraPan"+str(id));
    modIns[4] = new ModInput(new PVector(id, 4, -1), new PVector(pos.x+size.x-4, pos.y+59), "cameraHeight"+str(id));

    buffer = createGraphics(250, 250, P3D);
    model = createShape();
  }
  
  void carl(){
    carl = flick(carl);
    super.headsUp();
  }
  
  void cp5Handler(float val){
    if (cp5.getController("zoom"+str(id)).isMousePressed()){
      if (!modIns[0].pauseInput){
        modIns[0].baseVal = val;
        modIns[0].pauseInput = true;
      }
    }
    if (cp5.getController("cameraYaw"+str(id)).isMousePressed()){
      if (!modIns[1].pauseInput){
        modIns[1].baseVal = val+PI/2;
        modIns[1].pauseInput = true;
      }
    }
    if (cp5.getController("cameraPitch"+str(id)).isMousePressed()){
      if (!modIns[2].pauseInput){
        modIns[2].baseVal = val+8*PI;
        modIns[2].pauseInput = true;
      }
    }
    if (cp5.getController("cameraPan"+str(id)).isMousePressed()){
      if (!modIns[3].pauseInput){
        modIns[3].baseVal = val+1000;
        modIns[3].pauseInput = true;
      }
    }
    if (cp5.getController("cameraHeight"+str(id)).isMousePressed()){
      if (!modIns[4].pauseInput){
        modIns[4].baseVal = val+1000;
        modIns[4].pauseInput = true;
      }
    }
    super.headsUp();
  }
  
  void updateTexture(){
    tex = createImage(250, 250, RGB);
    int in = ins[2].flowId;
    tex.loadPixels();
    for (int i = 0; i < stack.get(in).data.length; i++){
      tex.pixels[i] = color(stack.get(in).data[i]);
    }
    tex.updatePixels();
  }
  
  void updateModel(){
    int in = ins[0].flowId;
    int in1 = ins[1].flowId;
    int w = stack.get(in).dataWidth;
    int h = stack.get(in).dataHeight;
    int rowCounter = 0;
    int columnCounter = 0;
    int res = (int)cp5.getController("resolution"+str(id)).getValue();
    boolean rowInc = true;
    boolean columnInc = true;
    
    
    model = createShape();
    model.beginShape(TRIANGLE_STRIP);
    if (carl){
      model.texture(tex);
    }
    
    model.noStroke();
    model.fill(100, 255, 150);
    
    //make the triangle mesh out of input values
    while ( rowCounter + columnCounter < w+h-res ) {      
      if (rowInc){
        if (rowCounter < w-res){
          rowCounter+=res;
        }
      } else {
        rowCounter-=res;
        if (columnInc) {
          columnCounter+=res;
          if (columnCounter >= h){
            columnCounter = h-res;
            rowCounter+=(2*res);
            rowInc = true;
            columnInc = flick(columnInc);
          }
        } else {
          columnCounter-= res;
          if (columnCounter < 0){
            columnCounter = 0;
            rowCounter+=(2*res);
            rowInc = true;
            columnInc = flick(columnInc);
          }
        }        
      }
      if (rowCounter < w && columnCounter < h){
        float modAmount = stack.get(in1).data[rowCounter+columnCounter*w]/255;
        PVector mod = new PVector(125-rowCounter, 125-columnCounter).mult(modAmount);
        model.vertex((int)(mod.x+rowCounter), (int)(mod.y+columnCounter), stack.get(in).data[rowCounter+columnCounter*w], map(rowCounter, 0, 250, 0, tex.width), map(columnCounter, 0, 250, 0, tex.height));
      }
      rowInc = flick(rowInc);
    }
    model.endShape(CLOSE);
    
  }
  
  void operate(){
    super.operate();
    updateTexture();
    updateModel();
    writeToBuffer();
    
    int in = ins[0].flowId;
    int out = outs[0].flowId;
    int w = stack.get(in).dataWidth;
    int h = stack.get(in).dataHeight;
    
    buffer.loadPixels();
    for (int i = 0; i < w; i++){
      for (int j = 0; j < h; j++){
        stack.get(out).data[i+j*w] = buffer.pixels[i+j*w] & 0xFF;
      }
    }
    buffer.updatePixels();
    super.lookDown();
  }
  
  //this method positions the model, then draws it in a PGraphics object. The operate()
  //method then reads the values of the PGraphics object into the output data array
  
  void writeToBuffer(){   
    //model.translate(-125, -125, -125);    
    //model.scale(cp5.getController("zoom"+str(id)).getValue());
    //model.rotateX(cp5.getController("cameraX"+str(id)).getValue());
    //model.rotateY(cp5.getController("cameraY"+str(id)).getValue());
    //model.rotate(cp5.getController("cameraZ"+str(id)).getValue(), 0, 0, 1);   
    //x = r * cos(s) * sin(t)
    //y = r * sin(s) * sin(t)
    //z = r * cos(t)
    
    float zoom = cp5.getController("zoom"+str(id)).getValue();
    float yaw = cp5.getController("cameraYaw"+str(id)).getValue();
    float pitch = cp5.getController("cameraPitch"+str(id)).getValue();
    float pan = cp5.getController("cameraPan"+str(id)).getValue();
    float camHeight = cp5.getController("cameraHeight"+str(id)).getValue();
    
    float x = zoom*cos(pitch)*sin(yaw);
    float y = zoom*sin(pitch)*sin(yaw);
    float z = zoom*cos(yaw);
    PVector cross = new PVector(x, y, z).cross(new PVector(0, 0, 0));
    
    //buffer.clear();
   // buffer = createGraphics(250, 250, P3D);
    buffer.beginDraw();
    buffer.camera(x, y-pan, z+camHeight, 0, -pan, 125+camHeight, 0, 0, -1);
    buffer.lights();
    buffer.background(0);
    buffer.shape(model, -125, -125);   
    buffer.endDraw();
    //buffer.printCamera();
  }  
}
