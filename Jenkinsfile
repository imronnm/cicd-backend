def dir = '~/team1-docker/backend'
def images = 'imronnm/team1-dumbflx-backend'
def docker_registry = 'docker.io'
def spider_domain = 'https://api.team1.staging.studentdumbways.my.id/login'
def discord_webhook = 'https://discord.com/api/webhooks/1288738076243263511/tF3j9enIM27eZB_NVfv_0gtXpcGm13PrYgbObobY9jDMdhZk9Z_JNHENTpA_4G9dFwJH'

pipeline {
    agent any
    stages {
        // Stage Build for Staging
        stage("build") {
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
                    curl -X POST -H "Content-Type: application/json" -d '${jsonPayload}' ${discord_webhook}
                    """
                }
            }
        }
        
        // Stage Deploy to Staging
        stage("deploy to staging") {
            steps {
                sshagent(['SSH_KEY']) {
                    sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                    cd ${dir}
                    docker build -t ${images}:production .
                    echo "Docker Build for Production Selesai"
                    # Login to Docker Registry
                    echo "\${DOCKER_PASSWORD}" | docker login ${docker_registry} -u "\${DOCKER_USERNAME}" --password-stdin
                    echo "Docker Login Sukses"
                    # Push the Docker image to the registry
                    docker push ${images}:production
                    echo "Docker Push for Production Sukses"
                    exit
                    EOF"""
                }
                // Send notification for production deploy success
                script {
                    def jsonPayload = """
                    {
                        "content": "Deployment to Production from main branch was successful!",
                        "username": "Jenkins Bot"
                    }
                    """
                    sh """
                    curl -X POST -H "Content-Type: application/json" -d '${jsonPayload}' ${discord_webhook}
                    """
                }
            }
        }
    }
    environment {
        DOCKER_USERNAME = credentials('docker_username')
        DOCKER_PASSWORD = credentials('docker_password')
        vmapps = credentials('vmapps') // Memanggil vmapps dari Jenkins credentials
    }
}
