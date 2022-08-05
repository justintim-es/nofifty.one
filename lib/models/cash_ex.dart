import 'package:nofiftyone/models/scan.dart';

class CashExOutput {
  String publicKey;
  BigInt value;
  CashExOutput(this.publicKey, this.value);

  Map<String, dynamic> toJson() => {
    'publicKey': publicKey,
    'value': value.toString()
  };
  CashExOutput.fromJson(Map<String, dynamic> jsoschon):
    publicKey = jsoschon['publicKey'].toString(),
    value = BigInt.parse(jsoschon['value'].toString());
}
class CaschExInput {}

class CashEx {
  List<CashExOutput> outputs;
  CashEx(this.outputs);

  Map<String, dynamic> toJson() => {
    'outputs': outputs.map((e) => e.toJson()).toList()
  };
  CashEx.fromJson(Map<String, dynamic> jsoschon):
    outputs = List<CashExOutput>.from(jsoschon['outputs'].map((o) => CashExOutput.fromJson(o as Map<String, dynamic>)) as Iterable<dynamic>);

  factory CashEx.count(List<int> numerus, List<Scan> praemia,  List<List<Scan>> scans) {
    // List<List<Scan>> llscans = [];
    // for(Scan praemium in praemia) {
    //   for (int b = numerus.length-1; b >= 0; b--) {
    //     for (int bb = numerus[b]; bb >= 0; bb--) {
    //       llscans.add(scans.where((element) => element.output.prior == praemium.output.novus).toList());
    //     }
    //   }
    // }
    List<CashExOutput> outs = [];
    for (Scan praemium in praemia) {
      for (List<Scan> lscan in scans.where((element) => element.isNotEmpty)) {
      while(lscan.any((ls) => ls.output.novus == praemium.output.prior)) {
        for (Scan ss in lscan.where((s) => s.output.novus == praemium.output.prior)) {
          outs.add(CashExOutput(ss.output.prior, BigInt.one));
        }
      }
    }

    // List<String> publics = [];
    // List<List<Scan>> llscans = [];
    // for (Scan praemium in praemia) {
    //   scans.forEach((element) => llscans.add(element.where((element) =>  element.output.prior == praemium.output.novus).toList()));
    //   publics.add(praemium.output.prior);
    // }
    // List<List<Scan>> lliscans = [];
    // for (int i = 0; i < llscans.length; i++) {
    //   for (int ii = 0 ; ii < llscans[i].length; ii ++) {
    //     scans.forEach((element) => lliscans.add(element.where((eschel) => llscans[i][ii].output.prior == eschel.output.novus).toList()));
    //   }
    // }
    // List<CashExOutput> outputs = [];
    // for (int i = 0; i < publics.length && i < lliscans.length; i++) {
    //   outputs.add(CashExOutput(publics[i], BigInt.from(lliscans[i].length)));
    // }
    return CashEx(outs);
  }
}