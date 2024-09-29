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
        stage ("pull") {
           steps {
               sshagent([secret]){
                  sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                  cd ${dir}
                  git pull origin ${branch}
                  echo "Git Pull Telah Selesai"
                  exit
                  EOF"""
                }
                sendDiscordNotification("Git Pull telah selesai")
            }
        }
        stage ("docker build") {
           steps {
               sshagent([secret]){
                  sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                  cd ${dir}
                  docker build -t ${images}:${tag} .
                  echo "Installation dependencies telah selesai"
                  exit
                  EOF"""
                }
                sendDiscordNotification("Docker build telah selesai")
            }
        }
        stage ("run") {
           steps {
               sshagent([secret]){
                  sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                  cd ${dir}
                  docker compose up -d
                  echo "Application already running"
                  exit
                  EOF"""
                }
                sendDiscordNotification("Aplikasi sudah berjalan")
            }
        }
    }
}

// Fungsi untuk mengirim notifikasi ke Discord menggunakan wget
def sendDiscordNotification(String message) {
    // Pastikan message di-escape dengan benar
    message = message.replaceAll("\"", "\\\\\"") 
    sh """
        wget --header="Content-Type: application/json" \
        --post-data='{"content": "${message}"}' \
        ${discordWebhookURL} -O -
    """
}
