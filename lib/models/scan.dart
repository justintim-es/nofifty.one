
import 'dart:convert';

import 'package:elliptic/elliptic.dart';
import 'package:hex/hex.dart';
import 'package:dbcrypt/dbcrypt.dart';

class ScanOutput {
  String prior;
  String novus;
  ScanOutput({ required this.prior, required this.novus });
  Map<String, dynamic> toJson() => {
    'prior': prior,
    'novus': novus
  };
  ScanOutput.fromJson(Map<String, dynamic> map):
    prior = map['prior'].toString(),
    novus = map['novus'].toString();
}
class ScanInput {
  int passphraseIndex;
  String passphrase;
  String probationem;
  ScanInput({ required this.passphraseIndex, required this.passphrase, required this.probationem });
  Map<String, dynamic> toJson() => {
    'passphraseIndex': passphraseIndex,
    'passphrase': passphrase,
    'probationem': probationem
  };
  ScanInput.fromJson(Map<String, dynamic> map):
    passphraseIndex = int.parse(map['passphraseIndex'].toString()),
    passphrase = map['passphrase'].toString(),
    probationem = map['probationem'].toString();
}

class Scan {
  ScanOutput output;
  ScanInput? input;
  Scan({ required this.output, this.input });
  Map<String, dynamic> toJson() => {
    'output': output.toJson(),
    'input': input?.toJson(),
  };
  Scan.fromJson(Map<String, dynamic> map):
    output = ScanOutput.fromJson(map['output'] as Map<String, dynamic>),
    input = map['input'] != null ?  ScanInput.fromJson(map['input'] as Map<String, dynamic>) : null;
}
// class Scan {
//   InterioreScan? prior;
// -  Scan({ required this.prior, required this.novus });
//   Map<String, dynamic> toJson() => {
//      'prior': prior?.toJson(),
//      'novus': novus.toJson()
//   };
//   Scan.fromJson(Map<String, dynamic> jsoschon):
//     prior = jsoschon['prior'] != null ?  InterioreScan.fromJson(jsoschon['prior'] as Map<String, dynamic>) : null,
//     novus = InterioreScan.fromJson(jsoschon['novus'] as Map<String, dynamic>);
// }
