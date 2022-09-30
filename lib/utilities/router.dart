import 'package:get/get.dart';

import '../ui/pages/home_page.dart';

/// Created by Yunus Emre Yıldırım
/// on 22.09.2022

// final GoRouter router = GoRouter(
//   routes: <GoRoute>[
//     GoRoute(
//       path: '/',
//       builder: (BuildContext context, GoRouterState state) {
//         return const HomePage();
//       },
//     ),
//   ],
//   errorBuilder: (BuildContext context, GoRouterState state) {
//     return const PageNotFound();
//   },
// );

final List<GetPage> routes = [
  GetPage(
    name: '/',
    page: () => const HomePage(),
    transition: Transition.leftToRightWithFade,
    transitionDuration: const Duration(milliseconds: 500),
  ),
];
