Logging logging;
FlipDotsController flipDotsController;

void setup() {
  size(400, 300);
  surface.setTitle("Logging Example");

  logging = new Logging(this);
  flipDotsController = new FlipDotsController(this);

  // 调用日志函数进行测试
  logging.log("This is the first log");
  logging.log("This is the second log");
}

void draw() {
  background(255);
  logging.displayLogs();
  
  flipDotsController.update();
}
