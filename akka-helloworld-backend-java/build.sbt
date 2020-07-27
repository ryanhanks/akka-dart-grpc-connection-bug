name := "akka-helloworld-backend-java"
version := "1.0"
scalaVersion := "2.13.2"

val akkaVersion = "2.6.8"
lazy val akkaGrpcVersion = "1.0.1"

enablePlugins(AkkaGrpcPlugin)

akkaGrpcGeneratedLanguages := Seq(AkkaGrpc.Java)

libraryDependencies ++= Seq(
  "com.typesafe.akka" %% "akka-actor-typed" % akkaVersion,
  "com.typesafe.akka" %% "akka-discovery" % akkaVersion,
  "com.typesafe.akka" %% "akka-stream" % akkaVersion,
  "com.typesafe.akka" %% "akka-pki" % akkaVersion,
  "com.typesafe.akka" %% "akka-actor-testkit-typed" % akkaVersion % Test,
  "com.typesafe.akka" %% "akka-stream-testkit" % akkaVersion % Test,
  "junit" % "junit" % "4.13" % Test,
  "com.novocode" % "junit-interface" % "0.11" % Test
)

testOptions += Tests.Argument(TestFrameworks.JUnit, "-v")
