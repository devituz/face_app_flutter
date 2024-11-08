import 'package:freezed_annotation/freezed_annotation.dart';

part 'responsive_navigation_bar_state.freezed.dart';

@freezed
class ResponsiveNavigationBarState with _$ResponsiveNavigationBarState {
  const factory ResponsiveNavigationBarState.initial() = _Initial;
  const factory ResponsiveNavigationBarState.bottomNavigationBarInitial(int currentIndex) = _BottomNavigationBarInitial;

  // Add a private constructor
  const ResponsiveNavigationBarState._();

  int get currentIndex => maybeWhen(
    bottomNavigationBarInitial: (currentIndex) => currentIndex,
    orElse: () => 0, // Default to 0 if no state matches
  );
}
