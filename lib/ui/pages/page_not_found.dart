import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Created by Yunus Emre Yıldırım
/// on 22.09.2022

class PageNotFound extends StatelessWidget {
  const PageNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: Container(
              width: 1.sw,
              height: 1.sh,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/page_not_found.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.3.sh,
            right: 0.1.sw,
            child: Text(
              'ÜZGÜNÜM BİR HATA ÇIKTI GALİBA.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 50.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
