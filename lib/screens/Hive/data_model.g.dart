// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserRecipeAdapter extends TypeAdapter<UserRecipe> {
  @override
  final int typeId = 0;

  @override
  UserRecipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserRecipe(
      name: fields[0] as String,
      description: fields[1] as String,
      ingredients: (fields[2] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
      direction: fields[3] as String,
      time: fields[4] as String,
      imagePath: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserRecipe obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.ingredients)
      ..writeByte(3)
      ..write(obj.direction)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FavRecipeAdapter extends TypeAdapter<FavRecipe> {
  @override
  final int typeId = 1;

  @override
  FavRecipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavRecipe(
      recipeName: fields[0] as String,
      recipeData: (fields[1] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, FavRecipe obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.recipeName)
      ..writeByte(1)
      ..write(obj.recipeData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavRecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CartIngredientsAdapter extends TypeAdapter<CartIngredients> {
  @override
  final int typeId = 2;

  @override
  CartIngredients read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartIngredients(
      recipeName: fields[0] as String,
      recipeData: (fields[1] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, CartIngredients obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.recipeName)
      ..writeByte(1)
      ..write(obj.recipeData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartIngredientsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExtraIngredientsAdapter extends TypeAdapter<ExtraIngredients> {
  @override
  final int typeId = 3;

  @override
  ExtraIngredients read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExtraIngredients(
      ingredients: (fields[0] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, ExtraIngredients obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.ingredients);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExtraIngredientsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EditProfileAdapter extends TypeAdapter<EditProfile> {
  @override
  final int typeId = 4;

  @override
  EditProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EditProfile(
      name: fields[0] as String,
      description: fields[1] as String,
      phone: fields[2] as int,
      profilePhotoPath: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EditProfile obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.profilePhotoPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
