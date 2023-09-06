import processing.serial.*;
import socketio.*;

public class FlipDotsController {
  private PApplet parent;
  private Serial mySerial;
  private int numColumns; // Flip Dots 点阵的列数
  private int numRows; // Flip Dots 点阵的行数
  private boolean[][] dotStates; // 记录每个点的状态
  private byte[] mBuffer1;
  private byte[] mBuffer2;
  
  //socket.io
  private String serverUrl = "http://localhost:3000"; 
  private SocketIOClient socket;

  public FlipDotsController(PApplet p) {
    numColumns = 14;
    numRows = 28;

    dotStates = new boolean[numColumns][numRows];
    initializeDotStates(); // 初始化所有点的状态
    
    mBuffer1 = new byte[28];
    mBuffer2 = new byte[28];


      //String[] portList = Serial.list();
      //for (String port : portList) {
      //  println(port);
      //}
    
    parent = p;
    mySerial = new Serial(parent, "COM3", 57600); // 根据实际情况设置波特率
    //mySerial.clear(); // 清空串行缓冲区
    
    
    // 连接到 Socket.IO 服务器
    socket = new SocketIOClient(this, serverUrl);
    socket.connect();
  
    // 注册事件监听器
    socket.on("message", new MessageEvent() {
      void onEvent(JSONArray data) {
        // 处理收到的消息
        String message = data.getString(0);
        processMessage(message);
      }
     });
  }
  
  private void WriteBuffer(int id, byte[] buffer)
  {
      mySerial.write(0x80);
      mySerial.write(0x84);
      mySerial.write(id);
      
      mySerial.write(buffer);
      mySerial.write(0x8F);
      
      mySerial.write(0x80);
      mySerial.write(0x82);
      mySerial.write(0x8F);
  }
  
  
  
  private void Test(){

    for (int i = 0; i < 28; i++) {
      mBuffer1[i] = byte(0x00);
      mBuffer2[i] = byte(0x00);
    }
    
    SetDotState(4, 0, true);
    SetDotState(6, 1, true);
    SetDotState(7, 1, true);
    SetDotState(13, 1, true);
    SetDotState(13, 27, true);
    
    WriteBuffer(1, mBuffer1);
    WriteBuffer(2, mBuffer2);
    
  }

  private void initializeDotStates() {
    // 初始化所有点的状态，默认为关闭状态
    for (int i = 0; i < numColumns; i++) {
      for (int j = 0; j < numRows; j++) {
        dotStates[i][j] = false;
      }
    }
  }
  
  private void SetDotState(int x, int y, boolean state)
  {
    if(x<0 || x>=numColumns)
    {
      println("SetDotState error: x out of range:"+x);
      return;
    }
    
    if(y<0 || y>=numRows)
    {
      println("SetDotState error: y out of range:"+y);
      return;
    }
    
    dotStates[x][y] = state;
    
    byte[] buffer = mBuffer1;
    if(x>6)
    {
      buffer = mBuffer2;
    }
    
    byte v1 = buffer[y];
    byte v2 = byte(1 << (6-x%7));
    if(state==false)
    {
      v2 = (byte) (v2 ^ 0xFF);
      v1 &= v2;
    }else{
      v1 |= v2;
    }
    
    println("SetDotState: " + Integer.toBinaryString(v1));
    buffer[y] = v1;
    
  }

  public void setDotState(int column, int row, boolean state) {
    // 设置指定点的状态
    if (column >= 0 && column < numColumns && row >= 0 && row < numRows) {
      dotStates[column][row] = state;
    }
  }

  public void update() {
    // 更新 Flip Dots 设备的状态
    StringBuilder sb = new StringBuilder();

    // 将点的状态转换为字符串，例如：010101...
    for (int j = 0; j < numRows; j++) {
      for (int i = 0; i < numColumns; i++) {
        sb.append(dotStates[i][j] ? '1' : '0');
      }
    }

    // 发送字符串到串行设备
    //mySerial.write(sb.toString());
    
    Test();
  }

  public void close() {
    // 关闭串行连接
    mySerial.stop();
  }
}
