
import 'dart:io';
import 'dart:isolate';

import 'package:elliptic/elliptic.dart';
import 'package:nofiftyone/models/cash_ex.dart';
import 'package:nofiftyone/models/obstructionum.dart';
import 'package:nofiftyone/models/pera.dart';
import 'package:nofiftyone/models/scan.dart';
import 'package:nofiftyone/models/utils.dart';
import 'package:collection/collection.dart';
import 'package:nofiftyone/nofiftyone.dart';
import 'package:nofiftyone/models/errors.dart';
import 'package:nofiftyone/p2p.dart';

class CashExController extends ResourceController {
  Directory directory;
  P2P p2p;
  Map<String, Isolate> cashExIsolates;
  CashExController(this.directory, this.p2p, this.cashExIsolates);

  @Operation.get('key')
  Future<Response> balance(@Bind.path('key') String publica) async {
    List<Obstructionum> lobstructionum = await Utils.getObstructionums(directory);
    List<List<CashEx>> llcashex = lobstructionum.map((e) => e.interioreObstructionum.cashExs).toList();
    BigInt statera = await staschatescherascha(publica);
    List<List<BigInt>> exs = 
    llcashex.where((w) => w.any((a) => a.interioreCashEx.signumCashEx.public == publica))
    .map((m) => m.map((im) => im.interioreCashEx.signumCashEx.nof).toList()).toList();
    List<BigInt> exss = [];
    exs.forEach(exss.addAll);
    for (BigInt ex in exss) {
      statera -= ex;
    }
    return Response.ok(statera);

  }
  @Operation.post('key')
  Future<Response> ex(@Bind.path('key') String privatus) async {
    final PrivateKey pk = PrivateKey.fromHex(Pera.curve(), privatus);
    final String publicKey = pk.publicKey.toHex();
    final List<Obstructionum> lobstructionum = await Utils.getObstructionums(directory);
    List<List<CashEx>> llcashex = lobstructionum.map((e) => e.interioreObstructionum.cashExs).toList();
    BigInt statera = await staschatescherascha(publicKey);
    final List<List<BigInt>> exs = 
    llcashex.where((w) => w.any((a) => a.interioreCashEx.signumCashEx.public == publicKey))
    .map((m) => m.map((im) => im.interioreCashEx.signumCashEx.nof).toList()).toList();
    final List<BigInt> exss = [];
    exs.forEach(exss.addAll);
    for (BigInt ex in exss) {
      statera -= ex;
    }
    final signumCashEx = SignumCashEx(nof: statera, public: publicKey, nonce: BigInt.zero);
    InterioreCashEx interiore = InterioreCashEx(signumCashEx: signumCashEx, signature: Utils.signum(pk, signumCashEx));
    ReceivePort acciperePortus = ReceivePort();
    cashExIsolates[interiore.signumCashEx.id] = await Isolate.spawn(CashEx.quaestum, List<dynamic>.from([interiore, acciperePortus.sendPort]));
    acciperePortus.listen((data) {
      p2p.syncCashEx(data as CashEx);
    });
    return Response.ok({
      "statera": statera
    });
  }
  Future<BigInt> staschatescherascha(String basis) async {
    List<Obstructionum> lo = await Utils.getObstructionums(directory);
    List<List<Scan>> llscanm = lo.map((e) => e.interioreObstructionum.scans).toList();
    Scan? scanBasis = llscanm.firstWhereOrNull((element) => element.any((a) => a.interioreScan.output.prior == basis))?[0];
    if (scanBasis == null) {
    	throw(Error(message: "publica clavem non lustrabat lumine adhuc", english: 'Public key is not scanned yet', code: 0));
    }

    List<String> novuses = [scanBasis.interioreScan.output.prior];
    List<String> todos = [];
    BigInt statera = BigInt.zero;
    while (true) {
    	todos = [];
    	print('novuses');
    	print(novuses);
      for(String novus in novuses) {
        llscanm.where((w) => w.any((a)=> a.interioreScan.output.prior == novus)).map((m) => m.map((im) => im.interioreScan.output.novus)).forEach((element) {
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
        llscanm.where((w) => w.any((a) => a.interioreScan.output.prior == todo)).map((m) => m.map((im) => im.interioreScan.output.novus)).forEach((element) {
          novuses.addAll(element);
          statera += BigInt.one;
        });
      }
	  }
    return statera;
  }  
}
