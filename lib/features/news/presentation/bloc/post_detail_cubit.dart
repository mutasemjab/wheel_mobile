import '../../../../core/bloc/data_cubit.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/get_post.dart';

class PostDetailCubit extends DataCubit<PostDetail> {
  PostDetailCubit(this._getPost, this.slug, {super.refreshTrigger});

  final GetPost _getPost;
  final String slug;

  @override
  Future<Result<PostDetail>> fetch({required bool fromCache}) =>
      _getPost(slug, fromCache: fromCache);
}
