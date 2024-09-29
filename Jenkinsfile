pipeline {
    agent any
    environment {
        DISCORD_WEBHOOK = credentials('DISCORD_WEBHOOK')
        SSH_KEY = credentials('SSH_KEY')
        SSH_USER = credentials('SSH_USER')
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
    }
    stages {
        stage('Checkout Code') {
            steps {
                script {
                    def branch = 'main' // Define the branch variable here
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: branch]],
                        userRemoteConfigs: [[url: 'https://github.com/imronnm/cicd-backend', credentialsId: 'SSH_KEY']]
                    ])
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Add your Docker build steps here
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    // Add your Docker push steps here
                }
            }
        }
        stage('Deploy to VM') {
            steps {
                script {
                    // Add your deployment steps here
                }
            }
        }
        stage('Notify Discord') {
            steps {
                script {
                    // Add your notification steps here
                }
            }
        }
    }
    post {
        always {
            // Cleanup actions here
        }
    }
}
