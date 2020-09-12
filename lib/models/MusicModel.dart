import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:firstgame/Base/Consts.dart';

class MusicModel {
  List<BeatNodes> beatNodes;
  String beatsPos;
  String link;
  String name;
  int totalLength;
  String uid;
  String localPath;

  MusicModel(
      {this.beatNodes,
      this.beatsPos,
      this.link,
      this.name,
      this.totalLength,
      this.uid});

  MusicModel.fromJson(Map<String, dynamic> json) {
    if (json['beatNodes'] != null) {
      beatNodes = new List<BeatNodes>();
      json['beatNodes'].forEach((v) {
        beatNodes.add(new BeatNodes.fromJson(convertToMap(v)));
      });
    }
    beatsPos = json['beatsPos'];
    link = json['link'];
    name = json['name'];
    totalLength = json['totalLength'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.beatNodes != null) {
      data['beatNodes'] = this.beatNodes.map((v) => v.toJson()).toList();
    }
    data['beatsPos'] = this.beatsPos;
    data['link'] = this.link;
    data['name'] = this.name;
    data['totalLength'] = this.totalLength;
    data['uid'] = this.uid;
    return data;
  }

  List<int> get beatPosInt {
    return beatsPos.split(",").map((e) => int.parse(e)).toList()
      ..sort((a, b) => a.compareTo(b));
  }

  bool isThisPosABeat(int pos) {
    return beatPosInt.contains(pos);
  }

  getData(int pos) {
    for (var i = 0; i < beatNodes.length; i++) {
      final node = beatNodes[i];
      final isSelecting = node.isSelecting(pos);
      if (isSelecting != null) {
        return MusicData(
          isSelecting: isSelecting,
          node: i,
          nodeCount: node.beatPosInt.length,
          showPos: node.beatPosInt,
          counter: isSelecting ? node.firstBeat - pos : pos,
        );
      }
    }
    return MusicData(
        isSelecting: false, node: -1, nodeCount: 3, showPos: [], counter: 0);
  }
}

class BeatNodes {
  String beatPos;
  int count;
  int endTime;
  int startTime;

  BeatNodes({this.beatPos, this.count, this.endTime, this.startTime});

  BeatNodes.fromJson(Map<String, dynamic> json) {
    beatPos = json['beatPos'];
    count = json['count'];
    endTime = json['endTime'];
    startTime = json['startTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['beatPos'] = this.beatPos;
    data['count'] = this.count;
    data['endTime'] = this.endTime;
    data['startTime'] = this.startTime;
    return data;
  }

  List<int> get beatPosInt {
    return beatPos.split(",").map((e) => int.parse(e)).toList()
      ..sort((a, b) => a.compareTo(b));
  }

  bool isSelecting(int pos) {
    if (pos > endTime) return null;
    return selectingRang.contains(pos);
  }

  List<int> get selectingRang {
    return List.generate(firstBeat - startTime, (index) => startTime + index);
  }

  // List<int> get _showingRang {
  //   return List.generate(endTime - firstBeat + 1, (index) => firstBeat + index);
  // }

  int get firstBeat {
    return beatPosInt.first;
  }
}

class MusicData {
  int node;
  int nodeCount;
  int counter;
  bool isSelecting;
  List<int> showPos;
  MusicData({
    this.node,
    this.nodeCount,
    this.counter,
    this.isSelecting,
    this.showPos,
  });

  int indexOfBeat(int pos) {
    return showPos.indexOf(pos);
  }

  MusicData copyWith({
    int node,
    int nodeCount,
    int counter,
    bool isSelecting,
    List<int> showPos,
  }) {
    return MusicData(
      node: node ?? this.node,
      nodeCount: nodeCount ?? this.nodeCount,
      counter: counter ?? this.counter,
      isSelecting: isSelecting ?? this.isSelecting,
      showPos: showPos ?? this.showPos,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'node': node,
      'nodeCount': nodeCount,
      'counter': counter,
      'isSelecting': isSelecting,
      'showPos': showPos,
    };
  }

  factory MusicData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MusicData(
      node: map['node'],
      nodeCount: map['nodeCount'],
      counter: map['counter'],
      isSelecting: map['isSelecting'],
      showPos: List<int>.from(map['showPos']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MusicData.fromJson(String source) =>
      MusicData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MusicData(node: $node, nodeCount: $nodeCount, counter: $counter, isSelecting: $isSelecting, showPos: $showPos)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MusicData &&
        o.node == node &&
        o.nodeCount == nodeCount &&
        o.counter == counter &&
        o.isSelecting == isSelecting &&
        listEquals(o.showPos, showPos);
  }

  @override
  int get hashCode {
    return node.hashCode ^
        nodeCount.hashCode ^
        counter.hashCode ^
        isSelecting.hashCode ^
        showPos.hashCode;
  }
}
