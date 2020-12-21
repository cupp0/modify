/*

main class that extends to all the bits of UI that comprise the patch 
(NoiseGenerators, functions, displays, modifiers).

headsUp(), lookDown(), and operate() are responsible for all the routing.
Changes in the UI call headsUp() inside the Module, which recurs down
the patch, signalling to the modules below that they are receiving new data

Once headsUp() is done (this is done at the end of the frame, I think cp5 
does stuff after draw()), the patch is primed. Before a display module is
displayed, it will check if it is expecting new data. If no, it displays the
image it has stored. Otherwise, it tells the module above it to operate().

Operate() recurs upward in correspondence with headsUp(). If a module has 
inputs that are expecting new data, operate() on the module above, etc.
Eventually we reach an unchanged module or a generator (Module with no
data input). Then we work our way back down the patch, updating the data
stack as we travel.

After operate() has completed within a module, that module calls lookDown(),
which will tell every input that receives its output that it is done 
operating.

TODO MAYBE :

collapse() (for the big modules), select() (for grouping and drag()ing 
multiple modules), 

*/

public abstract class Module{

  InputNode[] ins;
  OutputNode[] outs;  
  ModInput[] modIns;
  ModOutput[] modOuts;
  GrabberNode grabber;
  
  String name;
  int id;
  PVector pos;
  PVector size;
  color c;
  boolean moving = false;
  boolean active = true;
  PImage img;
  PShape model;
  
  //at what point do we decide to extend module further before concrete classes?
  boolean isModifier = false;
  boolean isDisplay = false;
  boolean isFeedback = false;
  boolean loopDone = false;
  
  Module(){    
    id = modules.size(); 
    pos = new PVector(random(100)+300, random(100)+300);
    ins = new InputNode[0];
    outs = new OutputNode[0];
    modIns = new ModInput[0];
    modOuts = new ModOutput[0];
    cp5.addGroup("g"+str(id))
      .setPosition(pos.x, pos.y)
      .hideBar()
      ;    
  }
  
  void display(){
    fill(c);
    strokeWeight(1);
    text(name, pos.x+6, pos.y-3);
    if (moving){
      drag(new PVector(mouseX-pmouseX, mouseY-pmouseY));
    }
    rect(pos.x, pos.y, size.x, size.y);
    grabber.display();
    for (InputNode n : ins){
      n.display();
    }
    for (OutputNode n : outs){
      n.display();
    }
    for (ModInput n : modIns){
      n.display();
    }
    for (ModOutput n : modOuts){
      n.display();
    }    
  }
  
  //If InputNode.lookUp, there is a module above it that needs to operate before
  //this module can operate. So we travel up the patch until !InputNode.lookUp.
  //Then, we perform the operation and set lookUp false for everything that's in
  //OutputNode.receivers, making sure that A) all operations are performed in an 
  //orderly fashion, and B) no operations are performed twice in a loop.
  
  void operate(){
    for (InputNode n : ins){
      if (n.lookUp){
        if (modules.get((int)n.sender.x).allSystemsGo()){
          if(modules.get((int)n.sender.x).isFeedback && (int)n.sender.y == 1){
          } else {
            modules.get((int)n.sender.x).operate();
          }
        }
      }
    }
  }
  
  //this is called any time UI in a module changes in a way that changes its output.
  //It looks down the patch and makes sure every input implicated by it has 
  //lookUp=true. After all UI modulators are handled and the patch is primed, 
  //we call operate() inside each display. Also handles some feedback logic.
  
  void headsUp(){
    for (OutputNode n : outs){
      for (PVector p : n.receivers){
        modules.get((int)p.x).ins[(int)p.y].lookUp = true;
      }      
    }
    for (OutputNode n : outs){
      for (PVector p : n.receivers){
        if (!modules.get((int)p.x).isDisplay && !(modules.get((int)p.x).isFeedback && (int)p.y == 1)){
          modules.get((int)p.x).headsUp();
        }
      }      
    }
    for (ModOutput n : modOuts){
      for (PVector p : n.receivers){
        modules.get((int)p.x).modIns[(int)p.y].lookUp = true;
      }      
    }
    for (ModOutput n : modOuts){
      for (PVector p : n.receivers){
        modules.get((int)p.x).headsUp();
      }      
    }
  }
  
  
  //used to make sure every input beneath it is ready to operate().
  //have to make sure we don't set a display ins lookUp false prematurely.
  void lookDown(){
    for (OutputNode n : outs){
      for (PVector p : n.receivers){
        if (!modules.get((int)p.x).isDisplay){
          modules.get((int)p.x).ins[(int)p.y].lookUp = false;
        }
      }
    }
    for (ModOutput n : modOuts){
      for (PVector p : n.receivers){
        modules.get((int)p.x).modIns[(int)p.y].lookUp = false;
      }
    }
  }
  
  void drag(PVector dragAmount){
    pos.add(dragAmount);
    grabber.drag(dragAmount);
    for (OutputNode n : outs){
      n.drag(dragAmount);
    }
    for (InputNode n : ins){
      n.drag(dragAmount);
    }
    for (ModOutput n : modOuts){
      n.drag(dragAmount);
    }
    for (ModInput n : modIns){
      n.drag(dragAmount);
    }
    cp5.getGroup("g"+str(id)).setPosition(pos.x, pos.y);
  }
  
  //this method is only called in NoiseGenerators and recursively, here. It ~ should ~
  //result in all connected Flows being resized and recalculated, top down.
  //currently not all stack entries getting resized properly. 
  
  void changeDataDimensions(int w, int h){
    //if (!isFeedback){
    //  for (OutputNode n : outs){
    //    stack.get(n.flowId).dataWidth = w;
    //    stack.get(n.flowId).dataHeight = h;
    //    stack.get(n.flowId).data = new float[w*h];
    //    for (PVector p : n.receivers){
    //      modules.get((int)p.x).changeDataDimensions(w, h);
    //    }
    //  }
    //}
  }
  
  //checks that every connection needed to operate() is made
  
  boolean allSystemsGo(){
    for (OutputNode n : outs){
      if (n.flowId == 0){
        return false;
      }
    }
    for (InputNode n : ins){
      if (n.flowId == 0){
        return false;
      }
    }
    return true;
  }
  
  void feedbackPrimer(){
  }
  
  void sendModValue(){
  }
  
  //we should write a general cp5Handler. Would need each module to have a String[] 
  //controllerNames that stores the names of all the cp5 that takes a ModInput.
  
  void cp5Handler(){
  }
  
  // Remove connections, remove cp5, and set active = false. Missing anything?
  void deleteModule(){
    for (InputNode n : ins){
      if (n.flowId >= 1){
        modules.get((int)n.sender.x).outs[(int)n.sender.y].removeReceiver(n.id); 
      }
    }
    for (OutputNode n : outs){
      n.clearReceivers();          
    }
    for (ModInput n : modIns){
      if (n.sender != null){
        modules.get((int)n.sender.x).modOuts[(int)n.sender.y].removeReceiver(n.id); 
      }
    }
    for (ModOutput n : modOuts){
      n.clearReceivers();    
    }
    cp5.getGroup("g"+str(id)).remove();
    active = false;
  }  
}
