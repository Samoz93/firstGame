class GameModel {
  bool isFull;
  String owner;
  dynamic phases;
  String player2;
  String uid;
  bool isWaiting;
  int startDate;
  GameModel(
      {this.isFull,
      this.owner,
      this.phases,
      this.player2,
      this.startDate,
      this.uid,
      this.isWaiting});

  GameModel.fromJson(Map<String, dynamic> json) {
    isFull = json['isFull'];
    owner = json['owner'];
    player2 = json['player2'];
    startDate = json['startDate'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isFull'] = this.isFull;
    data['owner'] = this.owner;
    data['startDate'] = this.startDate;
    data['player2'] = this.player2;
    data['uid'] = this.uid;
    return data;
  }

  bool amITheOwner(String uid) {
    return owner == uid;
  }
}

class Phases {
  Uid1 uid1;
  Uid1 uid2;

  Phases({this.uid1, this.uid2});

  Phases.fromJson(Map<String, dynamic> json) {
    uid1 = json['uid1'] != null ? new Uid1.fromJson(json['uid1']) : null;
    uid2 = json['uid2'] != null ? new Uid1.fromJson(json['uid2']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uid1 != null) {
      data['uid1'] = this.uid1.toJson();
    }
    if (this.uid2 != null) {
      data['uid2'] = this.uid2.toJson();
    }
    return data;
  }
}

class Uid1 {
  int p1;
  int p2;
  int p3;

  Uid1({this.p1, this.p2, this.p3});

  Uid1.fromJson(Map<String, dynamic> json) {
    p1 = json['p1'];
    p2 = json['p2'];
    p3 = json['p3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['p1'] = this.p1;
    data['p2'] = this.p2;
    data['p3'] = this.p3;
    return data;
  }
}
