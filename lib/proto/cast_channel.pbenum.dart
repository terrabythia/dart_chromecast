///
//  Generated code. Do not modify.
//  source: lib/proto/cast_channel.proto
//

// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class CastMessage_ProtocolVersion extends $pb.ProtobufEnum {
  static const CastMessage_ProtocolVersion CASTV2_1_0 = CastMessage_ProtocolVersion._(0, 'CASTV2_1_0');

  static const $core.List<CastMessage_ProtocolVersion> values = <CastMessage_ProtocolVersion> [
    CASTV2_1_0,
  ];

  static final $core.Map<$core.int, CastMessage_ProtocolVersion> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CastMessage_ProtocolVersion? valueOf($core.int value) => _byValue[value];

  const CastMessage_ProtocolVersion._($core.int v, $core.String n) : super(v, n);
}

class CastMessage_PayloadType extends $pb.ProtobufEnum {
  static const CastMessage_PayloadType STRING = CastMessage_PayloadType._(0, 'STRING');
  static const CastMessage_PayloadType BINARY = CastMessage_PayloadType._(1, 'BINARY');

  static const $core.List<CastMessage_PayloadType> values = <CastMessage_PayloadType> [
    STRING,
    BINARY,
  ];

  static final $core.Map<$core.int, CastMessage_PayloadType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CastMessage_PayloadType? valueOf($core.int value) => _byValue[value];

  const CastMessage_PayloadType._($core.int v, $core.String n) : super(v, n);
}

class AuthError_ErrorType extends $pb.ProtobufEnum {
  static const AuthError_ErrorType INTERNAL_ERROR = AuthError_ErrorType._(0, 'INTERNAL_ERROR');
  static const AuthError_ErrorType NO_TLS = AuthError_ErrorType._(1, 'NO_TLS');

  static const $core.List<AuthError_ErrorType> values = <AuthError_ErrorType> [
    INTERNAL_ERROR,
    NO_TLS,
  ];

  static final $core.Map<$core.int, AuthError_ErrorType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AuthError_ErrorType? valueOf($core.int value) => _byValue[value];

  const AuthError_ErrorType._($core.int v, $core.String n) : super(v, n);
}

