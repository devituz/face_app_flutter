import 'package:bloc/bloc.dart';
import 'package:face/constants/controllers.dart';
import 'package:face/features/home/data/model/getmestudents.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'getmestudent_state.dart';
part 'getmestudent_cubit.freezed.dart';


class GetmestudentCubit extends Cubit<GetmestudentState> {
  GetmestudentCubit() : super(const GetmestudentState.initial());

  Future<void> GetmeStudents(BuildContext context) async {
    emit(const GetmestudentState.loading());

    try {
      final getstudents = await getmestudentsService.getstudents(context);
      emit(GetmestudentState.success(getstudents)); // Ensure getstudents is of type Getmestudents
    } catch (e) {
      emit(GetmestudentState.failure(e.toString()));
    }
  }

}
