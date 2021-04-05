///
//  Generated code. Do not modify.
//  source: lib/proto/cast_channel.proto
//

// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

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

const CastMessage_ProtocolVersion$json = const {
  '1': 'ProtocolVersion',
  '2': const [
    const {'1': 'CASTV2_1_0', '2': 0},
  ],
};

const CastMessage_PayloadType$json = const {
  '1': 'PayloadType',
  '2': const [
    const {'1': 'STRING', '2': 0},
    const {'1': 'BINARY', '2': 1},
  ],
};

const AuthChallenge$json = const {
  '1': 'AuthChallenge',
};

const AuthResponse$json = const {
  '1': 'AuthResponse',
  '2': const [
    const {'1': 'signature', '3': 1, '4': 2, '5': 12, '10': 'signature'},
    const {'1': 'client_auth_certificate', '3': 2, '4': 2, '5': 12, '10': 'clientAuthCertificate'},
    const {'1': 'client_ca', '3': 3, '4': 3, '5': 12, '10': 'clientCa'},
  ],
};

const AuthError$json = const {
  '1': 'AuthError',
  '2': const [
    const {'1': 'error_type', '3': 1, '4': 2, '5': 14, '6': '.extensions.api.cast_channel.AuthError.ErrorType', '10': 'errorType'},
  ],
  '4': const [AuthError_ErrorType$json],
};

const AuthError_ErrorType$json = const {
  '1': 'ErrorType',
  '2': const [
    const {'1': 'INTERNAL_ERROR', '2': 0},
    const {'1': 'NO_TLS', '2': 1},
  ],
};

const DeviceAuthMessage$json = const {
  '1': 'DeviceAuthMessage',
  '2': const [
    const {'1': 'challenge', '3': 1, '4': 1, '5': 11, '6': '.extensions.api.cast_channel.AuthChallenge', '10': 'challenge'},
    const {'1': 'response', '3': 2, '4': 1, '5': 11, '6': '.extensions.api.cast_channel.AuthResponse', '10': 'response'},
    const {'1': 'error', '3': 3, '4': 1, '5': 11, '6': '.extensions.api.cast_channel.AuthError', '10': 'error'},
  ],
};

