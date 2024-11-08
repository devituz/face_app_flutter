part of 'getuser_cubit.dart';

@freezed
class GetuserState with _$GetuserState {
  const factory GetuserState.initial() = _Initial;
  const factory GetuserState.loading() = _Loading;
  const factory GetuserState.success(Getme getuser) = _Success;
  const factory GetuserState.failure(String error) = _Failure;
}
