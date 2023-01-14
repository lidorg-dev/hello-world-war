FROM maven as build 
WORKDIR /app
COPY . .
RUN mvn archetype:generate -DgroupId=com.mycompany.app\
&& -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart\
&& -DarchetypeVersion=1.4 -DinteractiveMode=false
RUN mvn clean package


FROM tomcat:9.0 
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/
ENTRYPOINT ["catalina.sh", "run"]

