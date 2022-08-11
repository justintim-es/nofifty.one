import 'package:conduit/conduit.dart';
import 'package:hex/hex.dart';
import 'package:nofiftyone/models/obstructionum.dart';
import 'package:nofiftyone/models/utils.dart';
import 'package:nofiftyone/nofiftyone.dart';

class QuaestioController extends ResourceController {
  Directory directory;
  QuaestioController(this.directory);

  @Operation.get('probationem')
  Future<Response> quaestio(@Bind.path('probationem') String probationem) async {
    List<Obstructionum> obss = await Utils.getObstructionums(directory);
    for (Obstructionum obs in obss) {
      if(obs.interioreObstructionum.humanify?.probationem == probationem) {
        return Response.ok({
          "quaestio": obs.interioreObstructionum.humanify!.interiore.quaestio
        });
      }
    }
    return Response.badRequest(body: "no quastio found for probationem");
  }
}