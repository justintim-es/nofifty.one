

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
  AnswerController(this.directory, this.p2p);
  @Operation.post()
  Future<Response> aschan(@Bind.body() Answer answer) async {
    // Map<int, int> indexes = Map();
    List<Obstructionum> oms = await Utils.getObstructionums(directory);
    // List<List<ScanInput?>> siss = [];
    // siss.addAll(oms.map((e) => e.interioreObstructionum.scans.map((e) => e.input).toList()).toList());
    // // for (int i = 0; i < siss.length; i++) {
    //   for (ScanInput? si in siss[i]) {
    //     occupied.add(si?.passphraseIndex);
    //   }
    //   List<ScanInput> occupied = [];
    //   occupied = siss[i].toSet();
    // }
    
    //how do you prevent them from indexing the update the one
    //the previous one could help 7you deciding what if they all had an array
    // how do i stop them from incrementing x manually 
    // they have to sign
    // for the blocknumbert we should amount of scans
    // in p2p moet dat gecheckt worden
    // for (int i = oms.length; i > 0; i--) {
    //   for (int ii = oms[i].interioreObstructionum.obstructionumNumerus.length; i > 0; i--) {

    //   }
    //   oms[i].interioreObstructionum.scans
    List<Obstructionum> obss = await Utils.getObstructionums(directory);
    List<Scan> scans = p2p.scans;
    
    // bool foundDubplicate = false;
    // for (int i = 0; i < scans.length; i++) {
    //   int prevIndex = i;
    //   for (int ii = 1; ii < scans.length; ii++)
    //     if (prevIndex == ii) {
    //       foundDubplicate = true;
    //       break;
    //     }
    //   break;
    // }
    if (scans.any((e) => e.input?.passphraseIndex == answer.index)) {
      return Response.badRequest(body: "index already included please scan again");
    }
    BigInt enim = BigInt.zero;
    for (Obstructionum obs in obss) {
      if(obs.interioreObstructionum.humanify != null) {
        enim += BigInt.one;
      }
    }
    if (BigInt.from(answer.index!) >= enim) {
      return Response.badRequest(body: "Index greater than max allowed index");
    } 
  
    // if(foundDubplicate == true) {
    //   return Response.badRequest(body: "found dubplicate max index");
    // }
    Scan scan = Scan(output: ScanOutput(prior: answer.prior!, novus: answer.novus!), input: ScanInput(passphraseIndex: answer.index!, passphrase: answer.hash!, probationem: answer.probationem!));
    p2p.scans.add(scan);
    return Response.ok(p2p.scans);
    // oms.map((e) => e.interioreObstructionum.scans).forEach(scans.addAll);
    // scans.addAll(p2p.scans);
    // if (scans.where((s) => s.input!.passphraseIndex == answer.index && s.input!.probationem == answer.probationem!).isNotEmpty) {
    //   return Response.badRequest(body: "Humanify already occupied please refresh");
    // } 
    // List<Obstructionum> obss = await Utils.getObstructionums(directory);
    //   if(scans.any((element) => element.input?.passphraseIndex == answer.index && element.input?.probationem == answer.probationem)) {
    //     return Response.badRequest(body: "Humanify already occupied please refresh");
    //   } 
    // for (Obstructionum obs in obss) {
    //   if (obs.interioreObstructionum.humanify?.probationem == answer.probationem) {
    //     if (!DBCrypt().checkpw(answer.hash!, obs.interioreObstructionum.humanify!.interiore.responderes[answer.index!])) {
    //       return Response.badRequest(body: "Invalid answer please retry");
    //     }
    //   }
    // }
    // p2p.scans.add(scan);
    // return Response.ok(scan);
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