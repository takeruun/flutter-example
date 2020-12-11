// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Source _$SourceFromJson(Map<String, dynamic> json) {
  return _Source.fromJson(json);
}

/// @nodoc
class _$SourceTearOff {
  const _$SourceTearOff();

// ignore: unused_element
  _Source call({String uid, String name, String email}) {
    return _Source(
      uid: uid,
      name: name,
      email: email,
    );
  }

// ignore: unused_element
  Source fromJson(Map<String, Object> json) {
    return Source.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $Source = _$SourceTearOff();

/// @nodoc
mixin _$Source {
  String get uid;
  String get name;
  String get email;

  Map<String, dynamic> toJson();
  $SourceCopyWith<Source> get copyWith;
}

/// @nodoc
abstract class $SourceCopyWith<$Res> {
  factory $SourceCopyWith(Source value, $Res Function(Source) then) =
      _$SourceCopyWithImpl<$Res>;
  $Res call({String uid, String name, String email});
}

/// @nodoc
class _$SourceCopyWithImpl<$Res> implements $SourceCopyWith<$Res> {
  _$SourceCopyWithImpl(this._value, this._then);

  final Source _value;
  // ignore: unused_field
  final $Res Function(Source) _then;

  @override
  $Res call({
    Object uid = freezed,
    Object name = freezed,
    Object email = freezed,
  }) {
    return _then(_value.copyWith(
      uid: uid == freezed ? _value.uid : uid as String,
      name: name == freezed ? _value.name : name as String,
      email: email == freezed ? _value.email : email as String,
    ));
  }
}

/// @nodoc
abstract class _$SourceCopyWith<$Res> implements $SourceCopyWith<$Res> {
  factory _$SourceCopyWith(_Source value, $Res Function(_Source) then) =
      __$SourceCopyWithImpl<$Res>;
  @override
  $Res call({String uid, String name, String email});
}

/// @nodoc
class __$SourceCopyWithImpl<$Res> extends _$SourceCopyWithImpl<$Res>
    implements _$SourceCopyWith<$Res> {
  __$SourceCopyWithImpl(_Source _value, $Res Function(_Source) _then)
      : super(_value, (v) => _then(v as _Source));

  @override
  _Source get _value => super._value as _Source;

  @override
  $Res call({
    Object uid = freezed,
    Object name = freezed,
    Object email = freezed,
  }) {
    return _then(_Source(
      uid: uid == freezed ? _value.uid : uid as String,
      name: name == freezed ? _value.name : name as String,
      email: email == freezed ? _value.email : email as String,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_Source with DiagnosticableTreeMixin implements _Source {
  _$_Source({this.uid, this.name, this.email});

  factory _$_Source.fromJson(Map<String, dynamic> json) =>
      _$_$_SourceFromJson(json);

  @override
  final String uid;
  @override
  final String name;
  @override
  final String email;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Source(uid: $uid, name: $name, email: $email)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Source'))
      ..add(DiagnosticsProperty('uid', uid))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('email', email));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Source &&
            (identical(other.uid, uid) ||
                const DeepCollectionEquality().equals(other.uid, uid)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(uid) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(email);

  @override
  _$SourceCopyWith<_Source> get copyWith =>
      __$SourceCopyWithImpl<_Source>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_SourceToJson(this);
  }
}

abstract class _Source implements Source {
  factory _Source({String uid, String name, String email}) = _$_Source;

  factory _Source.fromJson(Map<String, dynamic> json) = _$_Source.fromJson;

  @override
  String get uid;
  @override
  String get name;
  @override
  String get email;
  @override
  _$SourceCopyWith<_Source> get copyWith;
}
