import 'package:freezed_annotation/freezed_annotation.dart';
part 'todo.freezed.dart';

@freezed
class Todo with _$Todo {
  // DBの状態を保持するクラス
  factory Todo({
    @Default(false) bool isLoading,
     String? id,
    @Default('') String title,
    @Default('') String description,
  }) = _Todo;
}
