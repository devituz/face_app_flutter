import 'package:bloc/bloc.dart';
import 'package:face/constants/controllers.dart';
import 'package:face/features/login/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState.initial());

  void verifyOtp(String phone, String password, BuildContext context) async {
    emit(const AuthState.loading());
    final otpService = OtpService(); // OtpService'ni to'g'ridan-to'g'ri yaratamiz

    try {
      await otpService.otp(phone, password, context); // OtpService'dan foydalanish
      emit(const AuthState.success()); // On successful OTP verification
    } catch (e) {
      debugPrint("OTP xatosi: ${e.toString()}");
      emit(AuthState.error('Tasdiqlashda xatolik yuz berdi, keyinroq qayta urining.'));
    }
  }



}
