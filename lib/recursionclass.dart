part of 'main.dart';

class RecursionClass {
  static List<T> recursiveMapWidget<K, V, T>(
      List<MapEntry<K, V>> entries,
      T Function(MapEntry<K, V>) builder,
      ) {
    List<T> result = [];
    void helper(int index) {
      if (index >= entries.length) return;
      result.add(builder(entries[index]));
      helper(index + 1);
    }

    helper(0);
    return result;
  }

  static List<T> recursiveMap<T, K>(
      List<K> res,
      T Function(K) builder, [
        int index = 0,
      ]) {
    List<T> result = [];
    void helper(int index) {
      if (index >= res.length) return;
      result.add(builder(res[index]));
      helper(index + 1);
    }

    helper(0);
    return result;
  }

  static List<T> recursiveWhere<T>(
      List<T> list,
      bool Function(T) test, [
        int index = 0,
      ]) {
    List<T> result = [];

    void helper(int index) {
      if (index >= list.length) return;
      if (test(list[index])) {
        result.add(list[index]);
      }
      helper(index + 1);
    }

    helper(0);
    return result;
  }
}