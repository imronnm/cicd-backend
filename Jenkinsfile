pipeline {
    agent any
    environment {
        DISCORD_WEBHOOK = credentials('DISCORD_WEBHOOK') // Mengambil webhook Discord dari kredensial
        SSH_KEY = credentials('SSH_KEY') // Mengambil SSH key dari kredensial
        SSH_USER = 'team1' // Username SSH
        DOCKER_CREDENTIALS = 'dockerhub-credentials' // ID kredensial Docker Hub
    }
    stages {
        stage('Checkout Code') {
            steps {
                script {
                    // Meng-clone repositori dari Git
                    sh """
                    git clone -b ${branch} git@github.com:imronnm/cicd-backend.git ${dir}
                    """
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Masuk ke direktori backend
                    dir("${dir}") {
                        // Build image Docker
                        def app = docker.build("imronnm/backendjenkins:latest")
                    }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    // Push image ke Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS) {
                        app.push()
                    }
                }
            }
        }
        stage('Deploy to VM') {
            steps {
                script {
                    // Menggunakan SSH untuk deploy ke VM
                    sh """
                    ssh -i ${SSH_KEY} ${SSH_USER}@34.101.126.235 "docker pull imronnm/backendjenkins:latest && docker run -d imronnm/backendjenkins:latest"
                    """
                }
            }
        }
        stage('Notify Discord') {
            steps {
                script {
                    // Notifikasi ke Discord
                    def message = "Deployment successful!"
                    sh """
                    curl -X POST -H 'Content-Type: application/json' -d '{"content": "${message}"}' ${DISCORD_WEBHOOK}
                    """
                }
            }
        }
    }
    post {
        always {
            // Cleanup atau langkah-langkah lain setelah build
            echo 'Cleaning up...'
        }
    }
}
