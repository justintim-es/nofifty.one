import 'dart:isolate';





class InteriorePublica {
  int nonce;
  String publica;
  InteriorePublica(this.nonce, this.publica);


  Map<String, dynamic> toJson() => {
    'nonce': nonce,
    'publica': publica
  };
  InteriorePublica.fromJson(Map<String, dynamic> jsoschon):
    nonce = int.parse(jsoschon['nonce'].toString()),
    publica = jsoschon['publica'].toString();
}
class Publica {
  late String probationem;
  Publica publica;
  Publica(this.publica);
  
  // static void quaestum(List<dynamic> argumentis) {
  //   InteriorePublica interioreRationem = argumentis[0] as InteriorePublica;
  //   SendPort mitte = argumentis[1] as SendPort;
  //   String probationem = '';
  //   int zeros = 1;
  //   while (true) {
  //     do {
  //       interioreRationem.mine();
  //       probationem = HEX.encode(sha256.convert(utf8.encode(json.encode(interioreRationem.toJson()))).bytes);
  //     } while(!probationem.startsWith('0' * zeros));
  //     zeros += 1;
  //     mitte.send(Propter(probationem, interioreRationem));
  //   }
  // }
}