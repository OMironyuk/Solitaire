FROM tomcat:alpine

COPY target/solitaire-1.1-SNAPSHOT.war /usr/local/tomcat/webapps/solitaire.war
