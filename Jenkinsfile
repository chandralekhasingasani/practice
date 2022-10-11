pipeline {
    agent any

    environment {
            CC = 'clang'
        }

    stages {
        stage('Build') {
            environment
            {
                            DEBUG_FLAGS = '-g'
            }
            steps{
                sh 'echo $CC'
            }
        }
    }
}