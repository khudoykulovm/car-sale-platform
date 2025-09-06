// uzavtogo/lib/src/app/router/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/registration_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/ads/presentation/pages/ads_list_page.dart';
import '../../features/ads/presentation/pages/ad_detail_page.dart';
import '../../features/ads/presentation/pages/create_ad_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/categories/presentation/pages/categories_page.dart';

part 'router_provider.dart';

/// Конфигурация маршрутизации приложения
class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  /// Геттер для ключа навигатора
  static GlobalKey<NavigatorState> get navigatorKey => _rootNavigatorKey;

  /// Настройка маршрутизации приложения
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: <RouteBase>[
      /// Главный маршрут с BottomNavigationBar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomePage(navigationShell: navigationShell);
        },
        branches: [
          /// Ветка главной страницы
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomePage(),
                ),
                routes: [
                  /// Детальная страница объявления
                  GoRoute(
                    path: 'ad/:id',
                    name: 'ad_detail',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return AdDetailPage(adId: id);
                    },
                  ),

                  /// Страница поиска
                  GoRoute(
                    path: 'search',
                    name: 'search',
                    builder: (context, state) {
                      final query = state.uri.queryParameters['q'] ?? '';
                      final category = state.uri.queryParameters['category'] ?? '';
                      return SearchPage(
                        initialQuery: query,
                        initialCategory: category,
                      );
                    },
                  ),

                  /// Страница категорий
                  GoRoute(
                    path: 'categories',
                    name: 'categories',
                    builder: (context, state) => const CategoriesPage(),
                  ),
                ],
              ),
            ],
          ),

          /// Ветка избранного
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/favorites',
                name: 'favorites',
                builder: (context, state) => const FavoritesPage(),
                routes: [
                  /// Детальная страница объявления из избранного
                  GoRoute(
                    path: 'ad/:id',
                    name: 'favorites_ad_detail',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return AdDetailPage(adId: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          /// Ветка создания объявления
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/create',
                name: 'create_ad',
                builder: (context, state) => const CreateAdPage(),
              ),
            ],
          ),

          /// Ветка чатов
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/chats',
                name: 'chats',
                builder: (context, state) => const ChatListPage(),
                routes: [
                  /// Страница чата
                  GoRoute(
                    path: 'chat/:chatId',
                    name: 'chat',
                    builder: (context, state) {
                      final chatId = state.pathParameters['chatId']!;
                      final opponentName = state.uri.queryParameters['opponentName'] ?? '';
                      return ChatPage(
                        chatId: chatId,
                        opponentName: opponentName,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          /// Ветка профиля
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfilePage(),
                routes: [
                  /// Редактирование профиля
                  GoRoute(
                    path: 'edit',
                    name: 'edit_profile',
                    builder: (context, state) => const EditProfilePage(),
                  ),

                  /// Мои объявления
                  GoRoute(
                    path: 'my_ads',
                    name: 'my_ads',
                    builder: (context, state) => const AdsListPage(
                      isMyAds: true,
                    ),
                    routes: [
                      /// Детальная страница моего объявления
                      GoRoute(
                        path: 'ad/:id',
                        name: 'my_ad_detail',
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return AdDetailPage(adId: id, isMyAd: true);
                        },
                      ),
                    ],
                  ),

                  /// Настройки
                  GoRoute(
                    path: 'settings',
                    name: 'settings',
                    builder: (context, state) => const SettingsPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      /// Маршруты аутентификации (вне основного Shell)
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegistrationPage(),
      ),

      GoRoute(
        path: '/forgot_password',
        name: 'forgot_password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
    ],

    /// Перенаправления
    redirect: (context, state) {
      // Здесь можно добавить логику перенаправления на основе
      // состояния аутентификации пользователя
      final isLoggedIn = false; // Заменить на реальную проверку

      final goingToAuth = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot_password';

      if (!isLoggedIn && !goingToAuth) {
        return '/login';
      }

      if (isLoggedIn && goingToAuth) {
        return '/';
      }

      return null;
    },

    /// Обработка ошибок
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Страница не найдена',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Запрошенная страница не существует',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('На главную'),
            ),
          ],
        ),
      ),
    ),
  );

  /// Вспомогательные методы для навигации
  static void go(String path, {Object? extra}) {
    router.go(path, extra: extra);
  }

  static void push(String path, {Object? extra}) {
    router.push(path, extra: extra);
  }

  static void pop() {
    router.pop();
  }

  /// Переход к детальной странице объявления
  static void goToAdDetail(BuildContext context, String adId) {
    context.go('/ad/$adId');
  }

  /// Переход к странице чата
  static void goToChat(BuildContext context, String chatId, String opponentName) {
    context.go('/chats/chat/$chatId?opponentName=${Uri.encodeComponent(opponentName)}');
  }

  /// Переход к странице поиска
  static void goToSearch(BuildContext context, {String query = '', String category = ''}) {
    context.go('/search?q=${Uri.encodeComponent(query)}&category=${Uri.encodeComponent(category)}');
  }

  /// Переход к странице создания объявления
  static void goToCreateAd(BuildContext context) {
    context.go('/create');
  }

  /// Переход к странице профиля
  static void goToProfile(BuildContext context) {
    context.go('/profile');
  }

  /// Переход к странице избранного
  static void goToFavorites(BuildContext context) {
    context.go('/favorites');
  }

  /// Переход к странице чатов
  static void goToChats(BuildContext context) {
    context.go('/chats');
  }

  /// Выход из аккаунта
  static void logout(BuildContext context) {
    // Очистка данных пользователя
    // ...
    context.go('/login');
  }
}

/// Расширения для удобства навигации
extension GoRouterExtensions on BuildContext {
  void goToAdDetail(String adId) => AppRouter.goToAdDetail(this, adId);
  void goToChat(String chatId, String opponentName) => AppRouter.goToChat(this, chatId, opponentName);
  void goToSearch({String query = '', String category = ''}) => AppRouter.goToSearch(this, query: query, category: category);
  void goToCreateAd() => AppRouter.goToCreateAd(this);
  void goToProfile() => AppRouter.goToProfile(this);
  void goToFavorites() => AppRouter.goToFavorites(this);
  void goToChats() => AppRouter.goToChats(this);
  void logout() => AppRouter.logout(this);
}
