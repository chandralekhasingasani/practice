pipeline {
    agent any
    parameters {
        string(name: 'DB_PASSWORD', description: 'DB_PASSWORD')
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
               sh 'ls'
            }
        }
    }
}