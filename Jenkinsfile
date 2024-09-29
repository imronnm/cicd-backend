pipeline {
    agent any
    
    environment {
        DISCORD_WEBHOOK = credentials('DISCORD_WEBHOOK')
        DOCKER_HUB_PASSWD = credentials('DOCKER_HUB_PASSWD')
        SSH_KEY = credentials('SSH_KEY')
        SSH_USER = 'team1'
        VM_IP = '34.101.126.235'
        DIR = '~/team1-docker/backend'
        BRANCH = 'main'
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Checkout code from Git
                git branch: "${BRANCH}", url: 'https://github.com/imronnm/cicd-backend'
            }
        }
        
        stage('Check Docker') {
            steps {
                script {
                    echo 'Checking Docker installation...'
                    sh 'docker --version'  // This should show the Docker version
                }
            }
        }
        
        stage('Build') {
            steps {
                script {
                    echo 'Building the Docker image...'
                    // Build the Docker image
                    sh 'docker build -t your-image-name -f ${DIR}/Dockerfile ${DIR}'
                }
            }
        }
        
        stage('Deploy to Staging') {
            steps {
                sshagent(['SSH_KEY']) {
                    script {
                        echo 'Deploying to staging...'
                        // Login to Docker Hub
                        sh "ssh ${SSH_USER}@${VM_IP} 'echo ${DOCKER_HUB_PASSWD} | docker login -u your-docker-username --password-stdin'"
                        // Pull the latest image
                        sh "ssh ${SSH_USER}@${VM_IP} 'docker pull your-image-name'"
                        // Run the Docker container
                        sh "ssh ${SSH_USER}@${VM_IP} 'docker run -d --name your-container-name -p 80:80 your-image-name'"
                    }
                }
            }
        }
        
        stage('Cleanup') {
            steps {
                script {
                    echo 'Cleaning up...'
                    // Clean up dangling images, if necessary
                    sh "ssh ${SSH_USER}@${VM_IP} 'docker image prune -af'"
                }
            }
        }
    }
    
    post {
        always {
            // Send a notification to Discord or perform any other post actions
            echo "Pipeline finished."
        }
    }
}
