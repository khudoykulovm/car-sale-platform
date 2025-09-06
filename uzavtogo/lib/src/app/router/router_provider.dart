// uzavtogo/lib/src/app/router/router_provider.dart

part of 'app_router.dart';

/// Провайдер для доступа к роутеру
final routerProvider = Provider<GoRouter>((ref) {
  // Здесь можно добавить логику, зависящую от состояния приложения
  return AppRouter.router;
});

/// Провайдер для наблюдения за текущим маршрутом
final routeObserverProvider = Provider<RouteObserver<PageRoute>>((ref) {
  return RouteObserver<PageRoute>();
});

/// Провайдер для текущего местоположения
final currentLocationProvider = Provider<String>((ref) {
  final router = ref.watch(routerProvider);
  return router.location;
});

/// Провайдер для параметров текущего маршрута
final routeParamsProvider = Provider<Map<String, String>>((ref) {
  final router = ref.watch(routerProvider);
  final route = router.routerDelegate.currentConfiguration;
  return route?.pathParameters ?? {};
});

/// Провайдер для query параметров текущего маршрута
final routeQueryParamsProvider = Provider<Map<String, String>>((ref) {
  final router = ref.watch(routerProvider);
  final route = router.routerDelegate.currentConfiguration;
  return route?.uri.queryParameters ?? {};
});
