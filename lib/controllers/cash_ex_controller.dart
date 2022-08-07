
import 'dart:io';

import 'package:elliptic/elliptic.dart';
import 'package:nofiftyone/models/obstructionum.dart';
import 'package:nofiftyone/models/pera.dart';
import 'package:nofiftyone/models/scan.dart';
import 'package:nofiftyone/models/utils.dart';
import 'package:collection/collection.dart';
import 'package:nofiftyone/nofiftyone.dart';
import 'package:nofiftyone/models/errors.dart';

class CashExController extends ResourceController {
  Directory directory;
  CashExController(this.directory);

  @Operation.get('publica')
  Future<Response> balance(@Bind.path('publica') String publica) async {
    BigInt statera = await staschatescherascha(publica);
    return Response.ok(statera);
  }
  @Operation.post('privatus')
  Future<Response> ex(@Bind.path('privatus') String privatus) async {
    List<Obstructionum> los = await Utils.getObstructionums(directory);
    List<List<Scan>> llscans = los.map((e) => e.interioreObstructionum.scans).toList();
    List<Scan> lscans = [];
    llscans.forEach(lscans.addAll);
    int index = lscans.indexWhere((element) => element.output.prior == privatus);
    PrivateKey pk = PrivateKey.fromHex(Pera.curve(), privatus);
    String publica = pk.publicKey.toHex();
    BigInt redemptrici = await staschatescherascha(publica);
    BigInt minus = BigInt.one;
    BigInt redemp = BigInt.zero;
    for (int i = lscans.length; i > index; i--) {
      redemp += redemptrici - minus;
      minus += BigInt.one;
    }
    return Response.ok(redemp.toString());
  }
  Future<BigInt> staschatescherascha(String basis) async {
    List<Obstructionum> lo = await Utils.getObstructionums(directory);
    List<List<Scan>> llscanm = lo.map((e) => e.interioreObstructionum.scans).toList();
    Scan? scanBasis = llscanm.firstWhereOrNull((element) => element.any((a) => a.output.prior == basis))?[0];
    if (scanBasis == null) {
    	throw(Error(message: "publica clavem non lustrabat lumine adhuc", english: 'Public key is not scanned yet', code: 0));
    }

    List<String> novuses = [scanBasis.output.prior];
    List<String> todos = [];
    BigInt statera = BigInt.zero;
    while (true) {
    	todos = [];
    	print('novuses');
    	print(novuses);
      for(String novus in novuses) {
        llscanm.where((w) => w.any((a)=> a.output.prior == novus)).map((m) => m.map((im) => im.output.novus)).forEach((element) {
          todos.addAll(element);
          statera += BigInt.one;
        });		
      }
      if(todos.isEmpty) {
        break;
      }
      print('todos');
      print(todos);
      novuses = [];
      for (String todo in todos) {
        llscanm.where((w) => w.any((a) => a.output.prior == todo)).map((m) => m.map((im) => im.output.novus)).forEach((element) {
          novuses.addAll(element);
          statera += BigInt.one;
        });
      }
	  }
    return statera;
  }  
}
