pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'imronnm/frontendgitlab:latest'
        DISCORD_WEBHOOK = credentials('DISCORD_WEBHOOK')
        SSH_KEY = credentials('SSH_KEY')
        SSH_USER = credentials('SSH_USER')
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
    }

    stages {
        stage('Build') {
            steps {
                script {
                    // Login to Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        // Build Docker Image
                        sh "docker build -t ${DOCKER_IMAGE} ${dir}"
                        // Push Docker Image to Docker Hub
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
                // Send notification to Discord
                sendDiscordNotification("Build Done ✅! Deployment is starting.")
            }
        }

        stage('Deploy Staging') {
            when {
                branch 'staging'
            }
            steps {
                script {
                    // Create a temporary file for SSH key
                    writeFile file: 'id_rsa', text: "${SSH_KEY}"
                    sh 'chmod 600 id_rsa'

                    // Deploy to Staging
                    sshagent(['SSH_KEY']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ${SSH_USER}@${vmapps} 'bash -s' << EOF
                        set -e
                        cd ${dir}
                        docker-compose down || echo "Failed to stop containers"
                        docker pull ${DOCKER_IMAGE} || echo "Failed to pull image"
                        docker-compose up -d || echo "Failed to start containers"
                        EOF
                        """
                    }
                    // Clean up SSH key
                    sh 'rm -f id_rsa'
                }
                // Send notification to Discord
                sendDiscordNotification("🚀 Deploy Staging Sukses!! 🔥")
            }
        }

        stage('Deploy Production') {
            when {
                branch 'main'
            }
            steps {
                script {
                    // Create a temporary file for SSH key
                    writeFile file: 'id_rsa', text: "${SSH_KEY}"
                    sh 'chmod 600 id_rsa'

                    // Deploy to Production
                    sshagent(['SSH_KEY']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ${SSH_USER}@${vmapps} 'bash -s' << EOF
                        set -e
                        cd ${dir}
                        docker-compose down || echo "Failed to stop containers"
                        docker pull ${DOCKER_IMAGE} || echo "Failed to pull image"
                        docker-compose up -d || echo "Failed to start containers"
                        EOF
                        """
                    }
                    // Clean up SSH key
                    sh 'rm -f id_rsa'
                }
                // Send notification to Discord
                sendDiscordNotification("🚀 Deploy Production Sukses!! 🔥 Aplikasi kita udah live di production! Cek deh! 👀.")
            }
        }
    }
}

// Function to send notification to Discord
def sendDiscordNotification(String message) {
    sh """
    curl -X POST -H "Content-Type: application/json" \
    -d '{"content": "${message}"}' ${DISCORD_WEBHOOK}
    """
}
