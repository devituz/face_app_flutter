import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:face/features/camera/presentation/service/camera.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/foundation.dart'; // kIsWeb uchun

part 'post_state.dart';
part 'post_cubit.freezed.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(const PostState.initial());

  Future<void> postcamera({
    required File file,
    required BuildContext context,
  }) async {

    if (kIsWeb) {
      emit(PostState.error('File upload is not supported on the web.'));
      return;
    }


    emit(const PostState.loading());

    try {
      final Map<String, dynamic> response = await CameraService().postCamera(
        file: file,
        context: context,
      );
      print("object");
      emit(PostState.success(response['name'], response['file']));

    } catch (e) {
      await Vibration.vibrate(
        pattern: [0, 500, 100, 500],
        intensities: [255, 255],
      );
      Navigator.pop(context);
      debugPrint("Error: ${e.toString()}");
      emit(const PostState.error('Candidate not found'));
    }

  }
}
