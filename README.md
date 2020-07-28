# gRPC Connection Bug
This repo intends to serve as an artifact to aid in the reproduction of a bug found when connecting to an akka-http server from a dart client using gRPC.

It's not clear whether the issue lies entirely on the client-side or the server-side, or if it's a combination of both.

# How to reproducing
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