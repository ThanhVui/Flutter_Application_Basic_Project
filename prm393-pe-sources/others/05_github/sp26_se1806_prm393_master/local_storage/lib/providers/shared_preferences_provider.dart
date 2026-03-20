import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences_provider.g.dart';

// Trực tiếp thao tác với LocalStorage (K, V)
@riverpod
SharedPreferences sharedPreferences(Ref ref) {
  // Giá trị của provider sẽ được cập lại lại
  // main() sẽ cung cấp giá trị cho nó
  throw UnimplementedError();
}