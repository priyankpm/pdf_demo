import 'package:whiskers_flutter_app/src/common_utility/common_utility.dart';

enum PetActivityEnum { none, sleep, eat, memoryWall, game, chat, uploadImage }

extension PetActivityEnumExtension on PetActivityEnum {
  String get name {
    switch (this) {
      case PetActivityEnum.none:
        return 'None';
      case PetActivityEnum.sleep:
        return sleepString;
      case PetActivityEnum.eat:
        return eatString;
      case PetActivityEnum.memoryWall:
        return memoryWallString;
      case PetActivityEnum.game:
        return memoryWallString;
      case PetActivityEnum.chat:
        return chatString;
      case PetActivityEnum.uploadImage:
        return 'Upload an Image';
    }
  }
}
