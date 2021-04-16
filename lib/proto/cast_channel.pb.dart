///
//  Generated code. Do not modify.
//  source: lib/proto/cast_channel.proto
//

// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'cast_channel.pbenum.dart';

export 'cast_channel.pbenum.dart';

class CastMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CastMessage', package: const $pb.PackageName('extensions.api.cast_channel'), createEmptyInstance: create)
    ..e<CastMessage_ProtocolVersion>(1, 'protocolVersion', $pb.PbFieldType.QE, defaultOrMaker: CastMessage_ProtocolVersion.CASTV2_1_0, valueOf: CastMessage_ProtocolVersion.valueOf, enumValues: CastMessage_ProtocolVersion.values)
    ..aQS(2, 'sourceId')
    ..aQS(3, 'destinationId')
    ..aQS(4, 'namespace')
    ..e<CastMessage_PayloadType>(5, 'payloadType', $pb.PbFieldType.QE, defaultOrMaker: CastMessage_PayloadType.STRING, valueOf: CastMessage_PayloadType.valueOf, enumValues: CastMessage_PayloadType.values)
    ..aOS(6, 'payloadUtf8')
    ..a<$core.List<$core.int>>(7, 'payloadBinary', $pb.PbFieldType.OY)
  ;

  CastMessage._() : super();
  factory CastMessage() => create();
  factory CastMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CastMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CastMessage clone() => CastMessage()..mergeFromMessage(this);
  CastMessage copyWith(void Function(CastMessage) updates) => super.copyWith((message) => updates(message as CastMessage)) as CastMessage;
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CastMessage create() => CastMessage._();
  CastMessage createEmptyInstance() => create();
  static $pb.PbList<CastMessage> createRepeated() => $pb.PbList<CastMessage>();
  @$core.pragma('dart2js:noInline')
  static CastMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CastMessage>(create);
  static CastMessage? _defaultInstance;

  @$pb.TagNumber(1)
  CastMessage_ProtocolVersion get protocolVersion => $_getN(0);
  @$pb.TagNumber(1)
  set protocolVersion(CastMessage_ProtocolVersion v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasProtocolVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearProtocolVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sourceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sourceId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSourceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSourceId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get destinationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set destinationId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDestinationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearDestinationId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get namespace => $_getSZ(3);
  @$pb.TagNumber(4)
  set namespace($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasNamespace() => $_has(3);
  @$pb.TagNumber(4)
  void clearNamespace() => clearField(4);

  @$pb.TagNumber(5)
  CastMessage_PayloadType get payloadType => $_getN(4);
  @$pb.TagNumber(5)
  set payloadType(CastMessage_PayloadType v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasPayloadType() => $_has(4);
  @$pb.TagNumber(5)
  void clearPayloadType() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get payloadUtf8 => $_getSZ(5);
  @$pb.TagNumber(6)
  set payloadUtf8($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPayloadUtf8() => $_has(5);
  @$pb.TagNumber(6)
  void clearPayloadUtf8() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<$core.int> get payloadBinary => $_getN(6);
  @$pb.TagNumber(7)
  set payloadBinary($core.List<$core.int> v) { $_setBytes(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasPayloadBinary() => $_has(6);
  @$pb.TagNumber(7)
  void clearPayloadBinary() => clearField(7);
}

class AuthChallenge extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AuthChallenge', package: const $pb.PackageName('extensions.api.cast_channel'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  AuthChallenge._() : super();
  factory AuthChallenge() => create();
  factory AuthChallenge.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthChallenge.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  AuthChallenge clone() => AuthChallenge()..mergeFromMessage(this);
  AuthChallenge copyWith(void Function(AuthChallenge) updates) => super.copyWith((message) => updates(message as AuthChallenge)) as AuthChallenge;
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AuthChallenge create() => AuthChallenge._();
  AuthChallenge createEmptyInstance() => create();
  static $pb.PbList<AuthChallenge> createRepeated() => $pb.PbList<AuthChallenge>();
  @$core.pragma('dart2js:noInline')
  static AuthChallenge getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthChallenge>(create);
  static AuthChallenge? _defaultInstance;
}

class AuthResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AuthResponse', package: const $pb.PackageName('extensions.api.cast_channel'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'signature', $pb.PbFieldType.QY)
    ..a<$core.List<$core.int>>(2, 'clientAuthCertificate', $pb.PbFieldType.QY)
    ..p<$core.List<$core.int>>(3, 'clientCa', $pb.PbFieldType.PY)
  ;

  AuthResponse._() : super();
  factory AuthResponse() => create();
  factory AuthResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  AuthResponse clone() => AuthResponse()..mergeFromMessage(this);
  AuthResponse copyWith(void Function(AuthResponse) updates) => super.copyWith((message) => updates(message as AuthResponse)) as AuthResponse;
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AuthResponse create() => AuthResponse._();
  AuthResponse createEmptyInstance() => create();
  static $pb.PbList<AuthResponse> createRepeated() => $pb.PbList<AuthResponse>();
  @$core.pragma('dart2js:noInline')
  static AuthResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthResponse>(create);
  static AuthResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get signature => $_getN(0);
  @$pb.TagNumber(1)
  set signature($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSignature() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignature() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get clientAuthCertificate => $_getN(1);
  @$pb.TagNumber(2)
  set clientAuthCertificate($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasClientAuthCertificate() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientAuthCertificate() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.List<$core.int>> get clientCa => $_getList(2);
}

class AuthError extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AuthError', package: const $pb.PackageName('extensions.api.cast_channel'), createEmptyInstance: create)
    ..e<AuthError_ErrorType>(1, 'errorType', $pb.PbFieldType.QE, defaultOrMaker: AuthError_ErrorType.INTERNAL_ERROR, valueOf: AuthError_ErrorType.valueOf, enumValues: AuthError_ErrorType.values)
  ;

  AuthError._() : super();
  factory AuthError() => create();
  factory AuthError.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthError.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  AuthError clone() => AuthError()..mergeFromMessage(this);
  AuthError copyWith(void Function(AuthError) updates) => super.copyWith((message) => updates(message as AuthError)) as AuthError;
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AuthError create() => AuthError._();
  AuthError createEmptyInstance() => create();
  static $pb.PbList<AuthError> createRepeated() => $pb.PbList<AuthError>();
  @$core.pragma('dart2js:noInline')
  static AuthError getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthError>(create);
  static AuthError? _defaultInstance;

  @$pb.TagNumber(1)
  AuthError_ErrorType get errorType => $_getN(0);
  @$pb.TagNumber(1)
  set errorType(AuthError_ErrorType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasErrorType() => $_has(0);
  @$pb.TagNumber(1)
  void clearErrorType() => clearField(1);
}

class DeviceAuthMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DeviceAuthMessage', package: const $pb.PackageName('extensions.api.cast_channel'), createEmptyInstance: create)
    ..aOM<AuthChallenge>(1, 'challenge', subBuilder: AuthChallenge.create)
    ..aOM<AuthResponse>(2, 'response', subBuilder: AuthResponse.create)
    ..aOM<AuthError>(3, 'error', subBuilder: AuthError.create)
  ;

  DeviceAuthMessage._() : super();
  factory DeviceAuthMessage() => create();
  factory DeviceAuthMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeviceAuthMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  DeviceAuthMessage clone() => DeviceAuthMessage()..mergeFromMessage(this);
  DeviceAuthMessage copyWith(void Function(DeviceAuthMessage) updates) => super.copyWith((message) => updates(message as DeviceAuthMessage)) as DeviceAuthMessage;
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeviceAuthMessage create() => DeviceAuthMessage._();
  DeviceAuthMessage createEmptyInstance() => create();
  static $pb.PbList<DeviceAuthMessage> createRepeated() => $pb.PbList<DeviceAuthMessage>();
  @$core.pragma('dart2js:noInline')
  static DeviceAuthMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceAuthMessage>(create);
  static DeviceAuthMessage? _defaultInstance;

  @$pb.TagNumber(1)
  AuthChallenge get challenge => $_getN(0);
  @$pb.TagNumber(1)
  set challenge(AuthChallenge v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasChallenge() => $_has(0);
  @$pb.TagNumber(1)
  void clearChallenge() => clearField(1);
  @$pb.TagNumber(1)
  AuthChallenge ensureChallenge() => $_ensure(0);

  @$pb.TagNumber(2)
  AuthResponse get response => $_getN(1);
  @$pb.TagNumber(2)
  set response(AuthResponse v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasResponse() => $_has(1);
  @$pb.TagNumber(2)
  void clearResponse() => clearField(2);
  @$pb.TagNumber(2)
  AuthResponse ensureResponse() => $_ensure(1);

  @$pb.TagNumber(3)
  AuthError get error => $_getN(2);
  @$pb.TagNumber(3)
  set error(AuthError v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => clearField(3);
  @$pb.TagNumber(3)
  AuthError ensureError() => $_ensure(2);
}

