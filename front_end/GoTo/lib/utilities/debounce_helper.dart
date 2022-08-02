import 'dart:async';

class DebounceHelper {
  DebounceHelper({this.milliseconds = 500});

  final int milliseconds;
  Timer? _timer;
  bool _isEnable = true;

  runButton(Function() action) {
    if (_isEnable) {
      _isEnable = false;
      action.call();
      _timer = Timer(Duration(milliseconds: milliseconds), () => _isEnable = true);
    }
  }

  runTextChange(Function() action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}