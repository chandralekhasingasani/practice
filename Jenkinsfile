pipeline {
    agent any
    parameters {
        password(name: 'DB_PASSWORD', description: 'DB_PASSWORD')
        string(name: 'DB_USERNAME', description: 'DB_USERNAME')
    }
    stages {
        stage('Clone repo') {
            steps{
                git branch: 'main', url: 'https://github.com/chandralekhasingasani/practice.git'
            }
        }

        stage('Terraform'){
            steps{
               sh """pwd;cd terraform ; touch deployer ;terraform init; terraform apply -auto-approve -var DB_PASSWORD=$DB_PASSWORD -var DB_USERNAME=$DB_USERNAME """
            }
        }
    }
}