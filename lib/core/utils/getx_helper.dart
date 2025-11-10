// utils/getx_helper.dart
import 'package:get/get.dart';

extension GetXExtensions on GetInterface {
  T getOrPut<T>(T Function() creator, {String? tag, bool fenix = false}) {
    if (!isRegistered<T>(tag: tag)) {
      return put<T>(creator(), tag: tag);
    }
    return find<T>(tag: tag);
  }

  T getOrPutLazy<T>(T Function() creator, {String? tag, bool fenix = false}) {
    if (!isRegistered<T>(tag: tag)) {
      lazyPut<T>(creator, tag: tag, fenix: fenix);
    }
    return find<T>(tag: tag);
  }

  bool isRegistered<T>({String? tag}) =>
      GetInstance().isRegistered<T>(tag: tag);
}
