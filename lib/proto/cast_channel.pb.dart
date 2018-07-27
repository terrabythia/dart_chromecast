///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library extensions.api.cast_channel_cast_channel;

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart';

import 'cast_channel.pbenum.dart';

export 'cast_channel.pbenum.dart';

class CastMessage extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CastMessage')
    ..e<CastMessage_ProtocolVersion>(1, 'protocolVersion', PbFieldType.QE, CastMessage_ProtocolVersion.CASTV2_1_0, CastMessage_ProtocolVersion.valueOf, CastMessage_ProtocolVersion.values)
    ..aQS(2, 'sourceId')
    ..aQS(3, 'destinationId')
    ..aQS(4, 'namespace')
    ..e<CastMessage_PayloadType>(5, 'payloadType', PbFieldType.QE, CastMessage_PayloadType.STRING, CastMessage_PayloadType.valueOf, CastMessage_PayloadType.values)
    ..aOS(6, 'payloadUtf8')
    ..a<List<int>>(7, 'payloadBinary', PbFieldType.OY)
    ..a<int>(8, 'noIdea', PbFieldType.O3, 0)
  ;

  CastMessage() : super();
  CastMessage.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CastMessage.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CastMessage clone() => new CastMessage()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CastMessage create() => new CastMessage();
  static PbList<CastMessage> createRepeated() => new PbList<CastMessage>();
  static CastMessage getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyCastMessage();
    return _defaultInstance;
  }
  static CastMessage _defaultInstance;
  static void $checkItem(CastMessage v) {
    if (v is! CastMessage) checkItemFailed(v, 'CastMessage');
  }

  CastMessage_ProtocolVersion get protocolVersion => $_getN(0);
  set protocolVersion(CastMessage_ProtocolVersion v) { setField(1, v); }
  bool hasProtocolVersion() => $_has(0);
  void clearProtocolVersion() => clearField(1);

  String get sourceId => $_getS(1, '');
  set sourceId(String v) { $_setString(1, v); }
  bool hasSourceId() => $_has(1);
  void clearSourceId() => clearField(2);

  String get destinationId => $_getS(2, '');
  set destinationId(String v) { $_setString(2, v); }
  bool hasDestinationId() => $_has(2);
  void clearDestinationId() => clearField(3);

  String get namespace => $_getS(3, '');
  set namespace(String v) { $_setString(3, v); }
  bool hasNamespace() => $_has(3);
  void clearNamespace() => clearField(4);

  CastMessage_PayloadType get payloadType => $_getN(4);
  set payloadType(CastMessage_PayloadType v) { setField(5, v); }
  bool hasPayloadType() => $_has(4);
  void clearPayloadType() => clearField(5);

  String get payloadUtf8 => $_getS(5, '');
  set payloadUtf8(String v) { $_setString(5, v); }
  bool hasPayloadUtf8() => $_has(5);
  void clearPayloadUtf8() => clearField(6);

  List<int> get payloadBinary => $_getN(6);
  set payloadBinary(List<int> v) { $_setBytes(6, v); }
  bool hasPayloadBinary() => $_has(6);
  void clearPayloadBinary() => clearField(7);

  int get noIdea => $_getN(8);
  set noIdea(int v) { setField(8, v); }
  bool hasNoIdea() => $_has(8);
  void clearNoIdea() => clearField(8);
}

class _ReadonlyCastMessage extends CastMessage with ReadonlyMessageMixin {}

class AuthChallenge extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('AuthChallenge')
    ..hasRequiredFields = false
  ;

  AuthChallenge() : super();
  AuthChallenge.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AuthChallenge.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AuthChallenge clone() => new AuthChallenge()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static AuthChallenge create() => new AuthChallenge();
  static PbList<AuthChallenge> createRepeated() => new PbList<AuthChallenge>();
  static AuthChallenge getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyAuthChallenge();
    return _defaultInstance;
  }
  static AuthChallenge _defaultInstance;
  static void $checkItem(AuthChallenge v) {
    if (v is! AuthChallenge) checkItemFailed(v, 'AuthChallenge');
  }
}

class _ReadonlyAuthChallenge extends AuthChallenge with ReadonlyMessageMixin {}

class AuthResponse extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('AuthResponse')
    ..a<List<int>>(1, 'signature', PbFieldType.QY)
    ..a<List<int>>(2, 'clientAuthCertificate', PbFieldType.QY)
    ..p<List<int>>(3, 'clientCa', PbFieldType.PY)
  ;

  AuthResponse() : super();
  AuthResponse.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AuthResponse.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AuthResponse clone() => new AuthResponse()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static AuthResponse create() => new AuthResponse();
  static PbList<AuthResponse> createRepeated() => new PbList<AuthResponse>();
  static AuthResponse getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyAuthResponse();
    return _defaultInstance;
  }
  static AuthResponse _defaultInstance;
  static void $checkItem(AuthResponse v) {
    if (v is! AuthResponse) checkItemFailed(v, 'AuthResponse');
  }

  List<int> get signature => $_getN(0);
  set signature(List<int> v) { $_setBytes(0, v); }
  bool hasSignature() => $_has(0);
  void clearSignature() => clearField(1);

  List<int> get clientAuthCertificate => $_getN(1);
  set clientAuthCertificate(List<int> v) { $_setBytes(1, v); }
  bool hasClientAuthCertificate() => $_has(1);
  void clearClientAuthCertificate() => clearField(2);

  List<List<int>> get clientCa => $_getList(2);
}

class _ReadonlyAuthResponse extends AuthResponse with ReadonlyMessageMixin {}

class AuthError extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('AuthError')
    ..e<AuthError_ErrorType>(1, 'errorType', PbFieldType.QE, AuthError_ErrorType.INTERNAL_ERROR, AuthError_ErrorType.valueOf, AuthError_ErrorType.values)
  ;

  AuthError() : super();
  AuthError.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AuthError.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AuthError clone() => new AuthError()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static AuthError create() => new AuthError();
  static PbList<AuthError> createRepeated() => new PbList<AuthError>();
  static AuthError getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyAuthError();
    return _defaultInstance;
  }
  static AuthError _defaultInstance;
  static void $checkItem(AuthError v) {
    if (v is! AuthError) checkItemFailed(v, 'AuthError');
  }

  AuthError_ErrorType get errorType => $_getN(0);
  set errorType(AuthError_ErrorType v) { setField(1, v); }
  bool hasErrorType() => $_has(0);
  void clearErrorType() => clearField(1);
}

class _ReadonlyAuthError extends AuthError with ReadonlyMessageMixin {}

class DeviceAuthMessage extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DeviceAuthMessage')
    ..a<AuthChallenge>(1, 'challenge', PbFieldType.OM, AuthChallenge.getDefault, AuthChallenge.create)
    ..a<AuthResponse>(2, 'response', PbFieldType.OM, AuthResponse.getDefault, AuthResponse.create)
    ..a<AuthError>(3, 'error', PbFieldType.OM, AuthError.getDefault, AuthError.create)
  ;

  DeviceAuthMessage() : super();
  DeviceAuthMessage.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeviceAuthMessage.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeviceAuthMessage clone() => new DeviceAuthMessage()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DeviceAuthMessage create() => new DeviceAuthMessage();
  static PbList<DeviceAuthMessage> createRepeated() => new PbList<DeviceAuthMessage>();
  static DeviceAuthMessage getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDeviceAuthMessage();
    return _defaultInstance;
  }
  static DeviceAuthMessage _defaultInstance;
  static void $checkItem(DeviceAuthMessage v) {
    if (v is! DeviceAuthMessage) checkItemFailed(v, 'DeviceAuthMessage');
  }

  AuthChallenge get challenge => $_getN(0);
  set challenge(AuthChallenge v) { setField(1, v); }
  bool hasChallenge() => $_has(0);
  void clearChallenge() => clearField(1);

  AuthResponse get response => $_getN(1);
  set response(AuthResponse v) { setField(2, v); }
  bool hasResponse() => $_has(1);
  void clearResponse() => clearField(2);

  AuthError get error => $_getN(2);
  set error(AuthError v) { setField(3, v); }
  bool hasError() => $_has(2);
  void clearError() => clearField(3);
}

class _ReadonlyDeviceAuthMessage extends DeviceAuthMessage with ReadonlyMessageMixin {}

