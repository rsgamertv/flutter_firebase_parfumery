import 'package:auto_route/auto_route.dart';

import 'routes.gr.dart';
@AutoRouterConfig()
class AppRouter extends $AppRouter {

 @override
 List<AutoRoute> get routes => [
  AutoRoute(page: AuthRoute.page),
  AutoRoute(page: AuthBoard.page),
  AutoRoute(page: RegisterRoute.page),
  AutoRoute(page: GoogleRegRoute.page),
  AutoRoute(page: ForgotPassword.page),
  AutoRoute(page: BottomNavigation.page, children: [
  AutoRoute(page: HomeRoute.page,),
  AutoRoute(page: BucketRoute.page),
  AutoRoute(page: FavoriteRoute.page),
  AutoRoute(page: HistoryRoute.page),
  AutoRoute(page: ProfileRoute.page)
  ])
 ];
}