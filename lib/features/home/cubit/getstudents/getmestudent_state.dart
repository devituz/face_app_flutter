part of 'getmestudent_cubit.dart';

@freezed
class GetmestudentState with _$GetmestudentState {
  const factory GetmestudentState.initial() = _Initial;
  const factory GetmestudentState.loading() = _Loading;
  const factory GetmestudentState.success(Getmestudents results) = _Success; // Here results should be of type Getmestudents
  const factory GetmestudentState.failure(String error) = _Failure;
}
