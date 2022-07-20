scalaVersion := "2.13.8"

scalacOptions ++= Seq(
  "-feature",
  "-language:reflectiveCalls",
  "-deprecation",
  "-unchecked"
)

resolvers ++= Seq(
  Resolver.sonatypeRepo("releases")
)

addCompilerPlugin(
  "edu.berkeley.cs" % "chisel3-plugin" % "3.5.3" cross CrossVersion.full
)
libraryDependencies += "edu.berkeley.cs" %% "chisel3" % "3.5.3"
libraryDependencies += "edu.berkeley.cs" %% "chiseltest" % "0.5.3"
