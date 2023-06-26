import 'dart:developer';

import 'package:bondio/controller/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PeerInfo {
  String? id;

  // String? peerName;
  String? peerId;
  String? timestamp;
  bool? isPinned;

  PeerInfo({this.id, this.peerId, this.isPinned, this.timestamp});

  Map<String, dynamic> toJson() {
    return {
      ApiConstant.id: id,
      ApiConstant.timestamp: timestamp,
      ApiConstant.isPinned: isPinned,
      ApiConstant.peerId: peerId,

    };
  }

  factory PeerInfo.fromDocument(DocumentSnapshot doc) {
    log('DOC ${doc.data()}');
    String id = doc.get(ApiConstant.id);
    // String peerName = doc.get(ApiConstant.peerName);
    String peerId = doc.get(ApiConstant.peerId);
    String timestamp = doc.get(ApiConstant.timestamp);
    bool isPinned = doc.get(ApiConstant.isPinned);

    return PeerInfo(
        id: id,

        timestamp: timestamp,
        peerId: peerId,
        isPinned: isPinned);
  }
}