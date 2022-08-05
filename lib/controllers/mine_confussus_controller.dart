import 'dart:isolate';
import 'package:conduit/conduit.dart';
import 'package:elliptic/elliptic.dart';
import 'package:nofiftyone/nofiftyone.dart';
import 'package:nofiftyone/models/aboutconfig.dart';
import 'package:nofiftyone/models/exampla.dart';
import 'package:nofiftyone/models/gladiator.dart';
import 'package:nofiftyone/models/obstructionum.dart';
import 'package:nofiftyone/models/pera.dart';
import 'package:nofiftyone/models/transaction.dart';
import 'package:nofiftyone/p2p.dart';
import 'package:tuple/tuple.dart';
import '../models/constantes.dart';
import '../models/utils.dart';
import 'package:collection/collection.dart';

class MineConfussusController extends ResourceController {
  Directory directory;
  late String gladiatorId;
  late int gladiatorIndex;
  late String gladiatorPrivateKey;
  P2P p2p;
  Aboutconfig aboutconfig;
  List<Isolate> confussuses;
  bool isSalutaris;
  Map<String, Isolate> propterIsolates;
  Map<String, Isolate> liberTxIsolates;
  Map<String, Isolate> fixumTxIsolates;
  MineConfussusController(this.directory, this.p2p, this.aboutconfig, this.isSalutaris, this.propterIsolates, this.liberTxIsolates, this.fixumTxIsolates, this.confussuses);

  @Operation.post()
  Future<Response> mine(@Bind.body() Confussus conf) async {
      List<Transaction> fixumTxs = [];
      List<Transaction> liberTxs = [];
      if (!File('${directory.path}/${Constantes.fileNomen}0.txt').existsSync()) {
        return Response.badRequest(body: {
            "message": "Still waiting on incipio block"
        });
      }
      // so the thread is stull running while the block already is mined so stop the thread from spinning if successful
      Obstructionum priorObstructionum = await Utils.priorObstructionum(directory);
      Gladiator gladiatorToAttack = await Obstructionum.grabGladiator(conf.gladiatorId!, directory);
      if (!await Obstructionum.gladiatorSpiritus(conf.index!, gladiatorToAttack.id, directory)) {
        return Response.badRequest(body: {
          "code": 0,
          "message": "Gladiator non inveni",
          "english": "Gladiator not found"
        });
      }
      gladiatorId = gladiatorToAttack.id;
      gladiatorIndex = 0;
      gladiatorPrivateKey = conf.privateKey!;
      liberTxs = Transaction.grab(priorObstructionum.interioreObstructionum.liberDifficultas, p2p.liberTxs);
      for (String acc in gladiatorToAttack.outputs[conf.index!].rationem.map((e) => e.interioreRationem.publicaClavis)) {
        final balance = await Pera.statera(true, acc, directory);
        if (balance > BigInt.zero) {
          liberTxs.add(Transaction.burn(await Pera.ardeat(PrivateKey.fromHex(Pera.curve(), conf.privateKey!), acc, priorObstructionum.probationem, balance, directory)));
        }
      }
      Tuple2<InterioreTransaction?, InterioreTransaction?> transform = await Pera.transformFixum(conf.privateKey!, p2p.liberTxs, directory);
      if(transform.item1 != null) {
        liberTxs.add(Transaction(Constantes.transform, transform.item1!));
      }
      fixumTxs = Transaction.grab(priorObstructionum.interioreObstructionum.fixumDifficultas, p2p.fixumTxs);
      if(transform.item2 != null) {
         fixumTxs.add(Transaction(Constantes.transform, transform.item2!));
      }
      List<Defensio> deschef = await Pera.maximeDefensiones(true, conf.index!, gladiatorToAttack.id, directory);
      deschef.addAll(await Pera.maximeDefensiones(false, conf.index!, gladiatorToAttack.id, directory));
      List<String> toCrack = deschef.map((e) => e.defensio).toList();
      final base = await Pera.turpiaGladiatoriaDefensione(conf.index!, gladiatorToAttack.id, directory);
      toCrack.add(base.defensio);
      BigInt numerus = BigInt.zero; 
      for (int nuschum in await Obstructionum.utObstructionumNumerus(directory)) {
        numerus += BigInt.parse(nuschum.toString());
      }
      final obstructionumDifficultas = await Obstructionum.utDifficultas(directory);
      InterioreObstructionum interiore = InterioreObstructionum.confussus(
        obstructionumDifficultas: obstructionumDifficultas.length,
        divisa: (numerus / await Obstructionum.utSummaDifficultas(directory)),
        forumCap: await Obstructionum.accipereForumCap(directory),
        liberForumCap: await Obstructionum.accipereForumCapLiberFixum(true, directory),
        fixumForumCap: await Obstructionum.accipereForumCapLiberFixum(false, directory),
        summaObstructionumDifficultas: await Obstructionum.utSummaDifficultas(directory),
        obstructionumNumerus: await Obstructionum.utObstructionumNumerus(directory),
        propterDifficultas: Obstructionum.acciperePropterDifficultas(priorObstructionum),
        liberDifficultas: Obstructionum.accipereLiberDifficultas(priorObstructionum),
        fixumDifficultas: Obstructionum.accipereFixumDifficultas(priorObstructionum),
        producentis: aboutconfig.publicaClavis!,
        priorProbationem: priorObstructionum.probationem,
        gladiator: Gladiator(GladiatorInput(conf.index!, Utils.signum(PrivateKey.fromHex(Pera.curve(), conf.privateKey!), gladiatorToAttack.outputs[conf.index!]), conf.gladiatorId!), [], Utils.randomHex(32)),
        liberTransactions: liberTxs,
        fixumTransactions: fixumTxs,
        expressiTransactions: [],
        scans: p2p.scans,
        humanify: null,
        cashEx: null
      );
      ReceivePort acciperePortus = ReceivePort();
      confussuses.add(await Isolate.spawn(Obstructionum.confussus, List<dynamic>.from([interiore, toCrack, acciperePortus.sendPort])));
      acciperePortus.listen((nuntius) async {
        while (isSalutaris) {
          await Future.delayed(Duration(seconds: 1));
        }
        isSalutaris = true;
        Obstructionum obstructionum = nuntius as Obstructionum;
        Obstructionum priorObs = await Utils.priorObstructionum(directory);
        if(ListEquality().equals(obstructionum.interioreObstructionum.obstructionumNumerus, priorObs.interioreObstructionum.obstructionumNumerus)) {
          print('invalid blocknumber retrying');
          p2p.confussusRp.sendPort.send("update miner");
            isSalutaris = false;
          return;
        }
        if (priorObs.probationem != obstructionum.interioreObstructionum.priorProbationem) {
          print('invalid probationem');
          p2p.confussusRp.sendPort.send("update miner");
          isSalutaris = false;
          return;
        } 
        Gladiator gladiator = obstructionum.interioreObstructionum.gladiator;
        if (!await Obstructionum.gladiatorSpiritus(gladiator.input!.index, gladiator.input!.gladiatorId, directory)) {
          print('gladiator not found');
          return;
        }
        List<GladiatorOutput> outputs = [];
        for (GladiatorOutput output in obstructionum.interioreObstructionum.gladiator.outputs) {
          output.rationem.map((r) => r.interioreRationem.id).forEach((id) => propterIsolates[id]?.kill(priority: Isolate.immediate));
        }
        obstructionum.interioreObstructionum.liberTransactions.map((e) => e.interioreTransaction.id).forEach((id) => liberTxIsolates[id]?.kill(priority: Isolate.immediate));
        obstructionum.interioreObstructionum.fixumTransactions.map((e) => e.interioreTransaction.id).forEach((id) => fixumTxIsolates[id]?.kill(priority: Isolate.immediate));
        List<String> gladiatorIds = [];
        for (GladiatorOutput output in outputs) {
          gladiatorIds.addAll(output.rationem.map((r) => r.interioreRationem.id).toList());
        }
        p2p.removePropters(gladiatorIds);
        p2p.removeLiberTxs(obstructionum.interioreObstructionum.liberTransactions.map((l) => l.interioreTransaction.id).toList());
        p2p.removeFixumTxs(obstructionum.interioreObstructionum.fixumTransactions.map((f) => f.interioreTransaction.id).toList());
        p2p.syncBlocks.forEach((e) => e..kill(priority: Isolate.immediate));
        p2p.syncBlocks.add(await Isolate.spawn(P2P.syncBlock, List<dynamic>.from([obstructionum, p2p.sockets, directory, '${aboutconfig.internumIp!}:{$aboutconfig.p2pPortus!}'])));
        confussuses.forEach((iso) => iso.kill(priority: Isolate.immediate));
        await obstructionum.salvare(directory);
        isSalutaris = false;
        // all we have to do is stop all threads
        //   Obstructionum obstructionum = nuntius;
        //   print(obstructionum.toJson());
        //   obstructionum.interioreObstructionum.gladiator.output?.rationem.map((r) => r.interioreRationem.id).forEach((id) => propterIsolates[id]?.kill());
        //   obstructionum.interioreObstructionum.liberTransactions.map((e) => e.interioreTransaction.id).forEach((id) => liberTxIsolates[id]?.kill());
        //   obstructionum.interioreObstructionum.fixumTransactions.map((e) => e.interioreTransaction.id).forEach((id) => fixumTxIsolates[id]?.kill());
        //   p2p.removePropters(obstructionum.interioreObstructionum.gladiator.output?.rationem.map((r) => r.interioreRationem.id).toList() ?? []);
        //   p2p.removeLiberTxs(obstructionum.interioreObstructionum.liberTransactions.map((l) => l.interioreTransaction.id).toList());
        //   p2p.removeFixumTxs(obstructionum.interioreObstructionum.fixumTransactions.map((f) => f.interioreTransaction.id).toList());
        //   p2p.syncBlock(obstructionum);
        //   await obstructionum.salvare(directory);
      });
      return Response.ok({
        "message": "coepi confussus miner",
        "english": "started confussus miner",
        "threads": confussuses.length 
      });
  }

  @Operation.get()
  Future<Response> threads() async {
    return Response.ok({
      "threads": confussuses.length
    });
  }
  @Operation.delete()
  Future<Response> deschel() async {
    confussuses.forEach((e) => e.kill(priority: Isolate.immediate));
    return Response.ok({
      "message": "bene substitit confussus miner",
      "english": "succesfully stopped confussus miner",
    });
  }
  
  @override
  Map<String, APIResponse> documentOperationResponses(APIDocumentContext context, Operation operation) {
    if(operation.method == "POST") {
      return {
        "200": APIResponse.schema("Started the efectus miner to increase the amount of leading zeros with 2 and bring 2 new teams of gladiators into the game which can buy defences togetherstuck", APISchemaObject.object({
          "message": APISchemaObject.string(),
          "english": APISchemaObject.string(),
          "threads": APISchemaObject.integer()
        }))
      };
    } else if (operation.method == 'GET') {
      return { "200":  APIResponse.schema("Fetch the amount of efectus threads", APISchemaObject.object({
          "threads": APISchemaObject.integer(),
        }))
      };
    } else {
      return {
        "200": APIResponse.schema("Stop the efectus miner", APISchemaObject.object({
          "message": APISchemaObject.string(),
          "english": APISchemaObject.string(),
        }))
      };
    }
  }

  @override
  void documentComponents(APIDocumentContext context) {
    super.documentComponents(context);

    final personSchema = Confussus().documentSchema(context);
    context.schema.register(
      "Person",
      personSchema,
      representation: Confussus);          
  }
}