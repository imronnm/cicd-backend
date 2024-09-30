def dir = '~/team1-docker/backend'
def images = 'imronnm/team1-dumbflx-backend'
def docker_registry = 'docker.io'
def spider_domain = 'https://api.team1.staging.studentdumbways.my.id/'

pipeline {
    agent any
    stages {
        // Stage Build for Staging
        stage("build for staging") {
            steps {
                script {
                    // Use the SSH_KEY credential and VMAPPS credentials
                    sshagent(['SSH_KEY']) {
                        sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                        cd ${dir}
                        git pull origin staging
                        echo "Git Pull Selesai"
                        docker build -t ${images}:staging .
                        echo "Docker Build Selesai"
                        # Login to Docker Registry
                        echo "\${DOCKER_PASSWORD}" | docker login ${docker_registry} -u "\${DOCKER_USERNAME}" --password-stdin
                        echo "Docker Login Sukses"
                        # Push the Docker image to the registry
                        docker push ${images}:staging
                        echo "Docker Push Sukses"
                        exit
                        EOF"""
                    }
                }
                // Send notification for staging build success
                script {
                    def jsonPayload = """
                    {
                        "content": "Build for staging branch was successful!",
                        "username": "Jenkins Bot"
                    }
                    """
                    sh """
                    curl -X POST -H "Content-Type: application/json" -d '${jsonPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                    """
                }
            }
        }
        
        // Stage Deploy to Staging
        stage("deploy to staging") {
            steps {
                sshagent(['SSH_KEY']) {
                    sh """ssh -o StrictHostKeyChecking=no ${VMAPPS} << EOF 
                    cd ${dir}
                    docker pull ${images}:staging
                    docker stop backend_staging || true
                    docker rm backend_staging || true
                    docker run -d --name backend_staging -p 5000:5000 ${images}:staging
                    echo "Deploy to Staging Sukses"
                    exit
                    EOF"""
                }
                // Send notification for staging deploy success
                script {
                    def jsonPayload = """
                    {
                        "content": "Deployment to Staging was successful!",
                        "username": "Jenkins Bot"
                    }
                    """
                    sh """
                    curl -X POST -H "Content-Type: application/json" -d '${jsonPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                    """
                }
            }
        }

        // Stage Build and Deploy for Production
        stage("build for production") {
            steps {
                sshagent(['SSH_KEY']) {
                    sh """ssh -o StrictHostKeyChecking=no ${VMAPPS} << EOF 
                    cd ${dir}
                    git pull origin main
                    docker build -t ${images}:production .
                    echo "Docker Build for Production Selesai"
                    # Login to Docker Registry
                    echo "\${DOCKER_PASSWORD}" | docker login ${docker_registry} -u "\${DOCKER_USERNAME}" --password-stdin
                    docker push ${images}:production
                    echo "Docker Push for Production Selesai"
                    exit
                    EOF"""
                }
                // Send notification for production deploy success
                script {
                    def jsonPayload = """
                    {
                        "content": "Build for Production was successful!",
                        "username": "Jenkins Bot"
                    }
                    """
                    sh """
                    curl -X POST -H "Content-Type: application/json" -d '${jsonPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                    """
                }
            }
        }

        stage("deploy to production") {
            steps {
                sshagent(['SSH_KEY']) {
                    sh """ssh -o StrictHostKeyChecking=no ${VMAPPS} << EOF 
                    cd ${dir}
                    docker pull ${images}:production
                    docker stop backend_production || true
                    docker rm backend_production || true
                    docker run -d --name backend_production -p 5000:5000 ${images}:production
                    echo "Deploy to Production Sukses"
                    exit
                    EOF"""
                }
                // Send notification for production deploy success
                script {
                    def jsonPayload = """
                    {
                        "content": "Deployment to Production was successful!",
                        "username": "Jenkins Bot"
                    }
                    """
                    sh """
                    curl -X POST -H "Content-Type: application/json" -d '${jsonPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                    """
                }
            }
        }
    }
    environment {
        DOCKER_USERNAME = credentials('docker_username')
        DOCKER_PASSWORD = credentials('docker_password')
        vmapps = credentials('vmapps') 
        DISCORD_WEBHOOK = credentials('discord_webhook')
    }
}
