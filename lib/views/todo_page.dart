import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_sample/models/todo.dart';
import 'package:firebase_sample/view_models/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Todo todo = Todo();
    // 状態が変化するたびに再ビルドする
    final _todoProvider = ref.watch(todoProvider);

    // メソッドや値を取得する
    final _todoNotifier = ref.watch(todoProvider.notifier);

    List<Todo> todoItems = _todoNotifier as List<Todo>;

    // コントローラ
    final _textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Sample')),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                alignment: Alignment.topCenter,
                child: ListView(
                  children: allCard(todoItems),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> allCard(
    List<Todo> items,
  ) {
    List<Widget> list = [];
    for (Todo item in items) {
      Widget _card = card(item);
      list.insert(0, _card);
    }
    return list;
  }

  // todo
  Widget card(Todo todo) {
    return Consumer(
      builder: ((context, ref, child) {
        return Slidable(
          child: Card(
            child: ListTile(
              title: Text(todo.title),
              subtitle: Text(todo.description),
            ),
          ),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                flex: 1,
                icon: Icons.create,
                backgroundColor: Colors.green,
                label: '編集',
                onPressed: (_) async {
                  await showDialog(
                    context: context,
                    builder: (context2) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [],
                      );
                    },
                  );
                },
              ),
              SlidableAction(
                flex: 1,
                icon: Icons.delete,
                backgroundColor: Colors.red,
                label: '削除',
                onPressed: (_) {},
              ),
            ],
          ),
        );
      }),
    );
  }
}
