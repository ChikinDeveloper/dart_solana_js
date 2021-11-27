// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signature.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolanaJsSignature _$SolanaJsSignatureFromJson(Map<String, dynamic> json) =>
    SolanaJsSignature(
      publicKey: json['publicKey'] as String,
      signature:
          (json['signature'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$SolanaJsSignatureToJson(SolanaJsSignature instance) =>
    <String, dynamic>{
      'publicKey': instance.publicKey,
      'signature': instance.signature,
    };
