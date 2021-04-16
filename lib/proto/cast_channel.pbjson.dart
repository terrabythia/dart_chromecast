///
//  Generated code. Do not modify.
//  source: cast_channel.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use castMessageDescriptor instead')
const CastMessage$json = const {
  '1': 'CastMessage',
  '2': const [
    const {'1': 'protocol_version', '3': 1, '4': 2, '5': 14, '6': '.extensions.api.cast_channel.CastMessage.ProtocolVersion', '10': 'protocolVersion'},
    const {'1': 'source_id', '3': 2, '4': 2, '5': 9, '10': 'sourceId'},
    const {'1': 'destination_id', '3': 3, '4': 2, '5': 9, '10': 'destinationId'},
    const {'1': 'namespace', '3': 4, '4': 2, '5': 9, '10': 'namespace'},
    const {'1': 'payload_type', '3': 5, '4': 2, '5': 14, '6': '.extensions.api.cast_channel.CastMessage.PayloadType', '10': 'payloadType'},
    const {'1': 'payload_utf8', '3': 6, '4': 1, '5': 9, '10': 'payloadUtf8'},
    const {'1': 'payload_binary', '3': 7, '4': 1, '5': 12, '10': 'payloadBinary'},
  ],
  '4': const [CastMessage_ProtocolVersion$json, CastMessage_PayloadType$json],
};

@$core.Deprecated('Use castMessageDescriptor instead')
const CastMessage_ProtocolVersion$json = const {
  '1': 'ProtocolVersion',
  '2': const [
    const {'1': 'CASTV2_1_0', '2': 0},
  ],
};

@$core.Deprecated('Use castMessageDescriptor instead')
const CastMessage_PayloadType$json = const {
  '1': 'PayloadType',
  '2': const [
    const {'1': 'STRING', '2': 0},
    const {'1': 'BINARY', '2': 1},
  ],
};

/// Descriptor for `CastMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List castMessageDescriptor = $convert.base64Decode('CgtDYXN0TWVzc2FnZRJjChBwcm90b2NvbF92ZXJzaW9uGAEgAigOMjguZXh0ZW5zaW9ucy5hcGkuY2FzdF9jaGFubmVsLkNhc3RNZXNzYWdlLlByb3RvY29sVmVyc2lvblIPcHJvdG9jb2xWZXJzaW9uEhsKCXNvdXJjZV9pZBgCIAIoCVIIc291cmNlSWQSJQoOZGVzdGluYXRpb25faWQYAyACKAlSDWRlc3RpbmF0aW9uSWQSHAoJbmFtZXNwYWNlGAQgAigJUgluYW1lc3BhY2USVwoMcGF5bG9hZF90eXBlGAUgAigOMjQuZXh0ZW5zaW9ucy5hcGkuY2FzdF9jaGFubmVsLkNhc3RNZXNzYWdlLlBheWxvYWRUeXBlUgtwYXlsb2FkVHlwZRIhCgxwYXlsb2FkX3V0ZjgYBiABKAlSC3BheWxvYWRVdGY4EiUKDnBheWxvYWRfYmluYXJ5GAcgASgMUg1wYXlsb2FkQmluYXJ5IiEKD1Byb3RvY29sVmVyc2lvbhIOCgpDQVNUVjJfMV8wEAAiJQoLUGF5bG9hZFR5cGUSCgoGU1RSSU5HEAASCgoGQklOQVJZEAE=');
@$core.Deprecated('Use authChallengeDescriptor instead')
const AuthChallenge$json = const {
  '1': 'AuthChallenge',
};

/// Descriptor for `AuthChallenge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authChallengeDescriptor = $convert.base64Decode('Cg1BdXRoQ2hhbGxlbmdl');
@$core.Deprecated('Use authResponseDescriptor instead')
const AuthResponse$json = const {
  '1': 'AuthResponse',
  '2': const [
    const {'1': 'signature', '3': 1, '4': 2, '5': 12, '10': 'signature'},
    const {'1': 'client_auth_certificate', '3': 2, '4': 2, '5': 12, '10': 'clientAuthCertificate'},
    const {'1': 'client_ca', '3': 3, '4': 3, '5': 12, '10': 'clientCa'},
  ],
};

/// Descriptor for `AuthResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authResponseDescriptor = $convert.base64Decode('CgxBdXRoUmVzcG9uc2USHAoJc2lnbmF0dXJlGAEgAigMUglzaWduYXR1cmUSNgoXY2xpZW50X2F1dGhfY2VydGlmaWNhdGUYAiACKAxSFWNsaWVudEF1dGhDZXJ0aWZpY2F0ZRIbCgljbGllbnRfY2EYAyADKAxSCGNsaWVudENh');
@$core.Deprecated('Use authErrorDescriptor instead')
const AuthError$json = const {
  '1': 'AuthError',
  '2': const [
    const {'1': 'error_type', '3': 1, '4': 2, '5': 14, '6': '.extensions.api.cast_channel.AuthError.ErrorType', '10': 'errorType'},
  ],
  '4': const [AuthError_ErrorType$json],
};

@$core.Deprecated('Use authErrorDescriptor instead')
const AuthError_ErrorType$json = const {
  '1': 'ErrorType',
  '2': const [
    const {'1': 'INTERNAL_ERROR', '2': 0},
    const {'1': 'NO_TLS', '2': 1},
  ],
};

/// Descriptor for `AuthError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authErrorDescriptor = $convert.base64Decode('CglBdXRoRXJyb3ISTwoKZXJyb3JfdHlwZRgBIAIoDjIwLmV4dGVuc2lvbnMuYXBpLmNhc3RfY2hhbm5lbC5BdXRoRXJyb3IuRXJyb3JUeXBlUgllcnJvclR5cGUiKwoJRXJyb3JUeXBlEhIKDklOVEVSTkFMX0VSUk9SEAASCgoGTk9fVExTEAE=');
@$core.Deprecated('Use deviceAuthMessageDescriptor instead')
const DeviceAuthMessage$json = const {
  '1': 'DeviceAuthMessage',
  '2': const [
    const {'1': 'challenge', '3': 1, '4': 1, '5': 11, '6': '.extensions.api.cast_channel.AuthChallenge', '10': 'challenge'},
    const {'1': 'response', '3': 2, '4': 1, '5': 11, '6': '.extensions.api.cast_channel.AuthResponse', '10': 'response'},
    const {'1': 'error', '3': 3, '4': 1, '5': 11, '6': '.extensions.api.cast_channel.AuthError', '10': 'error'},
  ],
};

/// Descriptor for `DeviceAuthMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceAuthMessageDescriptor = $convert.base64Decode('ChFEZXZpY2VBdXRoTWVzc2FnZRJICgljaGFsbGVuZ2UYASABKAsyKi5leHRlbnNpb25zLmFwaS5jYXN0X2NoYW5uZWwuQXV0aENoYWxsZW5nZVIJY2hhbGxlbmdlEkUKCHJlc3BvbnNlGAIgASgLMikuZXh0ZW5zaW9ucy5hcGkuY2FzdF9jaGFubmVsLkF1dGhSZXNwb25zZVIIcmVzcG9uc2USPAoFZXJyb3IYAyABKAsyJi5leHRlbnNpb25zLmFwaS5jYXN0X2NoYW5uZWwuQXV0aEVycm9yUgVlcnJvcg==');
