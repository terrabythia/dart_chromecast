class LogInterface {
  Function? _logCallback;

  setLogCallback(void logCallback(Error e, String s)) {
    _logCallback = logCallback;
  }

  logInfo(String message) {
    if (null != _logCallback) {
      _logCallback!(null, message);
    }
  }

  logError(String message, [Object? error]) {
    if (null != _logCallback) {
      _logCallback!(error, message);
    }
  }
}
