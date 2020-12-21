//Maybe bad to piggyback off Module here, but also maybe fine? Main point of interest
//is that we don't headsUp() whenever we change cp5. This is because all
//operate() does is change cp5 in other modules. So we just call operate() directly
//and modules that handle data down the line will handle headsUp().

//Modifiers would be better of doing one calculation at a time and continuously
//drawing over the envelope PImage
class Modifier extends Module{
  
  int sampleLength;
  float amplitude;
  PVector trackerPosition = new PVector(0, 25);
  PImage env;
    
  Modifier(){
    super();
    size = new PVector(100, 83);
    c = color(250, 100, 0);
    name = "modifier";
    isModifier = true;
    seeds.add(random(1000)); 
      
    float[] arr = {1, 0, 0, 0};
    cp5.addRadioButton("modType"+str(id))
      .setPosition(3, 4)
      .addItem("sin"+str(id), 0)
      .addItem("square"+str(id), 1)
      .addItem("saw"+str(id), 2)
      .addItem("tri"+str(id), 3)
      .addItem("noise"+str(id), 4)
      .addItem("random"+str(id), 5)
      .setGroup("g"+str(id))
      .setArrayValue(arr);
      ;
      
    cp5.addTextfield("modNoiseSeed"+str(id))
      .setLabel("") 
      .setText(str(seeds.size()-1))
      .setPosition(3, 67)
      .setSize(15, 10)
      .setColor(color(255,0,0))
      .show()
      .setGroup("g"+str(id))
      ;    
      
    cp5.addSlider("amp"+str(id))
      .setLabel("")
      .setPosition(63, 3)
      .setWidth(10)
      .setHeight(74)
      .setRange(.001, 1)
      .setValue(.1)
      .setLabelVisible(false)
      .plugTo(this, "operate")
      .setGroup("g"+str(id))
      ;
      
    cp5.addSlider("dur"+str(id))
      .setLabel("")
      .setPosition(75, 3)
      .setWidth(10)
      .setHeight(74)
      .setRange(1, 1000)
      .setValue(50)
      .setLabelVisible(false)
      .plugTo(this, "operate")
      .setGroup("g"+str(id))
      ;
      
    cp5.addSlider("phase"+str(id))
      .setLabel("")
      .setPosition(87, 3)
      .setWidth(10)
      .setHeight(74)
      .setRange(0, 1)
      .setValue(0)
      .setLabelVisible(false)
      .plugTo(this, "operate")
      .setGroup("g"+str(id))
      ; 
      
    cp5.addButton("invertMod"+str(id))
      .setLabel("inv")
      .setPosition(26, 67)
      .setSize(10, 10)
      .plugTo(this, "invertEnv")
      .setGroup("g"+str(id))
      ; 
      
    cp5.addButton("reverseMod"+str(id))
      .setLabel("rev")
      .setPosition(45, 67)
      .setSize(10, 10)
      .plugTo(this, "reverseEnv")
      .setGroup("g"+str(id))
      ;   
        
    grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2, pos.y));
    modOuts = new ModOutput[1];    
    modOuts[0] = new ModOutput(new PVector(id, 0, -1), new PVector(pos.x, pos.y+size.y-4));
      
    env = createImage(100, 50, RGB);  
    operate();  
  }
  
  void display(){
    super.display();
    trackOutput();
    image(env, pos.x, pos.y+size.y);
  }
  
  //change env PImage to reflect where we are in the modifier envelope
  void trackOutput(){
    float prev = (float)((frameCount-1)%sampleLength)/sampleLength;
    float percent = (float)(frameCount%sampleLength)/sampleLength;
    env.loadPixels();
    for (int i = -1; i <= 1; i++){
      if (i == 0){
        env.pixels[(int)trackerPosition.x+(int)trackerPosition.y*env.width] = color(127);
      } else {
        env.pixels[(int)trackerPosition.x+((int)trackerPosition.y+i)*env.width] = color(0);
      }
    }
    for (int x = 0; x < env.width; x++) {
      if (abs((float)percent-(float)((float)x/env.width)) < .01){        
        trackerPosition.set(x, (int)(25+map(modOuts[0].modData[(int)map(x, 0, env.width, 0, sampleLength)], -1.2, 1.2, 25, -25)));
        for (int i = -1; i <= 1; i++){
          env.pixels[(int)trackerPosition.x+((int)trackerPosition.y+i)*env.width] = color(255, 0, 0); 
        }
        break;
      } 
    }
    env.updatePixels();
  }
  
  void sendModValue(){
    for (PVector p : modOuts[0].receivers){
      modules.get((int)p.x).modIns[(int)p.y].receiveModValue(modOuts[0].modData[frameCount%sampleLength]);
    }
  }
  
  void operate(){
    amplitude = cp5.getController("amp"+str(id)).getValue()/2;
    sampleLength = (int)cp5.getController("dur"+str(id)).getValue();
    int type = (int)cp5.getGroup("modType"+str(id)).getValue();
    int phaseOffset = (int)(cp5.getController("phase"+str(id)).getValue()*(float)sampleLength);
    float[] prePhase = new float[sampleLength];
    modOuts[0].modData = new float[sampleLength];
    switch(type){
    case 0 : //sin
      for (int i = 0; i < sampleLength; i++){
        prePhase[i] = amplitude*sin((float)i*2*PI/sampleLength);
      }
      break;
    case 1 : //square
      for (int i = 0; i < sampleLength; i++){
        if (i<sampleLength/2){
          prePhase[i] = amplitude;
        } else {
          prePhase[i] = -amplitude;
        }
      }
      break;
    case 2 : //saw
      for (int i = 0; i < sampleLength; i++){
        prePhase[i] = amplitude-((float)i/sampleLength)*2*amplitude;
      }
      break;
    case 3 : //tri
      for (int i = 0; i < sampleLength; i++){
        prePhase[i] = amplitude-abs(2*amplitude-((float)i/sampleLength)*4*amplitude);
      }
      break; 
    case 4 : //noise
      float seed = seeds.get(int(cp5.get(Textfield.class, "modNoiseSeed"+str(id)).getText()));
      for (int i = 0; i < sampleLength; i++){
        prePhase[i] = map((float)noise.eval(seed+cos((float)i*2*PI/sampleLength), seed+sin((float)i*2*PI/sampleLength)), -1, 1, -amplitude, amplitude);
      }
      break; 
    case 5 : //random
      for (int i = 0; i < sampleLength; i++){
        prePhase[i] = random(2*amplitude)-amplitude;
      }
      break;   
    }
    //add phase offset
    for (int i = 0; i < sampleLength; i++){
      modOuts[0].modData[i] = prePhase[(i+phaseOffset)%sampleLength];
    }
    updateEnv();
  }
  
  void invertEnv(){
    for (int i = 0; i < modOuts[0].modData.length; i++){
      modOuts[0].modData[i] *= -1;
    }
    updateEnv();
  }
  
  void reverseEnv(){
    float[] temp = new float[sampleLength];
    arrayCopy(modOuts[0].modData, temp);
    for (int i = 1; i <= sampleLength; i++){
      modOuts[0].modData[i-1] = temp[sampleLength-i];
    }
    updateEnv();
  }
  
  void updateEnv(){
    env.loadPixels();
    for (int i = 0; i < env.pixels.length; i++) {
      env.pixels[i] = color(0); 
    }
    for (int x = 0; x < env.width; x++) {
      env.pixels[x+(int)(25+map(modOuts[0].modData[(int)map(x, 0, env.width, 0, sampleLength)], -1.2, 1.2, 25, -25))*env.width] = color(127) ; 
    }
    env.updatePixels();
  }
}

class Sampler extends Module{
  
  int sampleLength = 250;
  float amplitude = .5;
  PVector trackerPosition = new PVector(0, 25);
  PImage env;
    
  Sampler(){
    super();
    size = new PVector(100, 24);
    c = color(250, 100, 0);
    name = "sampler";
    isModifier = true;
    
    cp5.addSlider("sampleAmp"+str(id))
      .setLabel("")
      .setPosition(6, 8)
      .setWidth(88)
      .setHeight(10)
      .setRange(.001, 1)
      .setValue(.5)
      .setLabelVisible(false)
      .plugTo(this, "operate")
      .setGroup("g"+str(id))
      ; 
     
    grabber = new GrabberNode(new PVector(id, 1), new PVector(pos.x+size.x/2, pos.y));
    ins = new InputNode[1];
    modOuts = new ModOutput[1];    

    ins[0] = new InputNode(new PVector(id, 0), new PVector(pos.x, pos.y));
    modOuts[0] = new ModOutput(new PVector(id, 0, -1), new PVector(pos.x, pos.y+size.y-4));   
        
    env = createImage(100, 50, RGB); 
    modOuts[0].modData = new float[sampleLength];
 
  }
  
  void display(){
    super.display();
    if (ins[0].flowId >= 0 && ins[0].lookUp){
      operate();
    }
    if (super.allSystemsGo()){
      trackOutput();
    }
    image(env, pos.x, pos.y+size.y);
  }
  
  //change env PImage to reflect where we are in the modifier envelope
  void trackOutput(){
    float prev = (float)((frameCount-1)%sampleLength)/sampleLength;
    float percent = (float)(frameCount%sampleLength)/sampleLength;
    env.loadPixels();
    for (int i = -1; i <= 1; i++){
      if (i == 0){
        env.pixels[(int)trackerPosition.x+(int)trackerPosition.y*env.width] = color(127);
      } else {
        env.pixels[(int)trackerPosition.x+((int)trackerPosition.y+i)*env.width] = color(0);
      }
    }
    for (int x = 0; x < env.width; x++) {
      if (abs((float)percent-(float)((float)x/env.width)) < .01){        
        trackerPosition.set(x, (int)(25+map(modOuts[0].modData[(int)map(x, 0, env.width, 0, sampleLength)], -1.2, 1.2, 25, -25)));
        for (int i = -1; i <= 1; i++){
          env.pixels[(int)trackerPosition.x+((int)trackerPosition.y+i)*env.width] = color(255, 0, 0); 
        }
        break;
      } 
    }
    env.updatePixels();
  }
  
  //void headsUp(){
  //  super.headsUp();
  //}
  
  void sendModValue(){
    for (PVector p : modOuts[0].receivers){
      modules.get((int)p.x).modIns[(int)p.y].receiveModValue(modOuts[0].modData[frameCount%sampleLength]);
    }
  }
  
  void operate(){
    //checking connections here because in Modifiers, we call operate directly instead of headsUp
    if (super.allSystemsGo()){
      super.operate();
      int in = ins[0].flowId;
      int w = stack.get(in).dataWidth;
      sampleLength = w;
      amplitude = cp5.getController("sampleAmp"+str(id)).getValue();
      modOuts[0].modData = new float[sampleLength];    
      for (int i = 0; i < sampleLength; i++){
        modOuts[0].modData[i] = map(stack.get(in).data[(int)((float)w*i/sampleLength)], 0, 255, -amplitude, amplitude);
      }
      updateEnv();
    }
  }
  
  void invertEnv(){
    for (int i = 0; i < modOuts[0].modData.length; i++){
      modOuts[0].modData[i] *= -1;
    }
    updateEnv();
  }
  
  void reverseEnv(){
    float[] temp = new float[sampleLength];
    arrayCopy(modOuts[0].modData, temp);
    for (int i = 1; i <= sampleLength; i++){
      modOuts[0].modData[i-1] = temp[sampleLength-i];
    }
    updateEnv();
  }
  
  void updateEnv(){
    env.loadPixels();
    for (int i = 0; i < env.pixels.length; i++) {
      env.pixels[i] = color(0); 
    }
    for (int x = 0; x < env.width; x++) {
      env.pixels[x+(int)(25+map(modOuts[0].modData[(int)map(x, 0, env.width, 0, sampleLength)], -1.2, 1.2, 25, -25))*env.width] = color(127) ; 
    }
    env.updatePixels();
  }
}
