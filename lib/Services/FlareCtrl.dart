import 'dart:math';

import 'package:firstgame/Base/Consts.dart';
import 'package:firstgame/Base/Enums.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';

class MyFlareController extends FlareController {
  FlutterActorArtboard _artboard;

  FlareAnimationLayer _idleAnim;
  FlareAnimationLayer _currentAnimation;
  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    _idleAnim.time = (_idleAnim.time + elapsed) % _idleAnim.duration;
    _idleAnim.apply(artboard);
    if (_currentAnimation != null) {
      _currentAnimation.time += elapsed;

      _currentAnimation.mix = min(1.0, _currentAnimation.time / 0.07);
      _currentAnimation.apply(artboard);

      /// When done, remove it.
      if (_currentAnimation.time >=
          _currentAnimation.duration + _extraDuratiom) {
        cancelAnimation();
      }
    }
    return true;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    _artboard = artboard;
    _idleAnim = FlareAnimationLayer()
      ..animation = _artboard.getAnimation("Idle")
      ..mix = 1.0;
  }

  @override
  void setViewTransform(Mat2D viewTransform) {
    // TODO: implement setViewTransform
  }
  int _extraDuratiom = 1;
  set anim(String name) {
    if (name == gDirToString(GDirections.None)) return;
    ActorAnimation animation = _artboard.getAnimation(name);
    _currentAnimation = FlareAnimationLayer()..animation = animation;
  }

  setAndMoveAnimation(String nm, double perc) {
    if (nm.isEmpty) return;
    if (nm == "cancel") {
      return cancelAnimation();
    }
    if (_currentAnimation == null) anim = nm;
    if (_currentAnimation.name != nm) {
      cancelAnimation();
      anim = nm;
    }
    _currentAnimation.time = _currentAnimation.duration * perc;
    _currentAnimation.apply(_artboard);
  }

  cancelAnimation() {
    if (_currentAnimation == null) return;
    _currentAnimation.time = 0;
    _currentAnimation.apply(_artboard);
    _currentAnimation = null;
  }

  set extraDuratiom(int dur) {
    _extraDuratiom = dur;
  }
}
