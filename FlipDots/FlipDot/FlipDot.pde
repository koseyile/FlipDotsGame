
/**
 * FlipDot Controller
 *
 * This Processing sketch is to control FlipDot panels from AlfaZeta.
 * It uses a virtual display you can draw and animate on that then gets cast to your FlipDot display panels.
 *
 * If you don't have a FlipDot display you can still use this software as a FlipDot simulator. Just set `config_cast = false`
 *
 * @author Owen McAteer
 * @url https://github.com/owenmcateer/FlipDots
 * @socials https://twitter.com/motus_art
 * @socials https://instagram.com/motus_art
 *
 * Required libraries
 * - processing.net | Processing foundation
 * - processing.serial | Processing foundation
 * - websockets | Lasse Steenbock Vestergaard | (Only for realtime Crypo feed example)
 */
import org.gamecontrolplus.*;
//import org.gamecontrollplus.gui.*;
import java.util.List;

ControlIO control;
ControlDevice stick;

List<ControlDevice> devicesList;
ControlDevice[] devicesArray;

boolean IsUpPressed = false;
boolean IsDownPressed = false;
boolean IsLeftPressed = false;
boolean IsRightPressed = false;
boolean IsUseJoyStick = true;

void setup() {
  size(1080, 720, P2D);

  control = ControlIO.getInstance(this);
  println(control.getDevices());
  
  
  devicesList = control.getDevices();
  devicesArray = devicesList.toArray(new ControlDevice[devicesList.size()]);
  for (int i = 0; i < devicesArray.length; i++) {
    println("Controller " + i + ": " + devicesArray[i].getName());
    if(devicesArray[i].getName().equals("Controller (XBOX 360 For Windows)"))
    {
      stick = control.getDevice(devicesArray[i].getName());
      println(stick.toText(""));
    }
  }

  //stick = control.getDevice("Controller (XBOX 360 For Windows)");
  //println(stick.toText(""));
  
  frameRate(config_fps);
  colorMode(RGB, 255, 255, 255, 1);

  // Core setup functions
    cast_setup();
  config_setup();
  stages_setup();
  ui_setup();
  
  
  // Scene setup
  //crypto_ticker_setup();
}


/**
 * Draw tick
 */
 
 int pressedNum = 0;
void draw() {
  background(59); //<>//

  /*
  10
  up : 2
  down : 6
  left : 8
  right : 4
  0 1 2 3
  */
  
  if(stick!=null)
  {
      if( (stick.getButton(10).getValue()>1.5 && stick.getButton(10).getValue()<2.5) || stick.getButton(3).getValue()>7.0)
      {
        //println("ttt:"+stick.getButton(10).getValue());
        IsUpPressed = true;
      }else{
        //println("ggg:"+stick.getButton(10).getValue());
        IsUpPressed = false;
      }
      
       if( (stick.getButton(10).getValue()>5.5 && stick.getButton(10).getValue()<6.5) || stick.getButton(0).getValue()>7.0)
      {
        IsDownPressed = true;
      }else{
        IsDownPressed = false;
      }
      
       if(stick.getButton(10).getValue()>7.5 && stick.getButton(10).getValue()<8.5)
      {
        IsLeftPressed = true;
      }else{
        IsLeftPressed = false;
      }
      
      if(stick.getButton(10).getValue()>3.5 && stick.getButton(10).getValue()<4.5)
      {
        IsRightPressed = true;
      }else{
        IsRightPressed = false;
      }
  }
  

  
  //println("IsUpPressed:"+IsUpPressed+" IsDownPressed:"+IsDownPressed+" IsLeftPressed:"+IsLeftPressed+" IsRightPressed:"+IsRightPressed);
  
  /*
  for(int i=0; i<11; i++)
  {
      if(stick.getButton(i).pressed())
      {
        //pressedNum++;
          println("button pressed"+ i+" value:"+stick.getButton(i).getValue());
      }
  }
  */
  

  

  

  
  /*
  10
  up : 2
  down : 6
  left : 8
  right : 4
  0 1 2 3
  */

   
  

  
    // 3D test
  virtual3D.beginDraw();
  virtual3D.background(0);
  virtual3D.translate(virtual3D.width / 2, virtual3D.height / 2);
  virtual3D.rotateX(frameCount / 20.0);
  virtual3D.rotateY(frameCount / 20.0);
  virtual3D.stroke(255);
  virtual3D.strokeWeight(2);
  virtual3D.noFill();
  virtual3D.box(11);
  virtual3D.endDraw();
  // End 3D test

  // Between beginDraw/endDraw you can draw whatever you want to virtualDisplay(PGraphics)
  virtualDisplay.beginDraw();
  virtualDisplay.background(0);

  // Blips
  //example_blips();
  //example_anim();

  // Games
  games_tetris();

  // Crypto ticker
  //crypto_ticker();

  // End drawing
  virtualDisplay.endDraw();

  // Preview frame render
  ui_render();

  // Process frame
  stage_process();

  // Cast to display
  cast_broadcast();
  
}
