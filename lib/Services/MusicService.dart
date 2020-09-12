import 'package:firebase_database/firebase_database.dart';
import 'package:firstgame/Base/Consts.dart';
import 'package:firstgame/models/MusicModel.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MusicService {
  final _db = FirebaseDatabase.instance;
  Future<List<MusicModel>> get musicList async {
    final x = await _db.reference().child(DBConsts.Musics).once();
    final map = convertToMap(x.value);
    return map.values.map((e) => MusicModel.fromJson(convertToMap(e))).toList();
  }

  Future<MusicModel> getMusic(String uid) async {
    final data = await _db.reference().child(DBConsts.Musics).child(uid).once();
    final model = MusicModel.fromJson(convertToMap(data.value));
    final pth = await _download(model.link);
    model.localPath = pth;
    return model;
  }

  Future<String> _download(String path) async {
    final x = await DefaultCacheManager().getSingleFile(path);
    return x.path;
  }
}
