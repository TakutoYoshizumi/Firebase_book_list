import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../domain/book.dart';

//ChangeNotifierはリスナーに変更通知を行う機能を提供しているクラス
class BookListModel extends ChangeNotifier {
  //// CollectionReference
  //①データへの参照を作成
  final _userCollection = FirebaseFirestore.instance.collection('books');

  List<Book>? books;

  void fetchBookList() async {
    //コレクションの取得　Firestore
    //CollectionReference を使って get() すると QuerySnapshot が得らる。

    //②参照からsnapshotを取得
    final QuerySnapshot snapshot = await _userCollection.get();

    //③snapshotからデータを取得
    final List<Book> books = snapshot.docs.map((DocumentSnapshot document) {
      //data()スナップショットからデータを取得
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String title = data["title"];
      final String author = data["author"];

      return Book(id, title, author);
    }).toList();

    this.books = books;
    //notifyListeners() リスナーに変更通知を行います。
    notifyListeners();
  }
}
