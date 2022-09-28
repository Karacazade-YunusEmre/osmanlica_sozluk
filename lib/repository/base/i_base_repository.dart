import '../../model/abstract/i_base_model.dart';

/// Created by Yunus Emre Yıldırım
/// on 23.09.2022

abstract class IBaseRepository<T extends IBaseModel> {
  Future<List<T>> getAll();

  Future<bool> add(T item);

  Future<bool> addAll(List<T> itemList);

  Future<bool> update(T item);

  Future<bool> delete(T item);
}
