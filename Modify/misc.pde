boolean isInside(PVector point, PVector target, PVector range){
  PVector p1 = target.copy().sub(abs(range.x), abs(range.y));
  PVector p2 = target.copy().add(abs(range.x), abs(range.y));
  boolean x = false;
  boolean y = false;
  if (p1.x < point.x){
    if (point.x <= p2.x){
      x = true;
    }
  }else if(point.x >= p2.x){
    x= true;
  }
  if (p1.y < point.y){
    if (point.y <= p2.y){
      y = true;
    }
  }else if(point.y >= p2.y){
    y= true;
  }
  if (x && y){
    return true;
  }else{
    return false;
  }
}

boolean isInsidePoints(PVector p, PVector p1, PVector p2){
  if (p1.y <= p.y){
    if (p.y <= p2.y){
    } else{
      return false;
    }      
  }else if(p.y >= p2.y){
  } else {
    return false;
  }
  return true;
}

boolean flick(boolean switcher){
  if (switcher){
    return false;
  }else{
    return true;
  }   
}

PVector rotatePV(PVector point, PVector axis, float angle){
  float s = sin(angle);
  float c = cos(angle);
  point.x -= axis.x;
  point.y -= axis.y;
  float xnew = point.x * c - point.y * s;
  float ynew = point.x * s + point.y * c;
  point.x = xnew + axis.x;
  point.y = ynew + axis.y;
  return point;
}

//checks if we are hovering a connection
boolean connectionHovered(PVector l1, PVector l2, PVector p){
  if (isInsidePoints(p, l1, l2)){
    if(abs((l1.y-l2.y)*p.x+(l2.x-l1.x)*p.y+l1.x*l2.y-l2.x*l1.y)/sqrt(pow(l2.x-l1.x, 2)+pow(l2.y-l1.y, 2)) < 2){
    return true;
    };  
  } 
  return false;
}

PVector scalePV(PVector point, PVector axis, PVector amount){
  point.x -= axis.x;
  point.y -= axis.y;
  point.set(point.x*amount.x, point.y*amount.y);
  point.x += axis.x;
  point.y += axis.y;
  return point;
}
