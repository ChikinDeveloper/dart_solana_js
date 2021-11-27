// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolanaJsTransaction _$SolanaJsTransactionFromJson(Map<String, dynamic> json) =>
    SolanaJsTransaction(
      feePayer: json['feePayer'] as String,
      recentBlockhash: json['recentBlockhash'] as String,
      signatures: (json['signatures'] as List<dynamic>?)
          ?.map((e) => SolanaJsSignature.fromJson(e as Map<String, dynamic>))
          .toList(),
      instructions: (json['instructions'] as List<dynamic>)
          .map((e) => SolanaJsTransactionInstruction.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SolanaJsTransactionToJson(
        SolanaJsTransaction instance) =>
    <String, dynamic>{
      'feePayer': instance.feePayer,
      'recentBlockhash': instance.recentBlockhash,
      'signatures': instance.signatures?.map((e) => e.toJson()).toList(),
      'instructions': instance.instructions.map((e) => e.toJson()).toList(),
    };
