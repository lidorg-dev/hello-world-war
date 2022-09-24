FROM openjdk:11.0.15
WORKDIR /project/hello-world-war
COPY . .
RUN mvn compile
RUN mvn test
RUN mvn package
EXPOSE 8080
ENTRYPOINT ["mvn", "-v"]
