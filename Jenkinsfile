def secret = 'SSH_KEY'
def vmapps = 'team1@34.101.126.235'
def dir    = '/home/team1/team1-docker/backend'
def branch = 'main'
def images = 'imronnm/backendjenkins'
def tag    = 'latest'
def discordWebhookUrl = 'https://discord.com/api/webhooks/1288738076243263511/tF3j9enIM27eZB_NVfv_0gtXpcGm13PrYgbObobY9jDMdhZk9Z_JNHENTpA_4G9dFwJH'

def sendDiscordNotification(String message) {
    sh """
    curl -X POST -H 'Content-Type: application/json' -d '{"content": "${message}"}' ${discordWebhookUrl}
    """
}

pipeline {
    agent any
    stages {
        stage("Pull") {
            steps {
                sshagent([secret]) {
                    script {
                        def pullResult = sh(script: """ssh -o StrictHostKeyChecking=no ${vmapps} 'cd ${dir} && git pull origin ${branch}'""", returnStatus: true)
                        if (pullResult != 0) {
                            sendDiscordNotification("Git Pull Failed!")
                            error "Git Pull Failed!"
                        }
                        sendDiscordNotification("Git Pull Telah Selesai")
                    }
                }
            }
        }
        stage("Docker Build") {
            steps {
                sshagent([secret]) {
                    script {
                        def buildResult = sh(script: """ssh -o StrictHostKeyChecking=no ${vmapps} 'cd ${dir} && docker build -t ${images}:${tag} .'""", returnStatus: true)
                        if (buildResult != 0) {
                            sendDiscordNotification("Docker Build Failed!")
                            error "Docker Build Failed!"
                        }
                        sendDiscordNotification("Installation dependencies telah selesai")
                    }
                }
            }
        }
        stage("Run") {
            steps {
                sshagent([secret]) {
                    script {
                        def runResult = sh(script: """ssh -o StrictHostKeyChecking=no ${vmapps} 'cd ${dir} && docker-compose up -d'""", returnStatus: true)
                        if (runResult != 0) {
                            sendDiscordNotification("Application failed to run!")
                            error "Application failed to run!"
                        }
                        sendDiscordNotification("Application already running")
                    }
                }
            }
        }
    }
}
