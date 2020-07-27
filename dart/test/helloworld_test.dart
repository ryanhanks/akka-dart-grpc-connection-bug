import 'package:connection_bug_example/generated/helloworld.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:test/test.dart';

void main() {
  final host = '127.0.0.1';
  final port = 8080;

  GreeterServiceClient _getGreeterServiceClient() {
    ClientChannel channel;
    channel = ClientChannel(host,
        port: port,
        options:
        const ChannelOptions(credentials: ChannelCredentials.insecure()));
    return GreeterServiceClient(channel);
  }

  Future<HelloReply> _sayHello(GreeterServiceClient client) async {
    final helloRequest = HelloRequest();
    return client.sayHello(helloRequest);
  }

  group("GreeterService bug demo", () {
    test('say hello twice', () async {
      final client = _getGreeterServiceClient();
      try {
        await _sayHello(client);
        fail("Call to sayHello should have failed.");
      } on GrpcError catch(e, stacktrace) {
        expect(e.code, 2);
        print('Caught GrpcError exception:');
        print(e);
        print(stacktrace);
      }
      final reply = await _sayHello(client);
      expect(reply.message, 'Hello, ');
      print("Second call to sayHello succeeded:");
      print(reply.message);
    });
    test('say hello a third time', () async {
      final client = _getGreeterServiceClient();
      final reply = await _sayHello(client);
      expect(reply.message, 'Hello, ');
    });
  });
}

