FROM ubuntu

# Install prerequisites
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install openjdk-8-jdk wget
RUN apt-get -y install curl
RUN apt-get -y install maven
RUN apt-get -y install git
RUN mkdir /opt/tomcat/
RUN mkdir /opt/webapp/
RUN mkdir /tmp/repos
RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz -O /tmp/tomcat.tar.gz
RUN cd /tmp && tar xvfz tomcat.tar.gz
RUN cp -Rv /tmp/apache-tomcat-9.0.65/* /opt/tomcat/

# clone repo
RUN cd /tmp/repos
RUN git clone https://github.com/nirshif/hello-world-war.git
#RUN cd /tmp/repos/hello-world-war
#RUN git checkout ns-es

# mvn install
#RUN mvn install

# Copy war to folder
#RUN cp /tmp/repos/hello-world-war/target/hello-world-war-*.war /opt/tomcat/webapps

EXPOSE 8060
# java
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Define default command.
CMD ["bash"]


# run war in tomcat
#WORKDIR /opt/tomcat/webapps
#RUN /opt/tomcat/webapps/hello-world-war-*.war

#CMD ["/opt/tomcat/bin/catalina.sh", "run"]
