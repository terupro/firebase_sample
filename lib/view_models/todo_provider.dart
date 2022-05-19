import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_sample/models/todo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// DBの操作を行うクラス （dbの操作にstateを絡める）
class TodoNotifier extends StateNotifier<Todo> {
  TodoNotifier() : super(Todo());

  // idを取得
  final doc = FirebaseFirestore.instance.collection('lists').doc();

  // 書き込み処理
  createData(Todo data) async {
    if (data.title.isEmpty) {
      return;
    }
    state = state.copyWith(isLoading: true);
    await doc.set({
      'title': state.copyWith(title: data.title),
      'description': state.copyWith(title: data.description),
    });
    readData();
  }

  // 更新処理
  updateData(Todo data) async {
    final doc = FirebaseFirestore.instance.collection('lists').doc(data.id);
    if (data.title.isEmpty) {
      return;
    }
    state = state.copyWith(isLoading: true);
    await doc.update({
      'title': state.copyWith(title: data.title),
      'description': state.copyWith(title: data.description),
    });
    readData();
  }

  // 削除処理
  deleteData(Todo data) async {
    final doc = FirebaseFirestore.instance.collection('lists').doc(data.id);
    state = state.copyWith(isLoading: true);
    await doc.delete();
    readData();
  }

  // 読み込み処理
  readData() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('books').get();
    final List<Todo> lists = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String id = document.id;
      final String title = data['title'];
      final String description = data['description'];
      return state = state.copyWith(
        id: id,
        title: title,
        description: description,
      );
    }).toList();
  }
}

// 無名関数の中に処理を書くことで初期化を可能にしている。これにより、常に最新の状態を管理できる。
final todoProvider = StateNotifierProvider((_) {
  TodoNotifier notify = TodoNotifier();
  notify.readData();
  return notify; // 初期化
});
