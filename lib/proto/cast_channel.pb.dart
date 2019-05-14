///
//  Generated code. Do not modify.
//  source: proto/cast_channel.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'cast_channel.pbenum.dart';

export 'cast_channel.pbenum.dart';

class CastMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CastMessage', package: const $pb.PackageName('extensions.api.cast_channel'))
    ..e<CastMessage_ProtocolVersion>(1, 'protocolVersion', $pb.PbFieldType.QE, CastMessage_ProtocolVersion.CASTV2_1_0, CastMessage_ProtocolVersion.valueOf, CastMessage_ProtocolVersion.values)
    ..aQS(2, 'sourceId')
    ..aQS(3, 'destinationId')
    ..aQS(4, 'namespace')
    ..e<CastMessage_PayloadType>(5, 'payloadType', $pb.PbFieldType.QE, CastMessage_PayloadType.STRING, CastMessage_PayloadType.valueOf, CastMessage_PayloadType.values)
    ..aOS(6, 'payloadUtf8')
    ..a<$core.List<$core.int>>(7, 'payloadBinary', $pb.PbFieldType.OY)
  ;

  CastMessage() : super();
  CastMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CastMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CastMessage clone() => CastMessage()..mergeFromMessage(this);
  CastMessage copyWith(void Function(CastMessage) updates) => super.copyWith((message) => updates(message as CastMessage));
  $pb.BuilderInfo get info_ => _i;
  static CastMessage create() => CastMessage();
  CastMessage createEmptyInstance() => create();
  static $pb.PbList<CastMessage> createRepeated() => $pb.PbList<CastMessage>();
  static CastMessage getDefault() => _defaultInstance ??= create()..freeze();
  static CastMessage _defaultInstance;

  CastMessage_ProtocolVersion get protocolVersion => $_getN(0);
  set protocolVersion(CastMessage_ProtocolVersion v) { setField(1, v); }
  $core.bool hasProtocolVersion() => $_has(0);
  void clearProtocolVersion() => clearField(1);

  $core.String get sourceId => $_getS(1, '');
  set sourceId($core.String v) { $_setString(1, v); }
  $core.bool hasSourceId() => $_has(1);
  void clearSourceId() => clearField(2);

  $core.String get destinationId => $_getS(2, '');
  set destinationId($core.String v) { $_setString(2, v); }
  $core.bool hasDestinationId() => $_has(2);
  void clearDestinationId() => clearField(3);

  $core.String get namespace => $_getS(3, '');
  set namespace($core.String v) { $_setString(3, v); }
  $core.bool hasNamespace() => $_has(3);
  void clearNamespace() => clearField(4);

  CastMessage_PayloadType get payloadType => $_getN(4);
  set payloadType(CastMessage_PayloadType v) { setField(5, v); }
  $core.bool hasPayloadType() => $_has(4);
  void clearPayloadType() => clearField(5);

  $core.String get payloadUtf8 => $_getS(5, '');
  set payloadUtf8($core.String v) { $_setString(5, v); }
  $core.bool hasPayloadUtf8() => $_has(5);
  void clearPayloadUtf8() => clearField(6);

  $core.List<$core.int> get payloadBinary => $_getN(6);
  set payloadBinary($core.List<$core.int> v) { $_setBytes(6, v); }
  $core.bool hasPayloadBinary() => $_has(6);
  void clearPayloadBinary() => clearField(7);
}

class AuthChallenge extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AuthChallenge', package: const $pb.PackageName('extensions.api.cast_channel'))
    ..hasRequiredFields = false
  ;

  AuthChallenge() : super();
  AuthChallenge.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AuthChallenge.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AuthChallenge clone() => AuthChallenge()..mergeFromMessage(this);
  AuthChallenge copyWith(void Function(AuthChallenge) updates) => super.copyWith((message) => updates(message as AuthChallenge));
  $pb.BuilderInfo get info_ => _i;
  static AuthChallenge create() => AuthChallenge();
  AuthChallenge createEmptyInstance() => create();
  static $pb.PbList<AuthChallenge> createRepeated() => $pb.PbList<AuthChallenge>();
  static AuthChallenge getDefault() => _defaultInstance ??= create()..freeze();
  static AuthChallenge _defaultInstance;
}

class AuthResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AuthResponse', package: const $pb.PackageName('extensions.api.cast_channel'))
    ..a<$core.List<$core.int>>(1, 'signature', $pb.PbFieldType.QY)
    ..a<$core.List<$core.int>>(2, 'clientAuthCertificate', $pb.PbFieldType.QY)
    ..p<$core.List<$core.int>>(3, 'clientCa', $pb.PbFieldType.PY)
  ;

  AuthResponse() : super();
  AuthResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AuthResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AuthResponse clone() => AuthResponse()..mergeFromMessage(this);
  AuthResponse copyWith(void Function(AuthResponse) updates) => super.copyWith((message) => updates(message as AuthResponse));
  $pb.BuilderInfo get info_ => _i;
  static AuthResponse create() => AuthResponse();
  AuthResponse createEmptyInstance() => create();
  static $pb.PbList<AuthResponse> createRepeated() => $pb.PbList<AuthResponse>();
  static AuthResponse getDefault() => _defaultInstance ??= create()..freeze();
  static AuthResponse _defaultInstance;

  $core.List<$core.int> get signature => $_getN(0);
  set signature($core.List<$core.int> v) { $_setBytes(0, v); }
  $core.bool hasSignature() => $_has(0);
  void clearSignature() => clearField(1);

  $core.List<$core.int> get clientAuthCertificate => $_getN(1);
  set clientAuthCertificate($core.List<$core.int> v) { $_setBytes(1, v); }
  $core.bool hasClientAuthCertificate() => $_has(1);
  void clearClientAuthCertificate() => clearField(2);

  $core.List<$core.List<$core.int>> get clientCa => $_getList(2);
}

class AuthError extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AuthError', package: const $pb.PackageName('extensions.api.cast_channel'))
    ..e<AuthError_ErrorType>(1, 'errorType', $pb.PbFieldType.QE, AuthError_ErrorType.INTERNAL_ERROR, AuthError_ErrorType.valueOf, AuthError_ErrorType.values)
  ;

  AuthError() : super();
  AuthError.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AuthError.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AuthError clone() => AuthError()..mergeFromMessage(this);
  AuthError copyWith(void Function(AuthError) updates) => super.copyWith((message) => updates(message as AuthError));
  $pb.BuilderInfo get info_ => _i;
  static AuthError create() => AuthError();
  AuthError createEmptyInstance() => create();
  static $pb.PbList<AuthError> createRepeated() => $pb.PbList<AuthError>();
  static AuthError getDefault() => _defaultInstance ??= create()..freeze();
  static AuthError _defaultInstance;

  AuthError_ErrorType get errorType => $_getN(0);
  set errorType(AuthError_ErrorType v) { setField(1, v); }
  $core.bool hasErrorType() => $_has(0);
  void clearErrorType() => clearField(1);
}

class DeviceAuthMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DeviceAuthMessage', package: const $pb.PackageName('extensions.api.cast_channel'))
    ..a<AuthChallenge>(1, 'challenge', $pb.PbFieldType.OM, AuthChallenge.getDefault, AuthChallenge.create)
    ..a<AuthResponse>(2, 'response', $pb.PbFieldType.OM, AuthResponse.getDefault, AuthResponse.create)
    ..a<AuthError>(3, 'error', $pb.PbFieldType.OM, AuthError.getDefault, AuthError.create)
  ;

  DeviceAuthMessage() : super();
  DeviceAuthMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeviceAuthMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeviceAuthMessage clone() => DeviceAuthMessage()..mergeFromMessage(this);
  DeviceAuthMessage copyWith(void Function(DeviceAuthMessage) updates) => super.copyWith((message) => updates(message as DeviceAuthMessage));
  $pb.BuilderInfo get info_ => _i;
  static DeviceAuthMessage create() => DeviceAuthMessage();
  DeviceAuthMessage createEmptyInstance() => create();
  static $pb.PbList<DeviceAuthMessage> createRepeated() => $pb.PbList<DeviceAuthMessage>();
  static DeviceAuthMessage getDefault() => _defaultInstance ??= create()..freeze();
  static DeviceAuthMessage _defaultInstance;

  AuthChallenge get challenge => $_getN(0);
  set challenge(AuthChallenge v) { setField(1, v); }
  $core.bool hasChallenge() => $_has(0);
  void clearChallenge() => clearField(1);

  AuthResponse get response => $_getN(1);
  set response(AuthResponse v) { setField(2, v); }
  $core.bool hasResponse() => $_has(1);
  void clearResponse() => clearField(2);

  AuthError get error => $_getN(2);
  set error(AuthError v) { setField(3, v); }
  $core.bool hasError() => $_has(2);
  void clearError() => clearField(3);
}

