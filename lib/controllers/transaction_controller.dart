import 'dart:isolate';

import  'package:conduit/conduit.dart';
import 'package:elliptic/elliptic.dart';
import 'package:nofiftyone/nofiftyone.dart';
import 'package:nofiftyone/models/constantes.dart';
import 'package:nofiftyone/models/exampla.dart';
import 'package:nofiftyone/models/obstructionum.dart';
import 'package:nofiftyone/models/pera.dart';
import 'package:nofiftyone/models/transaction.dart';
import 'package:nofiftyone/models/unitas.dart';
import 'package:nofiftyone/models/utils.dart';
import 'package:nofiftyone/p2p.dart';
import 'package:nofiftyone/models/errors.dart';
import 'dart:convert';

class TransactionController extends ResourceController {
  Directory directory;
  P2P p2p;
  TransactionController(this.directory, this.p2p); 
 
  @Operation.get('identitatis')
  Future<Response> transaction(@Bind.path('identitatis') String identitatis) async {
    List<Obstructionum> obs = [];
        for (int i = 0; i < directory.listSync().length; i++) {
          await for (String obstructionum in Utils.fileAmnis(File('${directory.path}${Constantes.fileNomen}$i.txt'))) {
            obs.add(Obstructionum.fromJson(json.decode(obstructionum) as Map<String, dynamic>));
          }
        }
        Obstructionum prior = await Utils.priorObstructionum(directory);
        for (InterioreObstructionum interiore in obs.map((o) => o.interioreObstructionum)) {
          for (Transaction tx in interiore.liberTransactions) {
            if (tx.interioreTransaction.id == identitatis) {
              TransactionInfo txInfo =
              TransactionInfo(
                true,
                tx.interioreTransaction.inputs.map((x) => x.transactionId).toList(),
                interiore.indicatione,
                interiore.obstructionumNumerus, 
                Utils.confirmationes(interiore.obstructionumNumerus, prior.interioreObstructionum.obstructionumNumerus)
              );
              return Response.ok({
                "data": txInfo.toJson(),
                "scriptum": tx.toJson()
              });
            }
          }
          for (Transaction tx in interiore.fixumTransactions) {
            if (tx.interioreTransaction.id == identitatis) {
              TransactionInfo txInfo =
              TransactionInfo(
                true,
                tx.interioreTransaction.inputs.map((x) => x.transactionId).toList(),
                interiore.indicatione,
                interiore.obstructionumNumerus,
                Utils.confirmationes(interiore.obstructionumNumerus, prior.interioreObstructionum.obstructionumNumerus)
              );
              return Response.ok({
                "data": txInfo.toJson(),
                "scriptum": tx.toJson()
              });
            }
          }
        }
        for (Transaction tx in p2p.liberTxs) {
          if (tx.interioreTransaction.id == identitatis) {
            TransactionInfo txInfo =
            TransactionInfo(
              false,
              tx.interioreTransaction.inputs.map((x) => x.transactionId).toList(),
              null,
              null,
              null
            );
            return Response.ok({
              "data": txInfo.toJson(),
              "scriptum": tx.toJson()
            });
          }
        }
        for (Transaction tx in p2p.fixumTxs) {
          if (tx.interioreTransaction.id == identitatis) {
            TransactionInfo txInfo =
            TransactionInfo(
              false,
              tx.interioreTransaction.inputs.map((x) => x.transactionId).toList(),
              null,
              null,
              null
            );
            return Response.ok({
              "data": txInfo.toJson(),
              "scriptum": tx.toJson()
            });
          }
        }
        return Response.notFound(body: {
          "code": 0,
          "message": "Transaction not found"
        });
    }
  @override
  Map<String, APIResponse> documentOperationResponses(APIDocumentContext context, Operation operation) {
    return {
      "200": APIResponse.schema("Fetched transaction", APISchemaObject.array(ofSchema: APISchemaObject.object({
        "data": APISchemaObject.object({
          "includi": APISchemaObject.boolean(),
          "index": APISchemaObject.integer(),
          "indicatione": APISchemaObject.integer(),
          "obstructionumNumerus": APISchemaObject.array(ofSchema:  APISchemaObject.integer()),
          "confirmationes": APISchemaObject.string()
        }),
        "scriptum": APISchemaObject.object({
          "probationem": APISchemaObject.string(),
          "interioreTransaction": APISchemaObject.object({
            'liber': APISchemaObject.boolean(),
            'inputs': APISchemaObject.array(ofSchema: APISchemaObject.object({
              'index': APISchemaObject.integer(),
              'signature': APISchemaObject.string(),
              'transactionId': APISchemaObject.string() 
            })),
            'outputs': APISchemaObject.object({
              'publicKey': APISchemaObject.string(),
              'gla': APISchemaObject.string()
            }),
            'random': APISchemaObject.string(),
            'id': APISchemaObject.integer(),
            'nonce': APISchemaObject.string(),
            'expressi': APISchemaObject.string()
          })
        })
      })))
    };
  } 
}