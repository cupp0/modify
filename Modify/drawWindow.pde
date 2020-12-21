PImage drawCanvas = createImage(250, 250, RGB);
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<PShape> temporaryShapes = new ArrayList<PShape>();
boolean fill = true;
boolean closed = true;


void drawMousePressed(){
  points.add(new PVector(mouseX, mouseY));
}
  
void drawMouseDragged(){
  points.add(new PVector(mouseX, mouseY));
  addTemporaryShape();
}
  
void drawMouseReleased(){
  if (temporaryShapes.size() > 0){
    drawCanvas.loadPixels();
    drawCanvas = get(0, 550, 250, 250);          
    drawCanvas.updatePixels();
    temporaryShapes.clear();
    points.clear();
  }
}

void sendIt(){
  modules.add(new Draw());
  // build new Module, grab draw window contents
}

void flickFill(){
  fill = flick(fill);
}

void flickClose(){
  closed = flick(closed);
}

void addTemporaryShape(){
  strokeWeight(cp5.getController("strokeWeight").getValue());
  stroke(cp5.getController("color").getValue()); 
  fill(cp5.getController("color").getValue()); 
  PShape p = createShape();
  
  switch((int)cp5.getGroup("drawMode").getValue()){
  case 0 :
    if (closed){
      temporaryShapes.clear();
      p.beginShape();
      for (PVector pv : points){
        p.vertex(pv.x, pv.y);
      }
    } else {
      p.beginShape();
      p.vertex(points.get(points.size()-2).x, points.get(points.size()-2).y);
      p.vertex(points.get(points.size()-1).x, points.get(points.size()-1).y);
    }
    break;
  case 1 :
    temporaryShapes.clear();
    p.beginShape(LINES);
    p.vertex(points.get(0).x, points.get(0).y);
    p.vertex(mouseX, mouseY); 
    break;
  case 2 :
    temporaryShapes.clear();
    PVector currentMouse = points.get(points.size()-1).copy();
    p.beginShape();
    for (int j = 0; j < (int)cp5.getController("faces").getValue(); j++) {
      p.vertex(currentMouse.x, currentMouse.y);
      currentMouse = rotatePV(currentMouse, points.get(0), (2*PI/cp5.getController("faces").getValue()));
    }
    break;
  case 3 :
    temporaryShapes.clear();
    int size = points.size()-1;
    p.beginShape();
    p.vertex(points.get(0).x, points.get(0).y);
    p.bezierVertex(points.get((int)size/3).x, points.get((int)size/3).y, points.get((int)2*size/3).x, points.get((int)2*size/3).y, points.get(size).x, points.get(size).y);    
    break;  
  case 4 :
    temporaryShapes.clear();
    float diam = 2*(new PVector(mouseX, mouseY)).dist(points.get(0));
    p = createShape(ELLIPSE, points.get(0).x, points.get(0).y, diam, diam);     
    break; 
  }
  //stroke(cp5.getController("color").getValue()); 
  //fill(cp5.getController("color").getValue()); 
  
  if ((int)cp5.getGroup("drawMode").getValue() != 4){
    if (closed){
      p.endShape(CLOSE);
    } else {
      p.endShape();
    }
  }
  
  if (fill){
    p.setFill(true);
  } else {
    p.setFill(false);
  }      
    
  temporaryShapes.add(p);
}
