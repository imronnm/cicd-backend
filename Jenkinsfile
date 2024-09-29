def secret = 'SSH_KEY'
def vmapps_staging = 'team1@34.101.126.235'
def vmapps_production = 'team1@34.101.126.235'
def dir = '~/team1-docker/backend'
def images = 'imronnm/backendjenkins'
def tag = 'latest'
def discord_webhook = 'https://discord.com/api/webhooks/1288738076243263511/tF3j9enIM27eZB_NVfv_0gtXpcGm13PrYgbObobY9jDMdhZk9Z_JNHENTpA_4G9dFwJH'

// Mendapatkan branch saat ini
def currentBranch = "${env.GIT_BRANCH}"

pipeline {
    agent any
    stages {
        // Stage Build
        stage("build") {
            steps {
                sshagent([secret]) {
                    sh """ssh -o StrictHostKeyChecking=no ${vmapps_staging} << EOF 
                    cd ${dir}
                    git pull origin ${currentBranch}
                    echo "Git Pull Selesai dari branch ${currentBranch}"
                    docker build -t ${images}:${tag} .
                    echo "Docker Build Selesai"
                    exit
                    EOF"""
                }
            }
        }

        // Stage Deploy
        stage("deploy") {
            steps {
                sshagent([secret]) {
                    script {
                        if (currentBranch == 'staging') {
                            sh """ssh -o StrictHostKeyChecking=no ${vmapps_staging} << EOF 
                            cd ${dir}
                            docker compose down
                            docker compose up -d
                            echo "Application deployed on Staging"
                            exit
                            EOF"""
                            notifyDiscord("Deployment to Staging was successful!")
                        } else if (currentBranch == 'main') {
                            sh """ssh -o StrictHostKeyChecking=no ${vmapps_production} << EOF 
                            cd ${dir}
                            docker compose down
                            docker pull ${images}:${tag}
                            docker compose up -d
                            echo "Application deployed on Production"
                            exit
                            EOF"""
                            notifyDiscord("Deployment to Production was successful!")
                        }
                    }
                }
            }
        }
    }
}

// Function to send notifications to Discord
def notifyDiscord(String message) {
    def jsonPayload = """
    {
        "content": "${message}",
        "username": "Jenkins Bot"
    }
    """
    sh """
    curl -X POST -H "Content-Type: application/json" -d '${jsonPayload}' ${discord_webhook}
    """
}
