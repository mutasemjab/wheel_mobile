import '../../../../core/result/result.dart';
import '../entities/home_data.dart';

abstract interface class HomeRepository {
  Future<Result<HomeData>> getHome({bool fromCache = false});
}
