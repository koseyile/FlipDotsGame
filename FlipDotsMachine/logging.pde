import processing.core.PApplet;

public class Logging {
  private PApplet parent;
  private PFont font;
  private int logX;
  private int logY;
  private int logSpacing;
  private ArrayList<String> logs;

  public Logging(PApplet parent) {
    this.parent = parent;
    font = parent.createFont("Arial", 14);
    logX = 10;
    logY = 20;
    logSpacing = 20;
    logs = new ArrayList<String>();
  }

  public void log(String message) {
    logs.add(message);
  }

  public void displayLogs() {
    parent.fill(0);
    parent.textFont(font);
    for (int i = 0; i < logs.size(); i++) {
      parent.text(logs.get(i), logX, logY + i * logSpacing);
    }
  }
}
