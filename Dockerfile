# Match the scala (build.sbt) and sbt (build.properties) versions:
FROM hseeberger/scala-sbt:11.0.6_1.3.8_2.12.10 AS build
ARG NAME=cmak
# VERSION must match the "version" string in build.sbt:
ARG VERSION=3.0.0.5
ADD . /root/
RUN sbt clean dist
RUN unzip -d ./built ./target/universal/${NAME}-${VERSION}.zip
# Remove doc.
RUN rm -r ./built/${NAME}-${VERSION}/share
# Move files into absolute location for next stage COPY.
RUN mv -T ./built/${NAME}-${VERSION} /${NAME}-bin

FROM openjdk:11-jre-slim
COPY --from=build /cmak-bin /cmak
ENTRYPOINT ["/cmak/bin/cmak"]
