/*

video synthesizer

TODO:

- extend Module to abstract Generator, abstract Function, abstract Modifier
each of these are unique enough to warrant multiple extension.

- how de we want to implement feedback loops. The behavior we want is for any output
to be eligible to connect with any input, and that each module operates only once per frame.
We need a way to direct traffic at feedback loop crossing points. How can we do this?

- Delete connections one at a time. in OutputNode, check if each line is hovered in display.
piggyback that with if(keyPressed){if(key == 'd' receivers. buggy thing where hovering a 
connection removes it 

bugs : 
-not everything is resizing when we change dimensions in generators. unsure why
-sometimes just hovering connections deletes them? something to do with image module
-sometimes modOutput removeReceiver doesn't work.
-

Modules TODO

  GATE 
  IMAGE
  SAMPLER - modifier that takes Flow input and outputs a modifier
  BOUNDARY - is a more robust edge finder necessary? I think not.
  MATH - one generator and one that combines two inputs via function
  (does all the work plus, mult, average, comparison, invert, etc did)
  ALGORITHM - define an algorithm based on pixel relations, two input
  (one is the data being alg'd, the other is the mask for the alg)
  DISPLAY - how do we want to do color? have RGB overwrite channels?
  MASK
  SUBSECTION 
  REDUX
  QUANTIZE
  TEXT
  SHAPEFINDER
  SOUNDIN


~ ~ ~ potentially useful libraries ~ ~ ~

Beads, Sound, minim - for audio
BlobDetection - vector based, maybe a bit heavy for our purposes? But maybe there's
room for some vector based stuff here. If we go that way, Computational Geometry, 
Extruder, good for 3D.



*/

//library for sliders and buttons and such
import controlP5.*;

ControlP5 cp5;
OpenSimplexNoise noise;

String[] genStrings = {"math", "noise", "image", "draw", "text"};
String[] funcStrings = {"compare", "combine", "gate", "boundary", "algorithm", "mask", "subsection", "util", "redux", "quantize", "blob"};
String[] modStrings = {"basicMod", "sampler", "audio"};
String[] outStrings = {"display", "record"};

String[] built = {"noise", "gate", "basicMod", "display", "compare", "image", "math", "combine", "boundary", "sampler", "mask", "util"};

Button[] genButtons = new Button[genStrings.length];
Button[] funcButtons = new Button[funcStrings.length];
Button[] modButtons = new Button[modStrings.length];
Button[] outButtons = new Button[outStrings.length];

Accordion acc;
Group mainMenu;

//list of UI objects for building patches
ArrayList<Module> modules = new ArrayList<Module>();

//list of data that is manipulated in order to generate displays
ArrayList<Flow> stack = new ArrayList<Flow>();

//add to this each time a module that uses noise is added. Each of these
//modules has a textfield you can use to sync seeds with other modules
ArrayList<Float> seeds = new ArrayList<Float>();

//stores an OutputNode.id when we click it. Used to build a connection when we click 
//an InputNode
PVector cue;

//used to observe how many times modules operate every loop through draw
int operationCount;

void setup(){
  size(800, 800, P2D);
  frameRate(24);
  noise = new OpenSimplexNoise();
  gui();
}

void draw(){
  //operationCount = 0;
  background(100);
  if (mainMenu.isOpen()){
    drawLabels();
  }
  for (Module m : modules){
    if(m.active){
      if (m.isModifier && m.allSystemsGo()){
        m.sendModValue();
      }
      m.display();
    }
  }
  if (cue != null){
    if (cue.z == -1){
      line(modules.get((int)cue.x).modOuts[(int)cue.y].pos.x, modules.get((int)cue.x).modOuts[(int)cue.y].pos.y, mouseX, mouseY);
    } else {
      line(modules.get((int)cue.x).outs[(int)cue.y].pos.x, modules.get((int)cue.x).outs[(int)cue.y].pos.y, mouseX, mouseY);
    }
  }
  textSize(12);
  fill(255);
  text((int)frameRate, 776, 18);
}

void gui(){
  
  cp5 = new ControlP5(this);
 
  mainMenu = cp5.addGroup("mainMenu")
    .setPosition(10, 100)
    ; 
    
  for (int i = 0; i < genStrings.length; i++){
    cp5.addButton(genStrings[i])
     .setPosition(0, 40+i*20)
     .setSize(10, 10)
     .setLabel("")
     .moveTo(mainMenu)
     ; 
     for (String b : built){
       if (genStrings[i].equals(b)){
         cp5.getController(genStrings[i]).setColorBackground(color(150, 100, 200));
       }
     }
  }
  
  for (int i = 0; i < funcStrings.length; i++){
    cp5.addButton(funcStrings[i])
     .setPosition(75, 40+i*20)
     .setSize(10, 10)
     .setLabel("")
     .moveTo(mainMenu)
     ; 
     for (String b : built){
       if (funcStrings[i].equals(b)){
         cp5.getController(funcStrings[i]).setColorBackground(color(150, 100, 200));
       }
     }
  }
  
  for (int i = 0; i < modStrings.length; i++){
    cp5.addButton(modStrings[i])
     .setPosition(150, 40+i*20)
     .setSize(10, 10)
     .setLabel("")
     .moveTo(mainMenu)
     ; 
     for (String b : built){
       if (modStrings[i].equals(b)){
         cp5.getController(modStrings[i]).setColorBackground(color(150, 100, 200));
       }
     }
  }
  
  for (int i = 0; i < outStrings.length; i++){
    cp5.addButton(outStrings[i])
     .setPosition(225, 40+i*20)
     .setSize(10, 10)
     .setLabel("")
     .moveTo(mainMenu)
     ; 
     for (String b : built){
       if (outStrings[i].equals(b)){
         cp5.getController(outStrings[i]).setColorBackground(color(150, 100, 200));
       }
     }
  }
       
   acc = cp5.addAccordion("acc")
     .setPosition(10, 10)
     .setWidth(100)
     .addItem(mainMenu)
     ;
     
}

void keyPressed(){
  if (key == 'd'){
    for (Module m : modules){
      if (m.active){
        if (m.grabber.mouseOver){
          m.deleteModule();
        }
        for (OutputNode n : m.outs){
          for (int i = n.receivers.size() - 1; i >= 0; i--){
            if (connectionHovered(n.pos, modules.get((int)n.receivers.get(i).x).ins[(int)n.receivers.get(i).y].pos, new PVector(mouseX, mouseY))){
              n.removeReceiver(n.receivers.get(i));
            }
          }
        }
        for (ModOutput n : m.modOuts){
          for (int i = n.receivers.size() - 1; i >= 0; i--){
            if (connectionHovered(n.pos, modules.get((int)n.receivers.get(i).x).modIns[(int)n.receivers.get(i).y].pos, new PVector(mouseX, mouseY))){
              n.removeReceiver(n.receivers.get(i));
            }
          }
        }
      }
    }
  }
}

void mousePressed(){ 
  for (Module m : modules){
    if (m.active){
      if (m.grabber.mouseOver){
        m.grabber.onMousePressed();
        return;
      }
      for (InputNode n : m.ins){
        if (n.mouseOver){
          n.onMousePressed();
          return;
        }
      }
      for (OutputNode n : m.outs){
        if (n.mouseOver){
          n.onMousePressed();
          return;
        }    
      }
      for (ModInput n : m.modIns){
        if (n.mouseOver){
          n.onMousePressed();
          return;
        }  
      }
      if (m.isModifier){
        for (ModOutput n : m.modOuts){
          if (n.mouseOver){
            n.onMousePressed();
            return;
          } 
        }
      }
    }
  }
}

void mouseReleased(){
  for (Module m : modules){
    if (m.moving){
      m.moving = false;
    }
    for (ModInput n : m.modIns){
      if (n.pauseInput){
        n.pauseInput = false;
      }
    }
  }
}

void drawLabels(){
  fill(255);
  text("generators", 10, 40);
  text("functions", 85, 40);
  text("modifiers", 160, 40);
  text("output", 235, 40);
  for (int i = 0; i < genStrings.length; i++){
    text(genStrings[i], 22, 69+20*i);
  }
  for (int i = 0; i < funcStrings.length; i++){
    text(funcStrings[i], 97, 69+20*i);
  }
  for (int i = 0; i < modStrings.length; i++){
    text(modStrings[i], 172, 69+20*i);
  }
  for (int i = 0; i < outStrings.length; i++){
    text(outStrings[i], 247, 69+20*i);
  }
}

//This class manages the data. Every active output/input points to some Flow
//in stack. operations are handled in Modules, not sure this class is necessary.
class Flow{
  
  int dataWidth = 250;
  int dataHeight = 250;
  float[] data;
  
  Flow(){
    data = new float[dataWidth*dataHeight];
  }
   
}


void controlEvent(ControlEvent theEvent) {
  
  //radiobutton can't plugTo(), as plugTo is a Controller method, and 
  //radioButton is a Group. thus, we must use the name of the group
  //to point to the correct module and call the oppropriate method here.
  
  //also worth noting that building a new Module that has radioButtons
  //will throw an indexOutOfBounds, as the creation of the radioButton
  //will call this method, and the module will attempt to operate
  //before it has been added to the stack of modules
  if (theEvent.isGroup()){
    if (theEvent.getName().substring(0, 7).equals("modType")){
      modules.get(int(theEvent.name().substring(7))).operate();
    }
    if (theEvent.getName().substring(0, 9).equals("noiseMode")){
      modules.get(int(theEvent.name().substring(9))).headsUp();
    }
    if (theEvent.getName().substring(0, 11).equals("comparisons")){
      modules.get(int(theEvent.name().substring(11))).headsUp();
    } 
  }

  switch(theEvent.getController().getName()){
  case "noise" :
    modules.add(new NoiseGenerator());
    break;
  case "display" :
    modules.add(new Displayer());
    break;
  case "basicMod" :
    modules.add(new Modifier());
    break;  
  case "gate" :
    modules.add(new Gate());
    break;  
  case "compare" :
    modules.add(new Compare());
    break; 
  case "image" :
    modules.add(new Image());
    break;
  case "math" :
    modules.add(new Math());
    break; 
  case "combine" :
    modules.add(new Combine());
    break; 
  case "boundary" :
    modules.add(new Boundary());
    break;
  case "sampler" :
    modules.add(new Sampler());
    break;
  case "mask" :
    modules.add(new Mask());
    break;
  case "util" :
    modules.add(new Util());
    break;     
  }
}
