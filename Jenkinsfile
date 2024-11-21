pipeline {
  environment {
        registry = "sagishwartz/final"
        registryCredential = 'docker_hub'
    }
    tools {
       terraform 'terraform'
    }
  agent any
  stages {
    stage('Checkout_code') {
      steps {
        cleanWs()
        git(url: 'https://github.com/sagishwartz/hello-world-war.git', branch: 'dev', credentialsId: 'github')
      }
    }
    stage('Git_clone') {
      steps {
        sh 'git clone https://github.com/sagishwartz/infra-schwartz.git'
        dir(path: 'infra-schwartz') {
          sh 'git checkout dev'
          sh 'cp Dockerfile /var/lib/jenkins/workspace/final/'
        }

      }
    }

    stage('Maven_build') {
      steps {
        sh 'mvn compile '
      }
    }

    stage('Maven_test') {
      steps {
        sh 'mvn test'
      }
    }

    stage('SQ') {
      steps {
        withSonarQubeEnv('SQ') {
          sh 'mvn clean verify sonar:sonar -Dsonar.projectKey=final_project'
        }

      }
    }

    stage('Docker_build_tag') {
      steps {
        sh 'docker build -t sagishwartz/final:$BUILD_NUMBER .'
      }
    }

    stage('Push_image') {
        steps {
            script {
                docker.withRegistry( '', registryCredential ) {
                    sh "docker push sagishwartz/final:$BUILD_NUMBER"
                }
            }
        }
    }
      stage('Checkout_code_terraform') {
      steps {
        cleanWs()
        git(url: 'https://github.com/sagishwartz/terraform-provision-eks-cluster.git', branch: 'main', credentialsId: 'github')
      }
    }
    stage('Terraform_format_check') {
        steps{
            sh 'terraform fmt'
            }
        }
    stage('Terraform_init') {
        steps{
            sh 'terraform init'
            }
        }
    stage('Terraform_apply') {
        steps{
            sh 'terraform apply --auto-approve'
            }
        }
    stage('Deploy_hellowrold') {
        steps{
            script{
                cluster_name = sh (script: "terraform output cluster_name", returnStdout: true).trim()
                region = sh (script: "terraform output region", returnStdout: true).trim()
                sh "aws eks update-kubeconfig --region ${region} --name ${cluster_name}"
                sh "kubectl apply -f helloworld_deployment.yml"
            }
            }
        }
    stage('Deploy_prom_opt') {
        steps{
            sh 'kubectl create namespace monitoring'
            sh 'helm repo add prometheus-community https://prometheus-community.github.io/helm-charts'
            sh 'helm repo update'
            sh 'helm upgrade --namespace monitoring --install kube-stack-prometheus prometheus-community/kube-prometheus-stack --set prometheus-node-exporter.hostRootFsMount.enabled=false'
            }
        }
  }
}
