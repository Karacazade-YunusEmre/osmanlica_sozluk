import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lugat/main.dart';
import 'package:uuid/uuid.dart';

import '/model/concrete/directory_model.dart';
import '/utilities/ui_constant.dart';
import '../../../controller/main_controller.dart';

/// Created by Yunus Emre Yıldırım
/// on 26.09.2022

class DirectoryAddUpdateDialog {
  final formKey = GlobalKey<FormState>();
  late MainController mainController;
  late TextEditingController textController;
  String directoryName = '';

  DirectoryAddUpdateDialog() {
    mainController = Get.find();
    textController = TextEditingController();

    _showDialog;
  }

  dynamic get _showDialog {
    return Get.defaultDialog(
      title: 'YENİ BİR Klasör EKLEYİN',
      titleStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      barrierDismissible: false,
      radius: 30,
      backgroundColor: UIConstant.getDefaultThemeData.backgroundColor,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'Klasör Adını Yazın ...',
                  label: Text('Klasör Adı'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.length < 3 || value.isEmpty) {
                    return 'Klasör adı boş veya \n3 karakterden küçük olamaz!';
                  }
                  return null;
                },
                onSaved: (String? value) => directoryName = value!,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      DirectoryModel directoryModel = DirectoryModel(id: const Uuid().v1(), name: directoryName);

                      mainController.directoryList.add(directoryModel);
                      directoryDal.add(directoryModel);

                      textController.clear();
                      Get.back();
                      Get.snackbar(
                        'BİLGİ',
                        'Klasör başarıyla kaydedildi',
                        borderColor: Colors.green,
                        borderWidth: 2,
                        snackPosition: SnackPosition.BOTTOM,
                        maxWidth: 0.8.sw,
                      );
                    }
                  },
                  child: const Text('KAYDET'),
                ),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('KAPAT'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
