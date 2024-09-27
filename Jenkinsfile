pipeline {
    agent any
    }
    
    stages {
        stage ('GIT') {
            steps{
                checkout ({
					$class: 'GitSCM',
					branches: [[name: '*/dev']],
					doGenerateSubmoduleConfigurations: false,
					extensions: [],
					submoduleCfg: [],
					userRemoteConfigs: [[url: 'https://github.com/ramizrahi/hello-world-war']]])
				
            }
        }
        stege ('Build') {
            steps {
                sh 'mvn "pom.xml" clean install'
            }
        }
    }
}