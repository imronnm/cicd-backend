pipeline {
    agent any

    environment {
        DISCORD_WEBHOOK = credentials('DISCORD_WEBHOOK')
        SSH_KEY = credentials('SSH_KEY')
        SSH_USER = credentials('SSH_USER')
        DOCKER_CREDENTIALS = credentials('dockerhub-credentials')
    }

    stages {
        stage('Build') {
            steps {
                script {
                    // Login ke Docker Hub dengan aman
                    sh """
                        echo '${DOCKER_CREDENTIALS.password}' | docker login -u '${DOCKER_CREDENTIALS.username}' --password-stdin
                    """

                    // Membangun image Docker
                    sh 'docker build -t imronnm/backendjenkins:latest ${dir}'
                    
                    // Push image ke Docker Hub
                    sh 'docker push imronnm/backendjenkins:latest'
                    
                    // Kirim notifikasi ke Discord
                    sh """
                        curl -X POST -H 'Content-Type: application/json' \
                        -d '{"content": "Build Done✅! Deployment is starting."}' \
                        ${DISCORD_WEBHOOK}
                    """
                }
            }
        }

        // Stages lainnya...
    }

    post {
        always {
            // Membersihkan image Docker yang tidak terpakai
            sh 'docker image prune -af'
        }
    }
}
