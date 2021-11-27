import 'package:cryptography/cryptography.dart' as crypto;
import 'package:json_annotation/json_annotation.dart';
import 'package:solana/solana.dart';

import 'account_meta.dart';
import 'instruction.dart';
import 'signature.dart';

part 'transaction.g.dart';

@JsonSerializable(explicitToJson: true)
class SolanaJsTransaction {
  SolanaJsTransaction({
    required this.feePayer,
    required this.recentBlockhash,
    this.signatures,
    required this.instructions,
  });

  factory SolanaJsTransaction.fromMessage({
    required Message message,
    required String recentBlockhash,
    String? feePayer,
  }) {
    final accounts =
        message.instructions.getAccountsWithOptionalFeePayer(feePayer);
    return SolanaJsTransaction(
      feePayer: feePayer ?? accounts.first.pubKey,
      recentBlockhash: recentBlockhash,
      instructions: message.instructions
          .map((instruction) => SolanaJsTransactionInstruction(
                programId: instruction.programId,
                keys: instruction.accounts
                    .map((e) => SolanaJsAccountMeta(
                          pubkey: e.pubKey,
                          isSigner: e.isSigner,
                          isWritable: e.isWriteable,
                        ))
                    .toList(),
                data: instruction.data.toList(),
              ))
          .toList(),
    );
  }

  factory SolanaJsTransaction.fromJson(Map<String, dynamic> json) =>
      _$SolanaJsTransactionFromJson(json);

  final String feePayer;
  final String recentBlockhash;
  final List<SolanaJsSignature>? signatures;
  final List<SolanaJsTransactionInstruction> instructions;

  SolanaJsTransaction copy({List<SolanaJsSignature>? addSignatures}) {
    final signatures = <SolanaJsSignature>[];
    if (this.signatures != null) signatures.addAll(this.signatures!);
    if (addSignatures != null) signatures.addAll(addSignatures);
    return SolanaJsTransaction(
      feePayer: feePayer,
      recentBlockhash: recentBlockhash,
      signatures: signatures,
      instructions: instructions,
    );
  }

  Message toMessage() => Message(
        instructions: instructions
            .map((instruction) => Instruction(
                  programId: instruction.programId,
                  accounts: instruction.keys.map((e) {
                    if (e.isWritable) {
                      return AccountMeta.writeable(
                          pubKey: e.pubkey, isSigner: e.isSigner);
                    } else {
                      return AccountMeta.readonly(
                          pubKey: e.pubkey, isSigner: e.isSigner);
                    }
                  }).toList(),
                  data: instruction.data,
                ))
            .toList(),
      );

  Future<SignedTx> toSignedTx({
    List<Ed25519HDKeyPair>? addSignatures,
  }) async {
    final message = toMessage();
    final messageBytes =
        message.compile(feePayer: feePayer, recentBlockhash: recentBlockhash);
    final accounts =
        message.instructions.getAccountsWithOptionalFeePayer(feePayer);
    final signers = accounts.where((e) => e.isSigner).toList();
    final resultSignatures = <Signature>[];
    for (final signer in signers) {
      Signature? foundSignature;
      // Try with stored signatures
      for (final e in (signatures ?? <SolanaJsSignature>[])) {
        if (e.publicKey == signer.pubKey) {
          foundSignature = Signature.from(crypto.Signature(
            e.signature,
            publicKey: crypto.SimplePublicKey(
              base58decode(e.publicKey),
              type: crypto.KeyPairType.ed25519,
            ),
          ));
        }
      }
      // Try with addSignatures
      if (foundSignature == null) {
        for (final e in (addSignatures ?? <Ed25519HDKeyPair>[])) {
          if (e.address == signer.pubKey) {
            resultSignatures.add(await e.sign(messageBytes.data));
          }
        }
      }
      // Result
      if (foundSignature == null) {
        throw Exception('Signature not found ${signer.pubKey}');
      } else {
        resultSignatures.add(foundSignature);
      }
    }
    return SignedTx(
        signatures: resultSignatures, messageBytes: messageBytes.data);
  }

  Map<String, dynamic> toJson() => _$SolanaJsTransactionToJson(this);
}
