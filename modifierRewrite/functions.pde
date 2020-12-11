class Compare extends Module{
  
  boolean maskMode = true;
  
  Compare(){
    super();
    name = "compare";
    size = new PVector(74, 58);
    c = color(100, 150, 200);

    float[] arr = {1, 0, 0};
    cp5.addRadioButton("comparisons"+str(id))
      .setPosition(3, 10)
      .addItem("="+str(id), 0)
      .addItem("<"+str(id), 1)
      .addItem(">"+str(id), 2)
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
    c = color(100, 150, 200);
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
    size = new PVector(74, 56);
    c = color(100, 150, 200);
    name = "mask";
    cp5.addSlider("target"+str(id))
      .setLabel("")
      .setPosition(3, 30)
      .setWidth(64)
      .setHeight(10)
      .setRange(0, 255)
      .setValue(10)
      .plugTo(this, "cp5Handler")
      .setGroup("g"+str(id))      
      ;  
      
    cp5.addSlider("range"+str(id))
      .setLabel("")
      .setPosition(3, 42)
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
     modIns[0] = new ModInput(new PVector(id, 0, -1), new PVector(pos.x+size.x-4, pos.y+45), "target"+str(id));  
     modIns[1] = new ModInput(new PVector(id, 1, -1), new PVector(pos.x+size.x-4, pos.y+45), "range"+str(id));  
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
    size = new PVector(72, 44);
    c = color(100, 150, 200);
    name = "combine";
    cp5.addTextfield("mathUtilText"+str(id))
      .setLabel("")     
      .setPosition(5, 6)
      .setSize(50, 12)
      .setColor(color(255,0,0))
      .show()
      .setText(expString)
      .setGroup("g"+str(id))
      ;
      
    cp5.addButton("evaluate"+str(id))
      .setLabel("")
      .setPosition(5, 19)
      .setSize(10, 10)
      .plugTo(this, "updateString")
      .setGroup("g"+str(id))
      ; 
      
    cp5.addSlider("multiplier"+str(id))
      .setLabel("")
      .setPosition(5, 30)
      .setWidth(64)
      .setHeight(10)
      .setRange(0, 25)
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
    c = color(100, 150, 200);
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
  
  void headsUp(){
    super.headsUp();
  }
}

class Boundary extends Module{
    
  Boundary(){
    super();
    size = new PVector(111, 36);
    c = color(100, 150, 200);
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
    cp5.addSlider("differenceTolerance"+str(id))
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
    modIns[1] = new ModInput(new PVector(id, 1, -1), new PVector(pos.x+size.x-4, pos.y+22), "differenceTolerance"+str(id));

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
    if (cp5.getController("differenceTolerance"+str(id)).isMousePressed()){
      if (!modIns[1].pauseInput){
        modIns[1].baseVal = val;
        modIns[1].pauseInput = true;
      }
    }
    super.headsUp();
  }
  
  //fine for now, but a cheaper way to make thick boundaries would be nice
  void operate(){
    super.operate();
    int in = ins[0].flowId;
    int out = outs[0].flowId;
    int w = stack.get(in).dataWidth;
    int h = stack.get(in).dataHeight;
    int thresh = (int)cp5.getController("differenceThresh"+str(id)).getValue();
    int tol = (int)cp5.getController("differenceTolerance"+str(id)).getValue();
  
    for (int i = 0; i < w; i++){
      for (int j = 0; j < h; j++){
        for (int x = 0; x <= tol; x++){
          for (int y = 0; y <= tol; y++){
            if (abs(stack.get(in).data[i+j*w]-stack.get(in).data[constrain((i+x)+(j+y)*w, 0, w*h-1)]) > thresh){
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
