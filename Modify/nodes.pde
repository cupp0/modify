
public abstract class Node{
  
  int flowId = 0;
  PVector id;
  PVector pos;
  int size = 4; 
  color c;
  boolean mouseOver = false;
  
  //id - module, #, input/output
  Node(PVector id_, PVector pos_){
    id = id_.copy();
    pos = pos_.copy();
  }
  
  public void display(){
    fill(c);
    stroke(0);
    if (isInside(new PVector(mouseX, mouseY), new PVector(pos.x+3, pos.y+3), new PVector(3, 3))){
      mouseOver = true;
      strokeWeight(3);
    } else {
      mouseOver = false;
      strokeWeight(1);
    }
    rect(pos.x, pos.y, size, size);
    //text(flowId, pos.x, pos.y);
  } 
  
  void onMousePressed(){
  }
  
  void drag(PVector dragAmount){
    pos.add(dragAmount);
  }
  
  
}

class InputNode extends Node{
  PVector sender;
  boolean lookUp;
    
  InputNode(PVector id_, PVector pos_){
    super(id_, pos_);  
    c = color(255);
  }
  
  void onMousePressed(){
    //only build connection if there is an output node cued, this node
    //doesn't already have a connection, the cue isn't from the same
    //module, and the node isn't a modulation node
    if (cue != null && flowId == 0 && cue.x != id.x && cue.z != -1){
      flowId = modules.get((int)cue.x).outs[(int)cue.y].flowId;
      sender = cue.copy();
      modules.get((int)cue.x).outs[(int)cue.y].addReceiver(id);
      if (modules.get((int)id.x).isModifier){
        lookUp = true;
        modules.get((int)cue.x).operate();
      }
      cue = null;
    }
  }
  
}

class OutputNode extends Node{
  
  ArrayList<PVector> receivers = new ArrayList<PVector>();
  
  OutputNode(PVector id_, PVector pos_){
    super(id_, pos_);
    c = color(255);
    stack.add(new Flow());
    flowId = stack.size()-1;
  }
  
  //out of convenience, we often piggyback display() to check for interaction. 
  //Is there a way to handle interactivity without calling an additional
  //method on every outputNode every frame? Seems wasteful not to do it here.
  void display(){
    super.display();    
    //OutputNode is responsible for drawing all connections here
    for (int i = 0; i < receivers.size(); i++){
      PVector p = receivers.get(i).copy();
      if (connectionHovered(pos, modules.get((int)p.x).ins[(int)p.y].pos, new PVector(mouseX, mouseY))){
        strokeWeight(2);  
      } else {
        strokeWeight(1);
      }
      line(pos.x, pos.y, modules.get((int)p.x).ins[(int)p.y].pos.x, modules.get((int)p.x).ins[(int)p.y].pos.y);
    }   
  }
  
  void onMousePressed(){
    //cue is held to build a connection once an input is pressed
    if (cue == null){
      cue = id.copy();
    }
  }
  
  //outputNode is responsible for making dimensions congruent. silliness
  void addReceiver(PVector nodeId){
    //check list to see if it's a duplicate
    boolean duplicate = false;
    for (PVector p : receivers){
      if (p.x == nodeId.x && p.y == nodeId.y){
        duplicate = true;
      }
    }
    if (!duplicate){
      int w = stack.get(flowId).dataWidth;
      int h = stack.get(flowId).dataHeight;
      receivers.add(nodeId);
      modules.get((int)nodeId.x).changeDataDimensions(w, h);
      modules.get((int)id.x).headsUp();
    }
  }
  
  void removeReceiver(PVector nodeId){
    modules.get((int)nodeId.x).ins[(int)nodeId.y].flowId = 0;
    receivers.remove(receivers.indexOf(nodeId));
  }
  
  void clearReceivers(){
    for (int i = receivers.size()-1; i >= 0; i--){
      modules.get((int)receivers.get(i).x).ins[(int)receivers.get(i).y].flowId = 0;
      receivers.remove(i);
    }
  }  
}

class ModOutput extends Node{
  
  float[] modData;
  ArrayList<PVector> receivers = new ArrayList<PVector>();
  
  ModOutput(PVector id_, PVector pos_){
    super(id_, pos_);  
    c = color(127);  
  }
  
  void display(){
    super.display();    
    for (PVector p : receivers){
      line(pos.x, pos.y, modules.get((int)p.x).modIns[(int)p.y].pos.x, modules.get((int)p.x).modIns[(int)p.y].pos.y);
    }
    for (int i = 0; i < receivers.size(); i++){
      PVector p = receivers.get(i).copy();
      if (connectionHovered(pos, modules.get((int)p.x).modIns[(int)p.y].pos, new PVector(mouseX, mouseY))){
        //if (keyPressed && key == 'd'){
        //  receivers.remove(i);
        //}
        strokeWeight(2);  
      } else {
        strokeWeight(1);
      }
      line(pos.x, pos.y, modules.get((int)p.x).modIns[(int)p.y].pos.x, modules.get((int)p.x).modIns[(int)p.y].pos.y);
    } 
  }
  
  void onMousePressed(){
    //cue is held to build a connection once an input is pressed
    if (cue == null){
      cue = id.copy();
    }
  }
  
  void addReceiver(PVector nodeId){
    //check list to see if it's a duplicate
    boolean duplicate = false;
    for (PVector p : receivers){
      if (p.x == nodeId.x && p.y == nodeId.y){
        duplicate = true;
      }
    }
    if (!duplicate){
      receivers.add(nodeId);
    }
  }
  
  //why does this sometimes return -1?
  void removeReceiver(PVector nodeId){
    if (receivers.indexOf(nodeId) >= 0){
      receivers.remove(receivers.indexOf(nodeId));
    }
  }
  
  void clearReceivers(){
    for (int i = receivers.size()-1; i >= 0; i--){
      receivers.remove(i);
    }
  } 
}

class ModInput extends Node{
  
  PVector sender;
  boolean lookUp;
  float baseVal;
  float min;
  float max;
  String controllerName;
  boolean pauseInput = false;
  
  ModInput(PVector id_, PVector pos_, String name){
    super(id_, pos_);  
    c = color(127);
    controllerName = name;
    min = cp5.getController(name).getMin();
    max = cp5.getController(name).getMax();
  }
  
  //only update slider values if the mouse isn't pressed. This way, we 
  //avoid the modifier setting the baseVal.
  void receiveModValue(float val){
    if (!pauseInput){
      val = map (val, 0, 1, min, max);
      cp5.getController(controllerName).setValue(baseVal+val);
    }
  }
  
  void onMousePressed(){
    if (cue != null && cue.z == -1){
      modules.get((int)cue.x).modOuts[(int)cue.y].addReceiver(id);
      sender = cue.copy();
      cue = null;
    }
  }
  
}

class FeedbackOut extends Node{
  
  boolean activeLoop = false;
  
  FeedbackOut(PVector id_, PVector pos_){
    super(id_, pos_);
    c = color(100, 100, 0);
  }
  
}

class FeedbackIn extends Node{
  
  boolean activeLoop = false;
  
  FeedbackIn(PVector id_, PVector pos_){
    super(id_, pos_); 
    c = color(100, 100, 0);
  }
  
}

class GrabberNode extends Node{
  
  GrabberNode(PVector id_, PVector pos_){
    super(id_, pos_); 
    c = color(0);
  }
  
  void onMousePressed(){
    modules.get((int)super.id.x).moving = true;
  }
  
  void onMouseReleased(){
    modules.get((int)super.id.x).moving = false;
  }
}
