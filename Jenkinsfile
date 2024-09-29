def secret = 'SSH_KEY'
def vmapps = 'team1@34.101.126.235'
def dir    = '/home/team1/team1-docker/backend'
def branch = 'main'
def images = 'imronnm/backendjenkins'
def tag    = 'latest'
def discordWebhookURL = 'https://discord.com/api/webhooks/1288738076243263511/tF3j9enIM27eZB_NVfv_0gtXpcGm13PrYgbObobY9jDMdhZk9Z_JNHENTpA_4G9dFwJH'

pipeline {
    agent any

    stages {
        stage("Pull") {
            steps {
                sshagent([secret]) {
                    script {
                        try {
                            sh "ssh -o StrictHostKeyChecking=no ${vmapps} 'cd ${dir} && git pull origin ${branch}'"
                            sendDiscordNotification("Git Pull Completed Successfully")
                        } catch (Exception e) {
                            sendDiscordNotification("Git Pull Failed: ${e.message}")
                            error "Git Pull Failed!"
                        }
                    }
                }
            }
        }
        stage("Docker Build") {
            steps {
                sshagent([secret]) {
                    script {
                        try {
                            sh "ssh -o StrictHostKeyChecking=no ${vmapps} 'cd ${dir} && docker build -t ${images}:${tag} .'"
                            sendDiscordNotification("Docker Build Completed Successfully")
                        } catch (Exception e) {
                            sendDiscordNotification("Docker Build Failed: ${e.message}")
                            error "Docker Build Failed!"
                        }
                    }
                }
            }
        }
        stage("Run") {
            steps {
                sshagent([secret]) {
                    script {
                        try {
                            sh "ssh -o StrictHostKeyChecking=no ${vmapps} 'cd ${dir} && docker-compose up -d'"
                            sendDiscordNotification("Application Running Successfully")
                        } catch (Exception e) {
                            sendDiscordNotification("Application Failed to Run: ${e.message}")
                            error "Application Failed to Run!"
                        }
                    }
                }
            }
        }
    }
}

def sendDiscordNotification(String message) {
    sh """
        curl -H "Content-Type: application/json" \
        -X POST \
        -d '{"content": "${message}"}' \
        ${discordWebhookURL}
    """
}
