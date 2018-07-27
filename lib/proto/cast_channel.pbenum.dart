///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library extensions.api.cast_channel_cast_channel_pbenum;

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart';

class CastMessage_ProtocolVersion extends ProtobufEnum {
  static const CastMessage_ProtocolVersion CASTV2_1_0 = const CastMessage_ProtocolVersion._(0, 'CASTV2_1_0');

  static const List<CastMessage_ProtocolVersion> values = const <CastMessage_ProtocolVersion> [
    CASTV2_1_0,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static CastMessage_ProtocolVersion valueOf(int value) => _byValue[value] as CastMessage_ProtocolVersion;
  static void $checkItem(CastMessage_ProtocolVersion v) {
    if (v is! CastMessage_ProtocolVersion) checkItemFailed(v, 'CastMessage_ProtocolVersion');
  }

  const CastMessage_ProtocolVersion._(int v, String n) : super(v, n);
}

class CastMessage_PayloadType extends ProtobufEnum {
  static const CastMessage_PayloadType STRING = const CastMessage_PayloadType._(0, 'STRING');
  static const CastMessage_PayloadType BINARY = const CastMessage_PayloadType._(1, 'BINARY');

  static const List<CastMessage_PayloadType> values = const <CastMessage_PayloadType> [
    STRING,
    BINARY,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static CastMessage_PayloadType valueOf(int value) => _byValue[value] as CastMessage_PayloadType;
  static void $checkItem(CastMessage_PayloadType v) {
    if (v is! CastMessage_PayloadType) checkItemFailed(v, 'CastMessage_PayloadType');
  }

  const CastMessage_PayloadType._(int v, String n) : super(v, n);
}

class AuthError_ErrorType extends ProtobufEnum {
  static const AuthError_ErrorType INTERNAL_ERROR = const AuthError_ErrorType._(0, 'INTERNAL_ERROR');
  static const AuthError_ErrorType NO_TLS = const AuthError_ErrorType._(1, 'NO_TLS');

  static const List<AuthError_ErrorType> values = const <AuthError_ErrorType> [
    INTERNAL_ERROR,
    NO_TLS,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static AuthError_ErrorType valueOf(int value) => _byValue[value] as AuthError_ErrorType;
  static void $checkItem(AuthError_ErrorType v) {
    if (v is! AuthError_ErrorType) checkItemFailed(v, 'AuthError_ErrorType');
  }

  const AuthError_ErrorType._(int v, String n) : super(v, n);
}

