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

  static List<T> recursiveMergeSort<T> (
      List<T> list,
      int Function(T, T) compare, [
        int start = 0,
        int end = -1,
      ]) {
    if (end == -1) end = list.length - 1;

    if (list.isEmpty) return [];

    if (start >= end) return [list[start]];

    int mid = (start + end) ~/ 2;

    List<T> left = recursiveMergeSort(list, compare, start, mid);

    List<T> right = recursiveMergeSort(list, compare, mid + 1, end);

    List<T> merged = [];

    int i = 0, j = 0;

    while (i < left.length && j < right.length) {
      if (compare(left[i], right[j]) <= 0) {
        merged.add(left[i]);
        i++;
      } else {
        merged.add(right[j]);
        j++;
      }
    }

    while (i < left.length) {
      merged.add(left[i]);
      i++;
    }

    while (j < right.length) {
      merged.add(right[j]);
      j++;
    }

    return merged;
  }
}