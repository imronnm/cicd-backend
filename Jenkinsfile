pipeline {
    agent any
    environment {
        DOCKER_USERNAME = credentials('docker_username')
        DOCKER_PASSWORD = credentials('docker_password')
        VM_HOST = 'user@34.101.xxx.xxx' // Ganti dengan host VM yang benar
        DOCKER_REGISTRY = 'docker.io'
        IMAGE_NAME = 'imronnm/team1-dumbflx-backend'
        DIR = '~/team1-docker/backend'
        DISCORD_WEBHOOK = 'https://discord.com/api/webhooks/1288738076243263511/tF3j9enIM27eZB_NVfv_0gtXpcGm13PrYgbObobY9jDMdhZk9Z_JNHENTpA_4G9dFwJH'
    }
    
    stages {
        // Stage: Build Docker Image for Staging
        stage('Build Staging') {
            steps {
                script {
                    sshagent(['SSH_KEY']) {
                        sh """ssh -o StrictHostKeyChecking=no ${VM_HOST} << EOF
                        cd ${DIR}
                        git pull origin staging
                        docker build -t ${IMAGE_NAME}:staging .
                        echo "\${DOCKER_PASSWORD}" | docker login ${DOCKER_REGISTRY} -u "\${DOCKER_USERNAME}" --password-stdin
                        docker push ${IMAGE_NAME}:staging
                        EOF"""
                    }
                }
                // Notify success
                sendDiscordNotification("Build for staging branch was successful!")
            }
        }
        
        // Stage: Deploy to Staging
        stage('Deploy to Staging') {
            steps {
                script {
                    sshagent(['SSH_KEY']) {
                        sh """ssh -o StrictHostKeyChecking=no ${VM_HOST} << EOF
                        docker pull ${IMAGE_NAME}:staging
                        docker stop backend_staging || true
                        docker rm backend_staging || true
                        docker run -d --name backend_staging -p 8080:8080 ${IMAGE_NAME}:staging
                        EOF"""
                    }
                }
                // Notify success
                sendDiscordNotification("Deployment to staging was successful!")
            }
        }
        
        // Stage: Build Docker Image for Production
        stage('Build Production') {
            steps {
                script {
                    sshagent(['SSH_KEY']) {
                        sh """ssh -o StrictHostKeyChecking=no ${VM_HOST} << EOF
                        cd ${DIR}
                        git pull origin main
                        docker build -t ${IMAGE_NAME}:production .
                        echo "\${DOCKER_PASSWORD}" | docker login ${DOCKER_REGISTRY} -u "\${DOCKER_USERNAME}" --password-stdin
                        docker push ${IMAGE_NAME}:production
                        EOF"""
                    }
                }
                // Notify success
                sendDiscordNotification("Build for production branch was successful!")
            }
        }
        
        // Stage: Deploy to Production
        stage('Deploy to Production') {
            steps {
                script {
                    sshagent(['SSH_KEY']) {
                        sh """ssh -o StrictHostKeyChecking=no ${VM_HOST} << EOF
                        docker pull ${IMAGE_NAME}:production
                        docker stop backend_production || true
                        docker rm backend_production || true
                        docker run -d --name backend_production -p 8080:8080 ${IMAGE_NAME}:production
                        EOF"""
                    }
                }
                // Notify success
                sendDiscordNotification("Deployment to production was successful!")
            }
        }
    }
    
    // Block to handle post conditions
    post {
        failure {
            sendDiscordNotification("Pipeline failed.")
        }
        always {
            cleanWs() // Cleanup workspace after each run
        }
    }
}

def sendDiscordNotification(message) {
    def jsonPayload = """
    {
        "content": "${message}",
        "username": "Jenkins Bot"
    }
    """
    sh """
    curl -X POST -H "Content-Type: application/json" -d '${jsonPayload}' ${DISCORD_WEBHOOK}
    """
}
