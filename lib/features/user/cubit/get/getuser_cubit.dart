import 'package:bloc/bloc.dart';
import 'package:face/constants/controllers.dart';
import 'package:face/features/user/data/model/getme.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'getuser_state.dart';
part 'getuser_cubit.freezed.dart';

class GetuserCubit extends Cubit<GetuserState> {
  GetuserCubit() : super(const GetuserState.initial());


  Future<void> getUser(BuildContext context) async {
    emit(const GetuserState.loading());

    try {
      final getuser = await getUserService.getUser(context);
      emit(GetuserState.success(getuser));
    } catch (e) {
      emit(GetuserState.failure(e.toString()));
    }
  }
}


