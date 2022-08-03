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
    List<List<ScanInput?>> inputs = [];
    for (List<Scan> scaschans in scans) {
      inputs.add(scaschans.map((e) => e.input).toList());
    }
    for (int i = inputs.length; i > 0; i--) {
      if (inputs[i].where((ischin) => ischin?.probationem == humanifies[i]?.probationem).isEmpty) {
        return Response.ok({
          "probationem": humanifies[i]?.probationem,
          "index": inputs[i].length
        });
      }
    }
    return Response.ok({
      "probationem": humanifies.first?.probationem,
      "index": 0
    });
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