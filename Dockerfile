FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/config-service.jar config-service.jar

RUN apt-get update && apt-get install -y dos2unix curl && rm -rf /var/lib/apt/lists/*

COPY wait-for-health.sh ./wait-for-health.sh
RUN dos2unix ./wait-for-health.sh
RUN chmod +x wait-for-health.sh

ENTRYPOINT ./wait-for-health.sh http://discovery-service:8761/actuator/health -- java -jar config-service.jar
