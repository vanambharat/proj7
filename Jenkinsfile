pipeline {
    agent any

    tools {
        maven 'maven'   // Name of Maven tool configured in Jenkins
        jdk 'temurin-21' // Optional if you configured JDK in Jenkins
    }

    environment {
        AZURE_CLIENT_ID     = credentials('azure-sp')      // Your Service Principal ID
        AZURE_CLIENT_SECRET = credentials('azure-sp-secret') // Your Secret
        AZURE_TENANT_ID     = credentials('azure-tenant')
        AZURE_SUBSCRIPTION  = "7f44b397-03e8-463f-bcc4-9c1b2dcf4eaic"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/vanambharat/proj7.git'
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean package -Dcheckstyle.skip=true'
                sh 'cp target/*.jar target/luckyspringpetclinic.jar'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Azure Login') {
            steps {
                sh '''
                az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
                az account set --subscription $AZURE_SUBSCRIPTION
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                dir('infra') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('infra') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('infra') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('infra') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Deploy to Azure Web App') {
            steps {
                echo 'Deployment to Azure Web App will be automatic after Terraform creation.'
            }
        }
    }
}

