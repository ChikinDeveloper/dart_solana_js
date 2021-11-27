import 'package:json_annotation/json_annotation.dart';

part 'account_meta.g.dart';

@JsonSerializable(explicitToJson: true)
class SolanaJsAccountMeta {
  SolanaJsAccountMeta({
    required this.pubkey,
    required this.isSigner,
    required this.isWritable,
  });

  factory SolanaJsAccountMeta.fromJson(Map<String, dynamic> json) =>
      _$SolanaJsAccountMetaFromJson(json);

  final String pubkey;
  bool isSigner;
  bool isWritable;

  SolanaJsAccountMeta copyWith({
    String? pubkey,
    bool? isSigner,
    bool? isWritable,
  }) =>
      SolanaJsAccountMeta(
        pubkey: pubkey ?? this.pubkey,
        isSigner: isSigner ?? this.isSigner,
        isWritable: isWritable ?? this.isWritable,
      );

  Map<String, dynamic> toJson() => _$SolanaJsAccountMetaToJson(this);
}
