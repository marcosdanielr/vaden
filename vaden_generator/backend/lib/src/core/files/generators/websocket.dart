import 'dart:io';

import 'package:backend/src/core/files/file_generate.dart';
import 'package:backend/src/core/files/file_manager.dart';

class WebsocketGenerator extends FileGenerator {
  @override
  Future<void> generate(
    FileManager fileManager,
    Directory directory, {
    Map<String, dynamic> variables = const {},
  }) async {
    final libConfigWebsockeWebsocketResourceContent =
        File('${directory.path}${Platform.pathSeparator}lib${Platform.pathSeparator}config${Platform.pathSeparator}websocket${Platform.pathSeparator}websocket_resource.dart');
    await libConfigWebsockeWebsocketResourceContent.create(recursive: true);
    await libConfigWebsockeWebsocketResourceContent.writeAsString(_libConfigWebsockeWebsocketResourceContent);

    final libSrcWebsocketController = File('${directory.path}${Platform.pathSeparator}lib${Platform.pathSeparator}src${Platform.pathSeparator}websocket_controller.dart');
    await libSrcWebsocketController.create(recursive: true);
    await libSrcWebsocketController.writeAsString(_libSrcWebsocketControllerContent);

    final pubspec = File('${directory.path}${Platform.pathSeparator}pubspec.yaml');
    await fileManager.insertLineInFile(
      pubspec,
      RegExp(r'dependencies:'),
      '''  shelf_web_socket: ^3.0.0
  web_socket_channel: ^3.0.2''',
      position: InsertLinePosition.after,
    );
  }
}

const _libConfigWebsockeWebsocketResourceContent = '''import 'dart:async';

import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:vaden/vaden.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class WebSocketResource {
  FutureOr<Response> handler(Request request) {
    return webSocketHandler(connectSocket)(request);
  }

  final List<WebSocket> _websockets = [];

  void onMessage(dynamic data, WebSocket socket);

  void connect(WebSocket socket);
  void disconnect(WebSocket socket);

  void connectSocket(WebSocketChannel socketChannel, String? _) {
    final socket = WebSocket._(socketChannel, broadcast);

    _websockets.add(socket);
    connect(socket);
    socket.stream.listen(
      (message) {
        onMessage(message, socket);
      },
      onDone: () {
        _websockets.remove(socket);
        disconnect(socket);
      },
    );
  }

  void broadcast(
    dynamic message, {
    WebSocket? currentSocket,
    Iterable<String> rooms = const [],
  }) {
    for (final room in rooms.isEmpty ? [''] : rooms) {
      var list = _websockets.where((socket) => currentSocket != socket);
      if (room.isNotEmpty) {
        list = list.where((socket) => socket._enteredRooms.contains(room));
      }

      for (final websocket in list) {
        websocket.sink.add(message);
      }
    }
  }
}

class WebSocket {
  final WebSocketChannel _channel;
  final Set<String> _enteredRooms = {};
  late final Stream _stream = _channel.stream.asBroadcastStream();
  Set<String> get enteredRooms => Set<String>.unmodifiable(_enteredRooms);
  final void Function(
    dynamic message, {
    WebSocket? currentSocket,
    Iterable<String> rooms,
  }) _broadcast;
  dynamic tag;

  Stream get stream => _stream;
  Sink get sink => _channel.sink;

  void joinRoom(String room) => _enteredRooms.add(room);
  bool leaveRoom(String room) => _enteredRooms.remove(room);

  void emit(dynamic data, [Iterable<String> rooms = const []]) => _broadcast(data, currentSocket: this, rooms: rooms);
  void emitToRooms(dynamic data) => _broadcast(data, currentSocket: this, rooms: _enteredRooms);

  WebSocket._(this._channel, this._broadcast);
}
''';

const _libSrcWebsocketControllerContent = r'''import 'dart:async';

import 'package:vaden/vaden.dart';

import '../config/websocket/websocket_resource.dart';

@Controller('/chat')
class ChatController extends WebSocketResource {
  @Mount('/')
  FutureOr<Response> webSocketHandler(Request request) {
    return handler(request);
  }

  @override
  void connect(socket) {
    socket.emit('SERVIDOR: Novo cliente conectado!');
  }

  @override
  void onMessage(covariant String data, socket) {
    if (data.startsWith('@enterroom ')) {
      final room = data.replaceFirst('@enterroom ', '');
      socket.joinRoom(room);
      socket.sink.add('Você entrou na sala $room');
      socket.emit('ROOM: Novo cliente conectado', [room]);
    } else if (data.startsWith('@leaveroom ')) {
      final room = data.replaceFirst('@leaveroom ', '');
      socket.sink.add('Você saiu na sala $room');
      socket.leaveRoom(room);
      socket.emit('ROOM: Cliente saiu da sala', [room]);
    } else if (data.startsWith('@changename ')) {
      final name = data.replaceFirst('@changename ', '');
      socket.emitToRooms('${socket.tag} trocou o nome para $name');
      socket.sink.add('Agora seu nome é $name');
      socket.tag = name;
    } else if (socket.enteredRooms.isNotEmpty) {
      socket.emitToRooms('${socket.tag}: $data');
    } else {
      socket.sink.add('Entre em uma sala pra tc');
    }
  }

  @override
  void disconnect(socket) {
    socket.emit('SERVIDOR: Cliente desconectado');
  }
}
''';
