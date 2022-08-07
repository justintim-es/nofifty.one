
import 'dart:io';

import 'package:nofiftyone/models/obstructionum.dart';
import 'package:nofiftyone/models/scan.dart';
import 'package:nofiftyone/models/utils.dart';
import 'package:collection/collection.dart';
import 'package:nofiftyone/nofiftyone.dart';

class CashExController extends ResourceController {
  Directory directory;
  CashExController(this.directory);

  @Operation.get('publica')
  Future<Response> balance(@Bind.path('publica') String publica) async {
    List<Obstructionum> lo = await Utils.getObstructionums(directory);
    List<List<Scan>> llscanm = lo.map((e) => e.interioreObstructionum.scans).toList();
    Scan? scanBasis = llscanm.firstWhereOrNull((element) => element.any((a) => a.output.prior == publica))?[0];
    if (scanBasis == null) {
    	return Response.badRequest(body: "No prior found get scanned first!");
    }
    List<String> novuses = [scanBasis!.output.prior];
    List<String> todos = [];
    int statera = 0;
    while (true) {
    	todos = [];
    	print('novuses');
    	print(novuses);
		for(String novus in novuses) {
			llscanm.where((w) => w.any((a)=> a.output.prior == novus)).map((m) => m.map((im) => im.output.novus)).forEach((element) {
				todos.addAll(element);
				statera++;
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
				statera++;
			});
		}
	}
    return Response.ok(statera);
  }

  
}
