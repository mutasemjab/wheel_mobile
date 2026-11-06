import '../../../../core/bloc/data_cubit.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/rules.dart';
import '../../domain/usecases/get_rules.dart';

class RulesCubit extends DataCubit<Rules> {
  RulesCubit(this._getRules, {super.refreshTrigger});

  final GetRules _getRules;

  @override
  Future<Result<Rules>> fetch({required bool fromCache}) =>
      _getRules(fromCache: fromCache);
}
