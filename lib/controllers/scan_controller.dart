import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:elliptic/elliptic.dart';
import 'package:hex/hex.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:nofiftyone/models/humanify.dart';
import 'package:nofiftyone/models/obstructionum.dart';
import 'package:nofiftyone/models/pera.dart';
import 'package:nofiftyone/models/scan.dart';
import 'package:nofiftyone/models/utils.dart';
import 'package:nofiftyone/p2p.dart';
import 'package:dbcrypt/dbcrypt.dart';
class ScanController extends ResourceController {
  Directory directory;
  P2P p2p;
  ScanController(this.directory, this.p2p) {
    acceptedContentTypes = [ContentType("multipart", "form-data")];
  }
  
  @Operation.get()
  Future<Response> hash() async {
    List<List<Scan>> scans = [];
    List<Obstructionum> obss = await Utils.getObstructionums(directory);
    List<Humanify?> humanifies = [];
    for (Obstructionum obs in obss) {
      scans.add(obs.interioreObstructionum.scans);
      humanifies.add(obs.interioreObstructionum.humanify);
    }
    // all we have to count down is the last humanify
    List<ScanInput?> inputs = [];
    for (List<Scan> scaschans in scans) {
      // inputs.addAll(scaschans.map((e) => e.input));
      //be ware we need imputs when whe have to give the passphrase index
      inputs.addAll(p2p.scans.map((s) => s.input));
    }
    int index = humanifies.lastIndexWhere((element) => !inputs.any((i) => i?.probationem == element?.probationem) && element != null);
    
    return Response.ok({
      "probationem": humanifies[index]!.probationem,
      "index": index
    });
    // List<List<ScanInput?>> inputs = [];
    // for (List<Scan> scaschans in scans) {
    //   inputs.add(scaschans.map((e) => e.input).toList());
    // }
    
    // Humanify? humanify = humanifies.lastWhere((element) => !inputs.any((e) => e.any((ee) => ee?.probationem == element?.probationem)));
    // return Response.ok({
    //   "probationem": rst?.probationem,
    //   "index": 0
    // });
 }
  @Operation.get('probationem')
  Future<Response> image(@Bind.path('probationem') String probationem) async {
    List<Obstructionum> obss = await Utils.getObstructionums(directory);
    for (Obstructionum obs in obss) {
      if(obs.interioreObstructionum.humanify?.probationem == probationem) {
        return Response.ok(HEX.decode(obs.interioreObstructionum.humanify!.interiore.img!))..contentType = ContentType("image", "jpeg");
      }
    }
    return Response.badRequest(body: "no image found for probationem");
  }
}