

import 'dart:isolate';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:nofiftyone/models/answer.dart';
import 'package:nofiftyone/models/obstructionum.dart';
import 'package:nofiftyone/models/scan.dart';
import 'package:nofiftyone/models/utils.dart';
import 'package:nofiftyone/nofiftyone.dart';
import 'package:nofiftyone/p2p.dart';

class AnswerController extends ResourceController {
  Directory directory;
  P2P p2p;
  Map<String, Isolate> answerIsolates;
  AnswerController(this.directory, this.p2p, this.answerIsolates);
  @Operation.post()
  Future<Response> aschan(@Bind.body() Answer answer) async {
    List<Obstructionum> oms = await Utils.getObstructionums(directory);
    List<Obstructionum> obss = await Utils.getObstructionums(directory);
    List<Scan> scans = p2p.scans;
    if (scans.any((e) => e.interioreScan.humanifyAnswer?.passphraseIndex == answer.index)) {
      return Response.badRequest(body: "index already included please scan again");
    }
    BigInt enim = BigInt.zero;
    for (Obstructionum obs in obss) {
      if(obs.interioreObstructionum.humanify != null) {
        enim += BigInt.one;
      }
    }
    if (BigInt.from(answer.index!) > enim) {
      return Response.badRequest(body: "Index greater than max allowed index");
    }
    final ReceivePort acciperePortus = ReceivePort();
    final interiore = InterioreScan(
      output: ScanOutput(prior: answer.prior!, novus: answer.novus!), 
      humanifyAnswer: HumanifyAnswer(passphraseIndex: answer.index!, passphrase: answer.hash!, probationem: answer.probationem!)
    );
    answerIsolates[interiore.id] = await Isolate.spawn(Scan.quaestum, List<dynamic>.from([interiore, acciperePortus.sendPort]));
    acciperePortus.listen((data) {
      p2p.syncScan(data as Scan);
    });
    return Response.ok("");
  }
  @Operation.get()
  Future<Response> pool() async {
    return Response.ok(p2p.scans);
  }
  @Operation.get('id')
  Future<Response> status(@Bind.path('id') String id ) async {
    return Response.ok("");
  }
}
