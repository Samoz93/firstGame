import 'dart:async';
import 'package:firstgame/Screens/FlareCtrl.dart';
import 'package:firstgame/Services/GameService.dart';
import 'package:stacked/stacked.dart';
import 'package:firstgame/Base/Enums.dart';

class GamerPageVM extends BaseViewModel {
  final GameService _gSer = GameService(gameUid: "gUid", player2Uid: "pUid");
  Timer gameTimer;
  Timer secondTimer;
  String _anim = "Idle";
  String get anim => _anim;
  bool _started = false;
  bool get started => _started;
  set started(bool val) {
    _started = val;
    notifyListeners();
  }

  final ctr = MyFlareController();
  final period = 5;
  int _activePhase = 0;
  List<GPhase> phases = [GPhase(phase: 0)];
  bool _isShowingScore = false;
  bool get isShowingScore => _isShowingScore;

  GamerPageVM() {
    setAnim(GDirections.None);
  }
  int _currentSecond = 0;
  int get currentSecond => _currentSecond;
  set currentSecond(val) {
    _currentSecond = val;
    notifyListeners();
  }

  int _fullCounter = 5;
  startTimer() {
    if (started) return;
    started = true;
    _gSer.clearRoom();
    secondTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _fullCounter++;
      currentSecond = period - _fullCounter % period;
    });
    gameTimer = Timer.periodic(Duration(seconds: period), (timer) {
      isShowingScore = true;
      _lockPhase(_activePhase);
      setAnim(activePhase.choosedSide);
      _setActivePhase(timer.tick);

      phases.add(GPhase(phase: _activePhase));

      Timer.periodic(Duration(seconds: 2), (gg) {
        ctr.cancelAnimation();
        isShowingScore = false;
        gg.cancel();
      });
    });
  }

  setAnim(GDirections dir) {
    final str = dir == GDirections.None
        ? ""
        : dir.toString().replaceAll("GDirections.", "");
    // _anim = str;
    if (str.isNotEmpty) ctr.anim = str;
  }

  _lockPhase(int ph) {
    final pre =
        phases.firstWhere((element) => element.isActivePhase(_activePhase));
    pre.isLocked = true;
    if (pre.choosedSide == GDirections.None) {
      _gSer.saveDirection(ph, GDirections.None);
    }
  }

  Stream get player2Stream {
    return _gSer.player2Data;
  }

  chooseSide(GDirections dir) {
    if (activePhase.isLocked || isShowingScore) return;
    activePhase.choosedSide = dir;
    activePhase.isLocked = true;
    _gSer.saveDirection(_activePhase, dir);
    notifyListeners();
  }

  GPhase get activePhase =>
      phases.firstWhere((element) => element.isActivePhase(_activePhase),
          orElse: () => GPhase(phase: 0));
  set isShowingScore(bool val) {
    _isShowingScore = val;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _setActivePhase(phase) {
    _activePhase = phase;
    notifyListeners();
  }

  stopAll() async {
    gameTimer.cancel();
    await _gSer.clearRoom();
    started = false;
  }

  bool get showTimer => started && !activePhase.isLocked && !isShowingScore;
}

class GPhase {
  int phase;
  bool isLocked = false;
  GDirections choosedSide = GDirections.None;
  GPhase({
    this.phase,
    this.isLocked = false,
    this.choosedSide = GDirections.None,
  });

  bool isActivePhase(int ph) {
    return phase == ph;
  }

  GPhase copyWith({
    int phase,
    bool isLocked,
    GDirections choosedSide,
  }) {
    return GPhase(
      phase: phase ?? this.phase,
      isLocked: isLocked ?? this.isLocked,
      choosedSide: choosedSide ?? this.choosedSide,
    );
  }

  @override
  String toString() =>
      'GPhase(phase: $phase, isLocked: $isLocked, choosedSide: $choosedSide)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GPhase &&
        o.phase == phase &&
        o.isLocked == isLocked &&
        o.choosedSide == choosedSide;
  }

  @override
  int get hashCode => phase.hashCode ^ isLocked.hashCode ^ choosedSide.hashCode;
}
