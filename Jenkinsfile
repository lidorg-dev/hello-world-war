pipeline {

    agent { 
        label 'nexus_ubuntu' 
    }
    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker_user')
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
         stage('Login') {
            steps {
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
    }
        stage('Build and Push To Docker Image') {
            steps {
                        sh '''docker push igorripin/infrastructure_mvn:${BUILD_ID}'''
            }
        }
        stage('Build and Push To Nexus Image') {
            steps {
                    withCredentials([usernamePassword(credentialsId: 'nexus_user', passwordVariable: 'nexus_pass', usernameVariable: 'nexus_user')]) {
                        sh '''docker tag igorripin/infrastructure_mvn:${BUILD_ID} ec2-18-157-87-217.eu-central-1.compute.amazonaws.com:8083/infrastructure_mvn:${BUILD_ID}'''
                        sh '''docker login ec2-18-157-87-217.eu-central-1.compute.amazonaws.com:8083 -u $nexus_user -p $nexus_pass'''
                        sh '''docker push ec2-18-157-87-217.eu-central-1.compute.amazonaws.com:8083/infrastructure_mvn:${BUILD_ID}'''
                 }
            }
        }
    }
}



