#FROM tomcat:8-jre8
#COPY target/*.war /usr/local/tomcat/webapps/
#ENTRYPOINT ["catalina.sh", "run"]

FROM maven as build 
WORKDIR /app
COPY . .
RUN mvn clean package


FROM tomcat:9.0 
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/
ENTRYPOINT ["catalina.sh", "run"]
