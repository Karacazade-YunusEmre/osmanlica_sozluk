import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/pages/home_page.dart';
import '../ui/pages/page_not_found.dart';

/// Created by Yunus Emre Yıldırım
/// on 22.09.2022

final GoRouter router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
  ],
  errorBuilder: (BuildContext context, GoRouterState state) {
    return const PageNotFound();
  },
);
