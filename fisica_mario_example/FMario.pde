import fisica.*;

class FMario extends FPoly {
  public float jump_power = 120000;
  public float move_power = 1000;
  public float move_dash_power = 4000;
  public float max_speed  = 1000;
  public float anim_speed = 0.002;

  private PImage m_img;
  private float m_width;
  private float m_height;
  private PImage current_img = null; // just link, it has no instance
  private PImage[] images;

  private boolean m_isLanding = false;
  private boolean m_isJumping = false;
  private boolean m_isLookingLeft = false;
  private boolean m_isWaling = false;
  private boolean m_isStanding = true;
  private float anim_time = 0;

  private static final int RUN1 = 0;
  private static final int RUN2 = 1;
  private static final int RUN3 = 2;
  private static final int STAND = 3;
  private static final int JUMP = 4;  
  private final String[] fileNames = {
    "run1.png", "run2.png", "run3.png", "stand.png", "jump.png"
  };  

  public FMario(float h) {
    super();

    images = new PImage [fileNames.length];
    for (int i=0; i<fileNames.length; i++) {
      images[i] = loadImage(fileNames[i]);
    }

    m_height = h;
    m_width = h * (float)(images[STAND].width)/images[STAND].height;
    current_img = images[STAND];

    this.setRotatable(false); // important!!!

    this.vertex(0, 0);
    this.vertex(m_width, 0);
    this.vertex(m_width, m_height*0.9);
    this.vertex(m_width*0.8, m_height);
    this.vertex(m_width*0.2, m_height);
    this.vertex(0, m_height*0.9);
  }

  public void jump() {
    float vy = this.getVelocityY();
    if ( m_isLanding ) {
      this.addForce( 0, -jump_power );
      m_isJumping = true;
    }
  }

  public boolean isLanded() {
    return m_isLanding;
  }

  public void goRight(boolean dash) {
    float power = move_power;
    if ( dash && m_isLanding ) {
      power = move_dash_power;
    }   
    this.addForce(power, 0);
    if ( max_speed < this.getVelocityX() ) {
      this.setVelocity( max_speed, this.getVelocityY() );
    }
    m_isLookingLeft = false;
  }

  public void goLeft(boolean dash) {
    float power = move_power;
    if ( dash && m_isLanding ) {
      power = move_dash_power;
    }
    this.addForce(-power, 0);
    if ( this.getVelocityX() < -max_speed ) {
      this.setVelocity( -max_speed, this.getVelocityY() );
    }
    m_isLookingLeft = true;
  }
  
  /*
  private void go(int dirX, boolean dash) {
    float power = move_power;
    if ( dash && m_isLanding ) {
      power = move_dash_power;
    }
    
  }*/

  private void checkState() {    
    // current values =========================
    float px = this.getX();
    float py = this.getY();
    float vx = this.getVelocityX();
    float vy = this.getVelocityY();
    float foot_px1 = px + m_width*0.1;
    float foot_px2 = px + m_width*0.9;
    float foot_py1 = py + m_height*0.9;
    float foot_py2 = py + m_height;

    // landing check ==========================
    boolean landed_temp = false;
    ArrayList<FContact> contacts = this.getContacts();        
    for ( FContact c : contacts ) {
      float cx = c.getX();
      float cy = c.getY();
      if ( foot_px1 < cx && cx < foot_px2 && foot_py1 < cy && cy <= foot_py2 ) {
        landed_temp = true;
        break;
      }
    }
    m_isLanding = landed_temp;

    // jumping reset ==========================
    if ( m_isLanding ) {
      m_isJumping = false;
    }

    // standing ==========================
    if ( -5 < vx && vx < 5 && -0.1 < vy && vy < 0.1 ) {
      m_isStanding = true;
    } else {
      m_isStanding = false;
    }
  }

  private void selectImage() {
    if ( m_isStanding ) {
      current_img = images[STAND];
    } else {
      anim_time += abs(this.getVelocityX())*anim_speed;
      int k = round(anim_time)%3;  // k = 0, 1, 2 (RUN1, RUN2, RUN3)
      current_img = images[k];
    }
    if ( m_isJumping ) {
      current_img = images[JUMP];
    }
  }

  public void draw(PGraphics applet) {
    checkState();   
    selectImage();

    preDraw(applet); 
    {
      applet.noSmooth();
      applet.pushMatrix();
      applet.translate( m_width/2, m_height/2 );
      if ( m_isLookingLeft ) {
        applet.scale( -1, 1 );
      }
      applet.scale( m_height/current_img.height );
      applet.imageMode(CENTER);
      applet.image( current_img, 0, 0);    
      applet.imageMode(CORNER);
      applet.popMatrix();
      applet.smooth();
    } 
    postDraw(applet);

    // debug=======================
    // contact points
    /*
     ArrayList<FContact> contacts = this.getContacts();
     for ( FContact c : contacts ) {
     ellipse( c.getX(), c.getY(), 10, 10);
     }    
     // draw poly
     setNoFill();
     super.draw(applet);
     */
  }
  
}

