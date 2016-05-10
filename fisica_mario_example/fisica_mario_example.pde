import fisica.*;

FWorld world;
FPoly poly;
FMario mario;

// button states
boolean leftButtonPressed = false;
boolean rightButtonPressed = false;
boolean jumpButtonPressed = false;
boolean dashButtonPressed = false;

void setup() {
  size(300, 300);

  Fisica.init(this);
  
  // create world
  world = new FWorld();
  world.setEdges();
  world.setGravity(0, 500);  

  // create mario
  mario = new FMario(50);  
  mario.setPosition( width/2, height/3 );
  world.add(mario);
}


void draw() {
  // decide action of mario
  if ( rightButtonPressed ) {
    mario.goRight(dashButtonPressed);
  }
  if ( leftButtonPressed ) {
    mario.goLeft(dashButtonPressed);
  }
  if ( jumpButtonPressed ) {
    mario.jump();
  }

  // update and visualize
  background(255);
  world.step();
  world.draw();

  // creating polygon
  if (poly != null) {
    poly.setNoFill();
    poly.draw(this);
  }
}

void keyPressed() {
  // update key states for control
  if ( keyCode==RIGHT ) {
    rightButtonPressed = true;
  }
  if ( keyCode==LEFT ) {
    leftButtonPressed = true;
  }
  if ( keyCode==UP ) {
    jumpButtonPressed = true;
  }
  if ( key==' ' ) {
    dashButtonPressed = true;
  }
}


void keyReleased() {
  // update key states for control
  if ( keyCode==RIGHT ) {
    rightButtonPressed = false;
  }
  if ( keyCode==LEFT ) {
    leftButtonPressed = false;
  }
  if ( keyCode==UP ) {
    jumpButtonPressed = false;
  }
  if ( key==' ' ) {
    dashButtonPressed = false;
  }
}

void mousePressed() {
  // create new polygon
  if (mouseButton==LEFT) {
    if (world.getBody(mouseX, mouseY) != null) {
      return;
    }  
    poly = new FPoly();
    // poly.setStatic(true);
    poly.setStrokeWeight(3);
    poly.vertex(mouseX, mouseY);
  }

  // create new Mario
  if ( mouseButton==RIGHT) {
    FMario m = new FMario(50);
    m.setPosition( mouseX, mouseY );
    world.add(m);
  }
}

void mouseDragged() {
  // add vertex to polygon
  if (poly!=null) {
    poly.vertex(mouseX, mouseY);
  }
}

void mouseReleased() {
  // add created polygon to world
  if (poly!=null) {
    poly.setFill(255, 200, 15);
    world.add(poly);
    poly = null;
  }
}

