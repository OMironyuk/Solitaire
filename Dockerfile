FROM tomcat:alpine

COPY /home/target/solitaire-1.1-SNAPSHOT.war /usr/local/tomcat/webapps/solitaire.war
