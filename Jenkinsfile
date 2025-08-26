pipeline {
    agent any
    tools {
        maven 'maven'
    }
    environment {
        // These are global environment variables that are NOT secrets
        AZURE_SUBSCRIPTION_ID = '7f44b397-03e8-463f-bcc4-9c1b2dcf4eac'
        AZURE_LOCATION = 'northeurope'
        APP_NAME = 'lucky-web-app-v2'
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
                // Use withCredentials to securely inject secrets
                withCredentials([
                    usernamePassword(credentialsId: 'azure-sp', usernameVariable: 'AZURE_CLIENT_ID', passwordVariable: 'AZURE_CLIENT_SECRET'),
                    string(credentialsId: 'azure-tenant', variable: 'AZURE_TENANT_ID')
                ]) {
                    sh "az login --service-principal -u ${AZURE_CLIENT_ID} -p ${AZURE_CLIENT_SECRET} --tenant ${AZURE_TENANT_ID}"
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                // Use withCredentials to securely inject secrets
                withCredentials([
                    usernamePassword(credentialsId: 'azure-sp', usernameVariable: 'AZURE_CLIENT_ID', passwordVariable: 'AZURE_CLIENT_SECRET'),
                    string(credentialsId: 'azure-tenant', variable: 'AZURE_TENANT_ID')
                ]) {
                    dir('infra') {
                        sh "terraform init"
                        sh "terraform validate"
                        sh "terraform plan -out=tfplan"
                        sh "terraform apply -auto-approve tfplan"
                    }
                }
            }
        }
        stage('Deploy to Azure Web App') {
            steps {
                // Use withCredentials to securely inject secrets
                withCredentials([
                    usernamePassword(credentialsId: 'azure-sp', usernameVariable: 'AZURE_CLIENT_ID', passwordVariable: 'AZURE_CLIENT_SECRET'),
                    string(credentialsId: 'azure-tenant', variable: 'AZURE_TENANT_ID')
                ]) {
                    sh "az webapp deploy --resource-group ${RESOURCE_GROUP_NAME} --name ${APP_NAME} --src-path target/luckyspringpetclinic.jar"
                }
            }
        }
    }
}
