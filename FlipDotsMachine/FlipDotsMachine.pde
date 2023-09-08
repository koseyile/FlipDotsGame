Logging logging;
FlipDotsController flipDotsController;
import oscP5.*;  
import netP5.*;

OscP5 oscP5;
NetAddress dest;
  
void setup() {
  size(400, 300);
  surface.setTitle("Logging Example");

  logging = new Logging(this);
  flipDotsController = new FlipDotsController(this);

  // 调用日志函数进行测试
  logging.log("This is the first log");
  logging.log("This is the second log");
  
   oscP5 = new OscP5(this, 9999);
   //dest = new NetAddress("192.168.1.37", 9998);
   dest = new NetAddress("127.0.0.1", 9998);
}

void draw() {
  background(255);
  logging.displayLogs();
  
  flipDotsController.update();
  
}

void keyPressed() {
  // 按键按下时被调用
  if (key == 'k' || key == 'K') {
    println("K键被按下");
    sendOsc();
  }
}


// Function to send OSC messages to browser
void sendOsc() {
  println("sendOsc");
  OscMessage msg = new OscMessage("/socketio");  // tell the address
  msg.add((float)1); // add the message
  oscP5.send(msg, dest); //send the OSC message
}

// Recieve OSC messages from browser
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/socketio") == true) {
    // Receiving the output from browser
    int output = theOscMessage.get(0).intValue();
    println("oscEvent: 0="+output);
    
    output = theOscMessage.get(1).intValue();
    println("oscEvent: 1="+output);
    
  }
}
