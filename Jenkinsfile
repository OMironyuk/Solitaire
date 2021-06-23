pipeline {
    agent {
        docker {
        image '10.129.0.41:8111/jenkins-agent'
        registryUrl 'http://10.129.0.41:8111'
        registryCredentialsId '1a5ec3e3-b900-493e-84c5-f58edf9ee355'
        args '-v /var/run/docker.sock:/var/run/docker.sock \
              -v /tmp/maven/:/root/.m2 -u root:root'
        }
    }

    stages {
        stage ('clone git repo') {
            steps {
                git 'https://github.com/OMironyuk/Solitaire.git'
            }
        }
        stage ('Build war'){
            steps {
            sh 'mvn package'
            nexusArtifactUploader (
                artifacts: [[artifactId: 'solitaire', classifier: '', file: 'target/solitaire-1.1-SNAPSHOT.war', type: 'war']], 
                credentialsId: '1a5ec3e3-b900-493e-84c5-f58edf9ee355', 
                groupId: 'devschool', 
                nexusUrl: '10.129.0.41:8081', 
                nexusVersion: 'nexus3', 
                protocol: 'http', 
                repository: 'maven-repo', 
                version: 'v1')
            }
        }
        stage ('Make docker image') {
            steps {
                sh 'docker build -t solitaire:v1 .'
                sh 'docker tag solitaire:v1 10.129.0.41:8111/solitaire:v1  && docker push 10.129.0.41:8111/solitaire:v1'
            }
        }
        stage ('Run app image on prod') {
            steps {
                withCredentials([usernamePassword(credentialsId: '361acfbe-9d82-4422-971d-311042710744', passwordVariable: 'Password', usernameVariable: 'userName')]) {
                    script {
                    def remote = [:]
                    remote.name = "devs-10-prod"
                    remote.host = "10.129.0.11"
                    remote.allowAnyHosts = true
                    remote.user = userName
                    remote.password = Password
                    sshCommand remote: remote, command: 'docker run -d -p 8080:8080 10.129.0.41:8111/solitaire:v1'
                    }
                }
            }
        }
    }
}
