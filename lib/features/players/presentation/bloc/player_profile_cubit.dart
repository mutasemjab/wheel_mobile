import '../../../../core/bloc/data_cubit.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/player_profile.dart';
import '../../domain/usecases/get_player_profile.dart';

class PlayerProfileCubit extends DataCubit<PlayerProfile> {
  PlayerProfileCubit(this._getProfile, this.slug, {super.refreshTrigger});

  final GetPlayerProfile _getProfile;
  final String slug;

  @override
  Future<Result<PlayerProfile>> fetch({required bool fromCache}) =>
      _getProfile(slug, fromCache: fromCache);
}
