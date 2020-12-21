/*

\\ video synthesizer //

Click the green triangle.

~  ~  ~  ~  ~

- You've dug a small hole with resizing Modules. Let's have a global control that can't
  be overwritten by Image or anything like that. And a local control on Image that 
  overwrites its own size but no others. That way we can keep nice textures. I'm actually
  not sure what's best here. 

- Blur module : implement user defined kernel. Controls should be exploratory but still
  give access to box and gaussian kernels
  
- composition modules need to be flexible and fast. Do we want a mask with multiple outputs?
. Would make coloring layered objects individually possible, for example. Here, we would
  overwrite allSystemsGo() to allow operate() in a few different routing states, and operate()
  itself would change based on routing.

- Draw module : once it is stable (Either understand PApplet or Draw in main), lots of 
  drawing utility to port/write. Glowy line, calligraphy is nice, maybe get into 
  vector stuff with the old node classes?

- 3D module :

  everything works (usually), just need to separate the processes. updateTexture() and
  updateModel() can happen apart from camera controls. Maybe overwrite allSystemsGo()
  to allow for 3D without texture. Might need booleans/extra methods within 3D to 
  distinguish a headUp() from the Model input from a headsUp() from the texture input.
  
  can we encode more useful information for the model with more inputs? Something that would 
  allow wrapping and twisting and all sort of other 3D shtuff. Maybe test how an xoffset input
  performs.
 
  Is our triangle mesh algorithm any good? Holey at some resolutions.

- be on the lookout for modules that don't normalize after operate()

bugs : 

Draw doesn't play well all the time, especially with 3D
see: https://discourse.processing.org/t/closing-a-second-window/381/14
Copy/Pasting from here seems to be a bandaid

- GLException: GL-Error 0x502 while creating mutable storage for target 0x8892 -> buffer 23 of size 64 with data java.nio.DirectFloatBufferU[pos=0 lim=16 cap=16]
Is there a clean way to Draw without a second window?
- OpenGL error 1282 at top endDraw(): invalid operation
- OpenGL error 1281 at top endDraw(): invalid value
Shader error? I think it messes with the PImage in DrawWindow but doesn't crash the
sketch

- Feedback should never push input through, even at first arrival. Also, feedback crashes
when its input is a feedback. revisit, make clean.

- combine output is surprising. sometimes pushes the floor up? Is the parser bad?

- resizing bad

Modules TODO

  ALGORITHM - define an algorithm based on pixel relations, two input
  (one is the data being alg'd, the other is the mask for the alg) 
  TRANSFORM - transclate, scale, rotate (cleanly this time!)
  TEXT - PGraphics.get() doesn't see text I guess? Maybe something similar to Draw.
  Make a textObject class, have a list of them, then use pixels[] in the PApplet
  SHAPEFINDER - rudimentary blob detection. Optimize for masks.

~ ~ ~ potentially useful libraries ~ ~ ~

Beads, Sound, minim - for audio if we want
BlobDetection - vector based, maybe a bit heavy for our purposes? But maybe there's
room for some vector based stuff here. If we go that way, Computational Geometry, 
Extruder, good for 3D.

*/
//library for sliders and buttons and such
import controlP5.*;
ControlP5 cp5;

OpenSimplexNoise noise;

String[] genStrings = {"constant", "math", "noise", "image", "text"};
String[] funcStrings = {"translate", "rotate", "subsection", "mathUtil", "gate", "boundary", "redux", "quantize", "blur", "static", "algorithm", "blob"};
String[] compStrings = {"blend", "compare", "combine", "mask", "3D"};
String[] modStrings = {"basicMod", "sampler", "audio"};
String[] utilStrings = {"feedback", "interval"};
String[] outStrings = {"display"};

String[] built = {"constant", "translate", "interval", "subsection", "image", "noise", "blur", "gate", "basicMod", "display", "compare", "math", "combine", "boundary", "sampler", "mask", "mathUtil", "redux", "quantize", "blend", "feedback", "rotate", "static", "3D"};

Button[] genButtons = new Button[genStrings.length];
Button[] funcButtons = new Button[funcStrings.length];
Button[] compButtons = new Button[modStrings.length];
Button[] modButtons = new Button[outStrings.length];
Button[] utilButtons = new Button[modStrings.length];
Button[] outButtons = new Button[outStrings.length];

Accordion mainAcc;
Accordion drawAcc;
Group mainMenu;
Group drawMenu;

//list of UI objects for building patches
ArrayList<Module> modules = new ArrayList<Module>();

//list of data that is manipulated in order to generate displays
ArrayList<Flow> stack = new ArrayList<Flow>();

//add to this each time a module that uses noise is added. Each of these
//modules has a textfield you can use to sync seeds with other modules
ArrayList<Float> seeds = new ArrayList<Float>();

//stores a Node.id when we click it. Used to build node connections.
PVector cue;

public void settings(){
  //PApplet extension for draw module does not like P2D.
  size(1050, 800, P2D);
}

void setup(){
  cp5 = new ControlP5(this);
  noise = new OpenSimplexNoise();
  gui();
  stroke(0);
  strokeWeight(1);
  
  // bottom of stack is all 0s. Nodes without a connection point to it.
  stack.add(new Flow());
  stack.get(0).blankFlow();  
}

void draw(){
  //println((get(mouseX, mouseY) >> 16) & 0xFF,(get(mouseX, mouseY) >> 8) & 0xFF, get(mouseX, mouseY) & 0xFF);
  drawUI();
  for (Module m : modules){
    //active just means it hasn't been deleted
    if(m.active){
      //feedback and modifier type modules have responsibilities every loop.
      if (m.isModifier && m.allSystemsGo()){
        m.sendModValue();
      }
      if (m.isFeedback){
        m.feedbackPrimer();
      }
      m.display();
    }
  }
  //temporary lines for when the user is building a connection
  if (cue != null){
    if (cue.z == -1){
      line(modules.get((int)cue.x).modOuts[(int)cue.y].pos.x, modules.get((int)cue.x).modOuts[(int)cue.y].pos.y, mouseX, mouseY);
    } else {
      line(modules.get((int)cue.x).outs[(int)cue.y].pos.x, modules.get((int)cue.x).outs[(int)cue.y].pos.y, mouseX, mouseY);
    }
  }
  stroke(0);
  strokeWeight(1);
  text((int)frameRate, 1026, 18);
}

void gui(){
  mainMenu = cp5.addGroup("mainMenu")
    .setPosition(10, 100)
    .disableCollapse()
    ; 
  drawMenu = cp5.addGroup("drawMenu")
    .setPosition(10, 350)
    .disableCollapse()
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
     .setPosition(80, 40+i*20)
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
  
  for (int i = 0; i < compStrings.length; i++){
    cp5.addButton(compStrings[i])
     .setPosition(0, 175+i*20)
     .setSize(10, 10)
     .setLabel("")
     .moveTo(mainMenu)
     ; 
     for (String b : built){
       if (compStrings[i].equals(b)){
         cp5.getController(compStrings[i]).setColorBackground(color(150, 100, 200));
       }
     }
  }
  
  for (int i = 0; i < modStrings.length; i++){
    cp5.addButton(modStrings[i])
     .setPosition(160, 40+i*20)
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
  
  for (int i = 0; i < utilStrings.length; i++){
    cp5.addButton(utilStrings[i])
     .setPosition(160, 140+i*20)
     .setSize(10, 10)
     .setLabel("")
     .moveTo(mainMenu)
     ; 
     for (String b : built){
       if (utilStrings[i].equals(b)){
         cp5.getController(utilStrings[i]).setColorBackground(color(150, 100, 200));
       }
     }
  }
  
  for (int i = 0; i < outStrings.length; i++){
    cp5.addButton(outStrings[i])
     .setPosition(160, 215+i*20)
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
  
  cp5.addRadioButton("drawMode")
     .setPosition(0, 10)
     .addItem("freeDraw", 0)
     .addItem("line", 1)
     .addItem("polygon", 2)
     .addItem("curve", 3)
     .addItem("ellipse", 4)
     .activate(0)
     .moveTo(drawMenu)
     ;
      
   cp5.addButton("sendIt")
     .setLabel("build")
     .setPosition(0, 150)
     .plugTo(this, "sendIt")
     .moveTo(drawMenu)
     ;  
    
   cp5.addSlider("color")
     .setPosition(0, 65)
     .setRange(0, 255)
     .setValue(255)
     .moveTo(drawMenu)
     ;  
      
   cp5.addSlider("faces")
     .setPosition(0, 77)
     .setRange(3, 30)
     .setValue(5)
     .moveTo(drawMenu)
     ; 
     
   cp5.addSlider("strokeWeight")
     .setPosition(0, 89)
     .setRange(1, 30)
     .setValue(5)
     .moveTo(drawMenu)
     ;    
      
   cp5.addButton("fill")
     .setPosition(0, 105)
     .setSize(15, 15)
     .plugTo(this, "flickFill")
     .moveTo(drawMenu)
     ;
      
   cp5.addButton("close")
     .setPosition(0, 125)
     .setSize(15, 15)
     .plugTo(this, "flickClose")
     .moveTo(drawMenu)
     ;     
       
   mainAcc = cp5.addAccordion("mainAcc")
     .setPosition(10, 10)
     .setWidth(100)
     .addItem(mainMenu)
     .disableCollapse()
     ;
     
   drawAcc = cp5.addAccordion("drawAcc")
     .setPosition(10, 350)
     .setWidth(100)
     .addItem(drawMenu)
     .disableCollapse()
     ;  
     
   mainMenu.setOpen(true);  
   drawMenu.setOpen(true);    
   
   drawCanvas.loadPixels();
   for (int i = 0; i < drawCanvas.pixels.length; i++){
     drawCanvas.pixels[i] = color(0);
   }
   drawCanvas.updatePixels();
}

void keyPressed(){
  //delete stuff
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

//is there a cleaner way to handle interaction?

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
  //check if we're in the draw window
  if (mouseX < 250 && mouseY > 550){
    drawMousePressed();
  }
}

void mouseDragged(){
  //check if we're in the draw window
  if (mouseX < 250 && mouseY > 550){
    drawMouseDragged();
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
  //check if we're in the draw window
  if (mouseX < 250 && mouseY > 550){
    drawMouseReleased();
  }
}

void drawUI(){ 
  background(150);
  fill(75);
  rect(-1, -1, 252, 551);
  strokeWeight(4);
  stroke(0, 45, 90);
  line(-1, 325, 250, 325);
  line(-1, 548, 250, 548); 
  line(252, -1, 252, 801);
  
  fill(255);
  text("generate", 10, 50);
  for (int i = 0; i < genStrings.length; i++){
    text(genStrings[i], 22, 69+20*i);
  }
  text("compose", 10, 185);
  for (int i = 0; i < compStrings.length; i++){
    text(compStrings[i], 22, 205+20*i);
  }
  text("affect", 90, 50); 
  for (int i = 0; i < funcStrings.length; i++){
    text(funcStrings[i], 102, 69+20*i);
  }
  text("modulate", 170, 50);
  for (int i = 0; i < modStrings.length; i++){
    text(modStrings[i], 183, 69+20*i);
  }
  text("utility", 170, 150);
  for (int i = 0; i < utilStrings.length; i++){
    text(utilStrings[i], 183, 170+20*i);
  }
  text("output", 170, 230);
  for (int i = 0; i < outStrings.length; i++){
    text(outStrings[i], 183, 244+20*i);
  } 
  
  image(drawCanvas, 0, 550);
  for (PShape p : temporaryShapes){
    shape(p, 0, 0);
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
  
  void blankFlow(){
    for (int i = 0; i < dataWidth; i++){
      for (int j = 0; j < dataHeight; j++){
        data[i+j*dataWidth] = 0;
      }
    }
  }
   
}


void controlEvent(ControlEvent theEvent) {
  
  //radiobutton can't plugTo(), as plugTo is a Controller method, and 
  //radioButton is a Group. thus, we must use the name of the group
  //to point to the correct module and call the oppropriate method here.
  //this is why controllers have str(id) pinned to the end of their name
  
  //also worth noting that building a new Module that has radioButtons
  //will throw an indexOutOfBounds, as the creation of the radioButton
  //will call this method, and the module will attempt to operate
  //before it has been added to the ArrayList modules
  
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
  case "constant" :
    modules.add(new Constant());
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
  case "mathUtil" :
    modules.add(new Util());
    break;  
  case "redux" :
    modules.add(new Redux());
    break; 
  case "quantize" :
    modules.add(new Quantize());
    break;  
  case "blend" :
    modules.add(new Blend());
    break;
  case "feedback" :
    modules.add(new Feedback());
    break;
  case "rotate" :
    modules.add(new Rotate());
    break; 
  case "static" :
    modules.add(new CheapStatic());
    break;
  case "3D" :
    modules.add(new threeD());
    break;  
  case "subsection" :
    modules.add(new Subsection());
    break;
  case "blur" :
    modules.add(new Blur());
    break;
  case "interval" :
    modules.add(new Interval());
    break;
  case "translate" :
    modules.add(new Translate());
    break;   
  }
}
