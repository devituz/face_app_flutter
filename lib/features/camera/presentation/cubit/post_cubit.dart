import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:face/features/camera/presentation/service/camera.dart';
import 'package:vibration/vibration.dart';

part 'post_state.dart';
part 'post_cubit.freezed.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(const PostState.initial());

  Future<void> postcamera({
    required File file,
    required BuildContext context,
  }) async {
    emit(const PostState.loading());

    try {
      final Map<String, dynamic> response = await CameraService().postCamera(
        file: file,
        context: context,
      );
      print("object");
      // Explicitly check if the 'name' or 'file' are null or missing
      // if (response['name'] == null || response['file'] == null) {
      //   throw Exception('Missing name or file data');
      // }
      emit(PostState.success(response['name'], response['file']));

    } catch (e) {
      Navigator.pop(context);
      debugPrint("Xatosi: ${e.toString()}");
      emit(PostState.error('Студент не найден.'));
      await Vibration.vibrate(
        pattern: [0, 500, 100, 500],
        intensities: [255, 255],
      );
    }
  }
}
