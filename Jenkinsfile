pipeline {
    agent any
    tools {
        maven 'maven' // This is the name we gave to our Maven installation in Jenkins
    }
    environment {
        AZURE_CLIENT_ID = credentials('azure-sp').username
        AZURE_CLIENT_SECRET = credentials('azure-sp').password
        AZURE_TENANT_ID = credentials('azure-tenant')
        AZURE_SUBSCRIPTION_ID = '7f44b397-03e8-463f-bcc4-9c1b2dcf4eac'
        AZURE_LOCATION = 'northeurope'
        APP_NAME = 'lucky-web-app'
        RESOURCE_GROUP_NAME = 'john'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git url: 'https://github.com/vanambharat/proj7.git', branch: 'main'
            }
        }
        stage('Maven Package') {
            steps {
                sh "mvn clean package -Dcheckstyle.skip=true"
            }
        }
        stage('Publish Artifact') {
            steps {
                sh "mv target/*.jar target/luckyspringpetclinic.jar"
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
        stage('Login to Azure') {
            steps {
                sh "az login --service-principal -u ${AZURE_CLIENT_ID} -p ${AZURE_CLIENT_SECRET} --tenant ${AZURE_TENANT_ID}"
            }
        }
        stage('Terraform Apply') {
            steps {
                dir('infra') {
                    sh "terraform init"
                    sh "terraform validate"
                    sh "terraform plan -out=tfplan"
                    sh "terraform apply -auto-approve tfplan"
                }
            }
        }
        stage('Deploy to Azure Web App') {
            steps {
                sh "az webapp deploy --resource-group ${RESOURCE_GROUP_NAME} --name ${APP_NAME} --src-path target/luckyspringpetclinic.jar"
            }
        }
    }
}
