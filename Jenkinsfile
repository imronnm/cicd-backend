pipeline {
    agent any

    environment {
        DISCORD_WEBHOOK = credentials('DISCORD_WEBHOOK')
        SSH_KEY = credentials('SSH_KEY')
        SSH_USER = credentials('SSH_USER')
    }

    stages {
        stage('Build') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        // Login ke Docker Hub
                        sh "echo '${DOCKER_PASS}' | docker login -u '${DOCKER_USER}' --password-stdin"
                    }
                    
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

        // Stage lainnya tetap sama...
    }

    post {
        always {
            // Membersihkan image Docker yang tidak terpakai
            sh 'docker image prune -af'
        }
    }
}
