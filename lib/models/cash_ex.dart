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
            String prior = key;
            if (scans.any((e) => e.any((i) => i.output.novus == prior))) {
              for (List<Scan> sc in scans.where((element) => element.any((i) => i.output.novus == prior))) {
                for (int i = 0; i < sc.length; i++) {
                  maschap[prior] = maschap[prior] ?? BigInt.zero + BigInt.one;
                  if (i == sc.length-1) {
                    prior = sc[i].output.prior;
                  }
                } 
              }
            } else {
             break;	
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
