import 'package:conduit/conduit.dart';
import 'package:nofiftyone/nofiftyone.dart';
import 'package:nofiftyone/models/pera.dart';

class StateraController extends ResourceController {  
  Directory directory;
  StateraController(this.directory);
  @Operation.get('liber', 'publica')
  Future<Response> liber() async {
    BigInt statera = await Pera.statera(request!.path.variables['liber']! == 'true', request!.path.variables['publica']!, directory);
    return Response.ok({
        "statera": statera.toString()
    });
  }
  @override
  Map<String, APIResponse> documentOperationResponses(APIDocumentContext context, Operation operation) {
    return {
      "200": APIResponse.schema("Fetched account balance", APISchemaObject.array(ofSchema: APISchemaObject.object({
        "statera": APISchemaObject.string(),
      })))
    };
  }
}