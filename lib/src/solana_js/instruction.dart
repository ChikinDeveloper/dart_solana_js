import 'package:json_annotation/json_annotation.dart';

import 'account_meta.dart';

part 'instruction.g.dart';

@JsonSerializable(explicitToJson: true)
class SolanaJsTransactionInstruction {
  SolanaJsTransactionInstruction({
    required this.programId,
    required this.keys,
    required this.data,
  });

  factory SolanaJsTransactionInstruction.fromJson(Map<String, dynamic> json) =>
      _$SolanaJsTransactionInstructionFromJson(json);

  final String programId;
  final List<SolanaJsAccountMeta> keys;
  final List<int> data;

  Map<String, dynamic> toJson() => _$SolanaJsTransactionInstructionToJson(this);
}
