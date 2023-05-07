pipeline {

    agent { 
        label 'nexus_ubuntu' 
    }

    triggers {
        pollSCM '* * * * *'
    }

    stages {
        stage('checkout code') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/dev--ans']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-ssh', url: 'https://github.com/igor1234567/Infrastructure.git']]])
            }
        }
    stage('SonarQube Analysis') {
        steps {
            script {
                //def mvnHome = tool name: 'maven', type: 'maven'
                //def sonarQubeScannerHome = tool name: 'SonarQube'

                withSonarQubeEnv('SonarQube') {
                    sh '''mvn clean verify sonar:sonar'''
                }
            }
        }
    }
        stage('Build') {
            steps {
                script {
                    //def mvnHome = tool name: 'maven', type: 'maven'
                    sh '''mvn clean install'''
                    sh '''docker build . -t igorripin/infrastructure_mvn:${BUILD_ID}'''
                }
            }
        }
        stage('Build and Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'igorripin-dockerhub', passwordVariable: 'docker_pass', usernameVariable: 'docker_user')]) {
                        sh '''docker push igorripin/infrastructure_mvn:${BUILD_ID}'''
                    }
                    withCredentials([usernamePassword(credentialsId: 'nexus_user', passwordVariable: 'nexus_pass', usernameVariable: 'nexus_user')]) {
                        sh '''docker push 3.72.80.151:8083/infrastructure_mvn:${BUILD_ID}'''
                    }
                }
            }
        }
    }
}



