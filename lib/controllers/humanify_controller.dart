import 'dart:io';
import 'dart:isolate';

import 'package:conduit/conduit.dart';
import 'package:hex/hex.dart';
import 'package:nofiftyone/models/exampla.dart';
import 'package:nofiftyone/models/humanify.dart';
import 'package:nofiftyone/models/obstructionum.dart';
import 'package:nofiftyone/models/utils.dart';
import 'package:nofiftyone/p2p.dart';
import 'package:mime/mime.dart';
import 'package:lzma/lzma.dart';

class HumanifyController extends ResourceController {
  Directory directory;
  P2P p2p;
  Map<String, Isolate> humanifyIsolates;
  HumanifyController(this.directory, this.p2p, this.humanifyIsolates) {
    acceptedContentTypes = [ContentType("multipart", "form-data")];
  }

  @Operation.post('dominus', 'quaestio', 'respondere')
  Future<Response> upload(@Bind.path('dominus') String dominus, @Bind.path('quaestio') String quaestio, @Bind.path('respondere') String respondere) async {
    final boundary = request!.raw.headers.contentType!.parameters["boundary"]!;
    final transformer = MimeMultipartTransformer(boundary);
    final bodyBytes = await request!.body.decode<List<int>>();
    final bodyStream = Stream.fromIterable([bodyBytes]);
    final parts = await transformer.bind(bodyStream).toList();
    for (var part in parts) {
        final headers = part.headers;
        final body = await part.toList();
        final InterioreHumanify humanify = InterioreHumanify(dominus, respondere, quaestio, HEX.encode(body[0]));
        final ReceivePort acciperePortus = ReceivePort();
        print(lzma.encode(body[0]));
        humanifyIsolates[humanify.id] = await Isolate.spawn(Humanify.quaestum, List<dynamic>.from([humanify, acciperePortus.sendPort]));
        acciperePortus.listen((huschum) {
          print('synchumanify');
          p2p.syncHumanify(huschum as Humanify);
        });
  }
    return Response.ok("");    
  }
  @Operation.get()
  Future<Response> pool() async {
    return Response.ok(p2p.humanifies);
  }

  
}