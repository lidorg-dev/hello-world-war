pipeline {
    agent { any { image 'maven:3.3.3' } }
      stages {
        stage('Build') {
      steps {
        sh 'mvn compile'
        sh 'mvn test'
        sh 'package'
      }
    }
  }
}
