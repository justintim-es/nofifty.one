import 'dart:core';
import 'dart:isolate';

import 'package:nofiftyone/controllers/defensio_bid_controller.dart';
import 'package:nofiftyone/controllers/defensio_controller.dart';
import 'package:nofiftyone/controllers/gladiator_controller.dart';
import 'package:nofiftyone/controllers/mine_confussus_controller.dart';
import 'package:nofiftyone/controllers/mine_efectus_controller.dart';
import 'package:nofiftyone/controllers/mine_expressi_controller.dart';
import 'package:nofiftyone/controllers/network_controller.dart';
import 'package:nofiftyone/controllers/obstructionum_controller.dart';
import 'package:nofiftyone/controllers/rationem_controller.dart';
import 'package:nofiftyone/controllers/rationem_stagnum_controller.dart';
import 'package:nofiftyone/controllers/statera_controller.dart';
import 'package:nofiftyone/controllers/transaction_controller.dart';
import 'package:nofiftyone/controllers/transaction_expressi_controller.dart';
import 'package:nofiftyone/controllers/transaction_fixum_controller.dart';
import 'package:nofiftyone/controllers/transaction_liber_controller.dart';
import 'package:nofiftyone/nofiftyone.dart';
import 'package:nofiftyone/helpers/rp.dart';
import 'package:nofiftyone/models/aboutconfig.dart';
import 'package:nofiftyone/models/obstructionum.dart';
import 'package:nofiftyone/controllers/numerus_controller.dart';
import 'package:nofiftyone/models/utils.dart';
import 'package:nofiftyone/p2p.dart';
import 'package:nofiftyone/controllers/probationem_controller.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://conduit.io/docs/http/channel/.
class NofiftyoneChannel extends ApplicationChannel {
  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  Aboutconfig? aboutconfig;
  Directory? directory;
  P2P? p2p;
  Map<String, Isolate> propterIsolates = Map();
  Map<String, Isolate> liberTxIsolates = Map();
  Map<String, Isolate> fixumTxIsolates = Map();
  List<Isolate> efectusThreads = [];
  List<Isolate> confussuses = [];
  List<Isolate> expressiThreads = [];
  bool isSalutaris = false;
  String confussusGladiatorId = "";
  int confussusGladiatorIndex = 0;
  String confussusGladiatorPrivateKey = "";
  String expressiGladiatorId = "";
  int expressiGladiatorIndex = 0;
  String expressiGladiatorPrivateKey = "";
  bool isExpressi = false;
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    CORSPolicy.defaultPolicy.allowedOrigins = ["*"];
    aboutconfig = Aboutconfig(options!.configurationFilePath!);
    directory = await Directory(aboutconfig!.directory!).create( recursive: true );
    if(aboutconfig!.novus! && directory!.listSync().isEmpty) {
      Obstructionum obs = Obstructionum.incipio(InterioreObstructionum.incipio(producentis: aboutconfig!.publicaClavis!));
      await obs.salvareIncipio(directory!);
    }
    p2p = P2P(aboutconfig!.maxPares!, Utils.randomHex(32), '${aboutconfig!.internumIp!}:${aboutconfig!.p2pPortus}', directory!, [0]);
    p2p!.listen(aboutconfig!.internumIp!, int.parse(aboutconfig!.p2pPortus!));
    if(aboutconfig!.bootnode != null) {
      p2p!.connect(aboutconfig!.bootnode!, '${aboutconfig!.externalIp!}:${aboutconfig!.p2pPortus}');
    }
    p2p!.efectusRp.listen((message) {
      Rp.efectus(isSalutaris, efectusThreads, propterIsolates, liberTxIsolates, fixumTxIsolates, p2p!, aboutconfig!, directory!);
    });
    p2p!.confussusRp.listen((message) {
      Rp.confussus(isSalutaris, confussusGladiatorIndex, confussusGladiatorPrivateKey, confussusGladiatorId, confussuses, propterIsolates, liberTxIsolates, fixumTxIsolates, p2p!, aboutconfig!, directory!);
    });
    p2p!.expressiRp.listen((message) { 
      if(message ==  false) {
        isExpressi = false;
        expressiThreads.forEach((e) => e.kill(priority: Isolate.immediate));
        return;
      }
      Rp.expressi(isExpressi, isSalutaris, expressiGladiatorIndex, expressiGladiatorPrivateKey, expressiGladiatorId, confussuses, propterIsolates, liberTxIsolates, fixumTxIsolates, p2p!, aboutconfig!, directory!);
    });
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://conduit.io/docs/http/request_controller/
    router.route("/example").linkFunction((request) async {
      return Response.ok({"key": "value"});
    });
    router.route('/defensio-bid/:liber/:index/:probationem/[:gladiatorId]').link(() => DefensioBidController(directory!));
    router.route('/defensio/:index/:gladiatorId/[:liber]').link(() => DefensioController(directory!));
    router.route('/gladiators/[:publica]').link(() => GladiatorsController(directory!));
    router.route('/mine-efectus/[:loop]').link(() => MineEfectusController(directory!, p2p!, aboutconfig!, propterIsolates, liberTxIsolates, fixumTxIsolates, isSalutaris, efectusThreads));
    router.route('/mine-confussus').link(() => MineConfussusController(directory!, p2p!, aboutconfig!, isSalutaris, propterIsolates, liberTxIsolates, fixumTxIsolates, confussuses));
    router.route('/mine-expressi').link(() => MineExpressiController(directory!, p2p!, aboutconfig!, isSalutaris, propterIsolates, liberTxIsolates, fixumTxIsolates, expressiThreads));
    router.route('/network').link(() => NetworkController(p2p!));
    router.route('/numerus').link(() => NumerusController(directory!));
    router.route('/rationem/[:identitatis]').link(() => RationemController(directory!, p2p!, propterIsolates));
    router.route('/rationem-stagnum').link(() => RationemStagnumController(p2p!));
    router.route('/obstructionum[/:probationem]').link(() => ObstructionumController(directory!, p2p!));
    router.route('/statera/:liber/:publica').link(() => StateraController(directory!));
    router.route('/transaction/:identitatis').link(() => TransactionController(directory!, p2p!));
    router.route('/transaction-liber').link(() => TransactionLiberController(directory!, p2p!, liberTxIsolates));
    router.route('/transaction-fixum').link(() => TransactionFixumController(directory!, p2p!, fixumTxIsolates));
    router.route('/transaction-expressi').link(() => TransactionExpressiController(p2p!));
    router.route('/probationem').link(() => ProbationemController(directory!));
    return router;
  }
}
