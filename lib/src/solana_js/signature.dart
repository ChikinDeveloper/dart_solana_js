import 'package:json_annotation/json_annotation.dart';

part 'signature.g.dart';

@JsonSerializable(explicitToJson: true)
class SolanaJsSignature {
  SolanaJsSignature({
    required this.publicKey,
    required this.signature,
  });

  factory SolanaJsSignature.fromJson(Map<String, dynamic> json) =>
      _$SolanaJsSignatureFromJson(json);

  final String publicKey;
  final List<int> signature;

  Map<String, dynamic> toJson() => _$SolanaJsSignatureToJson(this);
}
