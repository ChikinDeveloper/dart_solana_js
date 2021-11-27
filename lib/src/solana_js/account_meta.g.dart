// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolanaJsAccountMeta _$SolanaJsAccountMetaFromJson(Map<String, dynamic> json) =>
    SolanaJsAccountMeta(
      pubkey: json['pubkey'] as String,
      isSigner: json['isSigner'] as bool,
      isWritable: json['isWritable'] as bool,
    );

Map<String, dynamic> _$SolanaJsAccountMetaToJson(
        SolanaJsAccountMeta instance) =>
    <String, dynamic>{
      'pubkey': instance.pubkey,
      'isSigner': instance.isSigner,
      'isWritable': instance.isWritable,
    };
