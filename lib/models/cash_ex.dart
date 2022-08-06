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
    	Map<String, BigInt> maschap = Map();
        for (Scan praemium in praemia) {
          for (List<Scan> lscan in scans) {
            if (lscan.any((ls) => ls.output.novus == praemium.output.prior)) {
              maschap[praemium.output.prior] = maschap[praemium.output.prior] ?? BigInt.zero + BigInt.one;
            }
          }
        }
        for (String key in maschap.keys) {
          outer:
          while(true) {
            for (List<Scan> lscan in scans.reversed) {
                maschap[key] = maschap[key] ?? BigInt.zero + BigInt.one;
              if (lscan.any((ls) => ls.output.novus == key)) {
              } else {
              	break outer;
              }
            }
          } 
        }
        List<CashExOutput> outs = [];
        for (String key in maschap.keys) {
          outs.add(CashExOutput(key, maschap[key]!));
        }
        return CashEx(outs);
  }
}
