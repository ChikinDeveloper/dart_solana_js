// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instruction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolanaJsTransactionInstruction _$SolanaJsTransactionInstructionFromJson(
        Map<String, dynamic> json) =>
    SolanaJsTransactionInstruction(
      programId: json['programId'] as String,
      keys: (json['keys'] as List<dynamic>)
          .map((e) => SolanaJsAccountMeta.fromJson(e as Map<String, dynamic>))
          .toList(),
      data: (json['data'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$SolanaJsTransactionInstructionToJson(
        SolanaJsTransactionInstruction instance) =>
    <String, dynamic>{
      'programId': instance.programId,
      'keys': instance.keys.map((e) => e.toJson()).toList(),
      'data': instance.data,
    };
