import 'package:lugat/model/abstract/i_base_model.dart';

/// Created by Yunus Emre Yıldırım
/// on 4.10.2022

abstract class IStorageBaseService<T extends IBaseModel> {
  Future<List<T>?> getAll();
}
