# gRPC Connection Bug
This repo intends to serve as an artifact to aid in the reproduction of a bug found when connecting to an akka-http server from a dart client using gRPC.

It's not clear whether the issue lies entirely on the client-side or the server-side, or if it's a combination of both.

# How to reproduce
1. Start the akka backend: `cd akka-helloworld-backend-java; ./gradlew runServer`
1. Run the dart tests *twice*: `cd dart; pub run test --platform vm test/; pub run test --platform vm test/`

The tests will *fail* the first time (meaning the bug *wasn't* reproduced), and will then *pass* on subsequent runs (meaning the bug *was* reproduced).

The tests can be found in the [dart/test/helloworld_test](https://github.com/ryanhanks/akka-dart-grpc-connection-bug/blob/master/dart/test/helloworld_test.dart#L23-L45) file.

Stopping and restarting the backend will produce the same sequence where the tests fail the first time and then pass the second (and Nth) time.

# About the backend
This backend was derived from the [akka-grpc-quickstart-java](https://github.com/akka/akka-grpc-quickstart-java.g8) generator template. The generated service was then modified to use an HTTP server context (it's generated with a config that uses an HTTPS server context)

This behavior also reproduces with the [akka-grpc-quickstart-scala](https://github.com/akka/akka-grpc-quickstart-scala.g8) template, applying the same modifications.

In both cases akka-http 10.1.2 was used. Testing with akka-http 10.2.0-RC2 produces the same results.

A python-based backend does *not* reproduce this same behavior.

# Expected shell output from test runs
```
➜  bug-example git:(master) cd dart; pub run test --platform vm test/; echo "*******************"; pub run test --platform vm test/
00:01 +0: test/helloworld_test.dart: GreeterService bug demo say hello twice
Caught GrpcError exception:
gRPC Error (2, HTTP/2 error: Stream error: Stream was terminated by peer (errorCode: 8).)
00:01 +0 -1: test/helloworld_test.dart: GreeterService bug demo say hello twice [E]
  gRPC Error (2, StreamException(stream id: 3): Remote end was telling us to stop. This stream was not processed and can therefore be retried (on a new connection).)
  dart:async                                                             _StreamController.addError
  package:grpc/src/client/call.dart 207:16                               ClientCall._responseError
  package:grpc/src/client/call.dart 262:5                                ClientCall._onResponseError
  ===== asynchronous gap ===========================
  dart:async                                                             _BoundSinkStream.listen
  package:grpc/src/client/call.dart 192:56                               ClientCall._onResponseListen
  package:grpc/src/client/call.dart 178:5                                ClientCall._sendRequest
  package:grpc/src/client/call.dart 145:7                                ClientCall.onConnectionReady
  package:grpc/src/client/http2_connection.dart 180:10                   Http2ClientConnection._startCall
  package:grpc/src/client/http2_connection.dart 156:9                    Http2ClientConnection.dispatchCall
  package:grpc/src/client/channel.dart 81:18                             ClientChannelBase.createCall.<fn>
  ===== asynchronous gap ===========================
  dart:async                                                             Future.then
  package:grpc/src/client/channel.dart 79:21                             ClientChannelBase.createCall
  package:grpc/src/client/client.dart 33:21                              Client.$createCall
  package:connection_bug_example/generated/helloworld.pbgrpc.dart 32:18  GreeterServiceClient.sayHello
  test/helloworld_test.dart 20:19                                        main._sayHello
  test/helloworld_test.dart 18:31                                        main._sayHello
  test/helloworld_test.dart 34:36                                        main.<fn>.<fn>
  ===== asynchronous gap ===========================
  dart:async                                                             _asyncErrorWrapperHelper
  test/helloworld_test.dart                                              main.<fn>.<fn>

00:01 +1 -1: Some tests failed.
*******************
00:01 +0: test/helloworld_test.dart: GreeterService bug demo say hello twice
Caught GrpcError exception:
gRPC Error (2, HTTP/2 error: Stream error: Stream was terminated by peer (errorCode: 8).)
Second call to sayHello succeeded:
Hello,
00:01 +2: All tests passed!
```