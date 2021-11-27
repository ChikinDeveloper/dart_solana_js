import 'package:solana/solana.dart' as solana;

import '../js/ffi.dart';
import 'account_meta.dart';
import 'find_program_address_response.dart';
import 'instruction.dart';
import 'signature.dart';
import 'transaction.dart';

abstract class SolanaJsUtils {
  static final js = JavascriptFFI();

  static Future<String> findProgramAddress({
    required List<List<int>> seeds,
    required String programId,
  }) async {
    if (isAvailable) {
      final solanaWeb3 = js.getProperty(js.getWindow(), 'solanaWeb3');
      final publicKeyClass = js.getProperty(solanaWeb3, 'PublicKey');
      final promise =
          js.callObjectMethod(publicKeyClass, 'findProgramAddress', [
        seeds,
        convertPublicKeyToJs(programId),
      ]);
      final future = js.promiseToFuture(promise);
      final result = await future;
      return FindProgramAddressResponse(
          convertPublicKeyFromJs(result[0]), result[1] as int).address;
    } else {
      final address =
          await solana.findProgramAddress(seeds: seeds, programId: programId);
      return address;
    }
  }

  static dynamic getSolanaWeb3() =>
      js.getProperty(js.getWindow(), 'solanaWeb3');

  // TODO Not exported by @solana/web3.js
  // static dynamic getBufferClass() {
  //   throw UnimplementedError();
  // }

  static dynamic getPublicKeyClass() =>
      js.getProperty(getSolanaWeb3(), 'PublicKey');

  static dynamic getTransactionClass() =>
      js.getProperty(getSolanaWeb3(), 'Transaction');

  static dynamic getTransactionInstructionClass() =>
      js.getProperty(getSolanaWeb3(), 'TransactionInstruction');

  static bool get isAvailable => js.isAvailable && getSolanaWeb3() != null;

  // Convert

  // - PublicKey

  static dynamic convertPublicKeyToJs(String publicKey) =>
      js.callConstructor(getPublicKeyClass(), [publicKey]);

  static String convertPublicKeyFromJs(dynamic publicKey) =>
      publicKey.toString();

  // - Buffer

  // TODO Implement it
  // static dynamic convertBufferToJs(List<int> buffer) {
  //   return js.callObjectMethod(getBufferClass(), 'from', [buffer]);
  // }

  static List<int> convertBufferFromJs(dynamic buffer) {
    final json = js.callObjectMethod(buffer, 'toJSON', []);
    return js.getProperty(json, 'data').map<int>((e) => e as int).toList();
  }

  // - TransactionInstruction

  static dynamic convertTransactionInstructionToJs(
      SolanaJsTransactionInstruction instruction) {
    final result = js.callConstructor(getTransactionInstructionClass(), [
      js.jsify({
        'programId': convertPublicKeyToJs(instruction.programId),
        'keys': js.jsify(instruction.keys
            .map((e) => {
                  'pubkey': convertPublicKeyToJs(e.pubkey),
                  'isSigner': e.isSigner,
                  'isWritable': e.isWritable,
                })
            .toList()),
        'data': js.jsify(instruction.data),
      }),
    ]);
    return result;
  }

  static SolanaJsTransactionInstruction convertTransactionInstructionFromJs(
      dynamic instruction) {
    final programId =
        convertPublicKeyFromJs(js.getProperty(instruction, 'programId'));
    final keys =
        js.getProperty(instruction, 'keys').map<SolanaJsAccountMeta>((e) {
      return SolanaJsAccountMeta(
        pubkey: convertPublicKeyFromJs(js.getProperty(e, 'pubkey')),
        isSigner: js.getProperty(e, 'isSigner'),
        isWritable: js.getProperty(e, 'isWritable'),
      );
    }).toList();
    final data =
        js.getProperty(instruction, 'data').map<int>((e) => e as int).toList();
    return SolanaJsTransactionInstruction(
      programId: programId,
      keys: keys,
      data: data,
    );
  }

  // - Transaction

  static dynamic convertTransactionToJs(SolanaJsTransaction transaction) {
    final result = js.callConstructor(getTransactionClass(), [
      js.jsify({
        'feePayer': convertPublicKeyToJs(transaction.feePayer),
        'recentBlockhash': transaction.recentBlockhash,
      }),
    ]);
    for (final instruction in transaction.instructions) {
      js.callObjectMethod(
          result, 'add', [convertTransactionInstructionToJs(instruction)]);
    }
    if (transaction.signatures?.isNotEmpty == true) {
      // TODO Implement it
      throw Exception('Cant serialize signature, add them after');
    }
    return result;
  }

  static SolanaJsTransaction convertTransactionFromJs(dynamic transaction) {
    final jsSignatures = js.getProperty(transaction, 'signatures');
    return SolanaJsTransaction(
      feePayer: convertPublicKeyFromJs(js.getProperty(transaction, 'feePayer')),
      recentBlockhash: js.getProperty(transaction, 'recentBlockhash'),
      instructions: js
          .getProperty(transaction, 'instructions')
          .map<SolanaJsTransactionInstruction>((e) {
        return convertTransactionInstructionFromJs(e);
      }).toList(),
      signatures: (jsSignatures == null)
          ? null
          : jsSignatures
              .where((e) => js.getProperty(e, 'signature') != null)
              .map<SolanaJsSignature>((e) {
              return SolanaJsSignature(
                publicKey:
                    convertPublicKeyFromJs(js.getProperty(e, 'publicKey')),
                signature: convertBufferFromJs(js.getProperty(e, 'signature')),
              );
            }).toList(),
    );
  }

  // Dev

  static void debugJsObject(Object object) {
    final js = JavascriptFFI();
    final keys = js.callObjectMethod(
        js.getProperty(js.getWindow(), 'Object'), 'keys', [object]);
    for (final key in keys) {
      print('debugObject : key=$key');
    }
  }
}
