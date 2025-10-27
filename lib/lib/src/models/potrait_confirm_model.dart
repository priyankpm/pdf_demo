class PortraitConfirmModel {
  final bool? isConfirmed;

  PortraitConfirmModel({this.isConfirmed});

  PortraitConfirmModel copyWith({bool? isConfirmed}) {
    return PortraitConfirmModel(isConfirmed: isConfirmed ?? this.isConfirmed);
  }
}