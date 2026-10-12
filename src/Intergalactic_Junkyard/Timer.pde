class Timer {
  int savedTime;
  int totalTime;

  Timer(int totalTime) {
    this.totalTime = totalTime;
  }

  void start() {
    savedTime = millis();
  }

  boolean isFinished() {
    int passedTime = millis() - savedTime;
    return passedTime > totalTime;
  }
}
