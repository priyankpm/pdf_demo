import 'package:flutter/material.dart';

import '../enum/pet_activity_enum.dart';

class VideoBottomBarModel {
  VideoBottomBarModel(this.path,this.callback,this.petActivityEnum);

  final String path;
  final VoidCallback callback;
  final PetActivityEnum petActivityEnum;
}