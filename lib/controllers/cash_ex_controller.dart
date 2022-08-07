
import 'dart:io';

import 'package:nofiftyone/models/obstructionum.dart';
import 'package:nofiftyone/models/scan.dart';
import 'package:nofiftyone/models/utils.dart';
import 'package:nofiftyone/nofiftyone.dart';

class CashExController extends ResourceController {
  Directory directory;
  CashExController(this.directory);

  @Operation.get('publica')
  Future<Response> balance(@Bind.path('publica') String publica) async {
    List<Obstructionum> lo = await Utils.getObstructionums(directory);
    List<List<Scan>> llscanm = lo.map((e) => e.interioreObstructionum.scans).toList();
    List<List<Scan>> llscanwa = llscanm.where((element) => element.any((a) => a.output.prior == publica)).toList(); 
    List<String> novuses = [];
    List<Scan> ex = [];
    while(true) {
      llscanwa.map((m) => m.map((e) => e.output.novus)).forEach(novuses.addAll);
      ex = [];
      llscanm.where((w) => w.any((a) => novuses.contains(a.output.prior))).forEach(ex.addAll);
      novuses.replaceRange(0, novuses.length, ex.map((e) => e.output.novus));
      if(novuses.isEmpty) {
        break;
      }
    }
    return Response.ok(ex);

    
  }

  
}