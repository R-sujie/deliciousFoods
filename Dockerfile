FROM maven:3.9-eclipse-temurin-8 AS build
WORKDIR /build
COPY pom.xml .
COPY src ./src
RUN mvn -B package

FROM eclipse-temurin:8-jre
WORKDIR /app
COPY --from=build /build/target/deliciousFoods-1.0-SNAPSHOT.jar app.jar
COPY src/main/resources/static/file /app/demo-images
EXPOSE 8080
ENTRYPOINT ["sh", "-c", "mkdir -p src/main/resources/static/file && cp -rn /app/demo-images/. src/main/resources/static/file/ && exec java -jar app.jar"]
