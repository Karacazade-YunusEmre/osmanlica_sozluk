import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lugat/main.dart';
import 'package:lugat/utilities/string_extensions.dart';
import 'package:uuid/uuid.dart';

import '/model/concrete/directory_model.dart';
import '/utilities/ui_constant.dart';
import '../../../controller/main_controller.dart';

/// Created by Yunus Emre Yıldırım
/// on 26.09.2022

class DirectoryAddUpdateDialog {
  final DirectoryModel? currentDirectory;
  final formKey = GlobalKey<FormState>();
  late MainController mainController;
  late TextEditingController textController;
  String directoryName = '';

  DirectoryAddUpdateDialog({required this.currentDirectory}) {
    mainController = Get.find();
    textController = TextEditingController(text: currentDirectory == null ? '' : currentDirectory!.name);

    _showDialog;
  }

  dynamic get _showDialog {
    return Get.defaultDialog(
      title: currentDirectory == null ? 'YENİ BİR KLASÖR EKLEYİN' : 'KLASÖR ADINI GÜNCELLEYİN',
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
                  if (value == null || value.length < 3 || value.length > 13 || value.isEmpty) {
                    return 'Klasör adı boş veya \n3 karakterden küçük,\n13 karakterden büyük olamaz!';
                  }
                  return null;
                },
                onSaved: (String? value) => directoryName = value!.getFixDirectoryName,
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

                      if (currentDirectory != null) {
                        int directoryIndex = mainController.directoryList.indexOf(currentDirectory);

                        currentDirectory!.name = directoryName;
                        mainController.directoryList[directoryIndex] = currentDirectory!;

                        directoryDal.update(currentDirectory!);
                      } else {
                        DirectoryModel directoryModel = DirectoryModel(id: const Uuid().v1(), name: directoryName, sentenceCount: 0);

                        mainController.directoryList.add(directoryModel);
                        directoryDal.add(directoryModel);
                      }

                      textController.clear();
                      Get.back();
                      Get.snackbar(
                        'BİLGİ',
                        currentDirectory == null ? 'Klasör başarıyla kaydedildi' : 'Klasör başarıyla güncellendi',
                        borderColor: Colors.green,
                        borderWidth: 2,
                        snackPosition: SnackPosition.BOTTOM,
                        maxWidth: 0.8.sw,
                      );
                    }
                  },
                  child: Text(currentDirectory == null ? 'KAYDET' : 'GÜNCELLE'),
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
