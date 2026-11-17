# Stage 1: Build the Java application
FROM eclipse-temurin:21-jdk AS build

WORKDIR /app

COPY HelloWorld.java .

RUN javac HelloWorld.java

# Stage 2: Run the application
FROM eclipse-temurin:21-jre

WORKDIR /app

COPY --from=build /app/HelloWorld.class .

CMD ["java", "HelloWorld"]
