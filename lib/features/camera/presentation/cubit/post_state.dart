part of 'post_cubit.dart';

@freezed
class PostState with _$PostState {
  const factory PostState.initial() = _Initial;
  const factory PostState.loading() = _Loading;
  const factory PostState.success(String name, String file) = _Success;
  const factory PostState.error(String message) = _Error;
}
