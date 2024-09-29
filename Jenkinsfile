def secret = 'SSH_KEY'
def vmapps_staging = 'team1@34.101.126.235'
def vmapps_production = 'team1@34.101.126.235'
def dir = '~/team1-docker/backend'
def branch = 'main'
def images = 'imronnm/backendjenkins'
def tag = 'latest'
def spider_domain = 'http://api.team1.staging.my.id'
def discord_webhook = 'https://discord.com/api/webhooks/1288738076243263511/tF3j9enIM27eZB_NVfv_0gtXpcGm13PrYgbObobY9jDMdhZk9Z_JNHENTpA_4G9dFwJH'

pipeline {
    agent any
    stages {
        // Stage Build for Staging
        stage("build") {
            steps {
                sshagent([secret]){
                    sh """ssh -o StrictHostKeyChecking=no ${vmapps_staging} << EOF 
                    cd ${dir}
                    git pull origin ${branch}
                    echo "Git Pull Selesai"
                    docker build -t ${images}:${tag} .
                    echo "Docker Build Selesai"
                    exit
                    EOF"""
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
                sshagent([secret]){
                    sh """ssh -o StrictHostKeyChecking=no ${vmapps_staging} << EOF 
                    cd ${dir}
                    docker compose down
                    docker compose up -d
                    echo "Application deployed on Staging"
                    exit
                    EOF"""
                }
            }
        }

        // Stage Spider Check
        stage("spider check") {
            steps {
                sshagent([secret]){
                    sh """ssh -o StrictHostKeyChecking=no ${vmapps_staging} << EOF 
                    cd ${dir}
                    wget --spider --recursive --no-verbose --level=5 --output-file=wget-log.txt ${spider_domain}
                    echo "Spider check completed"
                    exit
                    EOF"""
                }
                // Archive the wget log
                archiveArtifacts artifacts: 'wget-log.txt', allowEmptyArchive: true
            }
        }
        
        // Stage Deploy to Production
        stage("deploy to production") {
            steps {
                sshagent([secret]){
                    sh """ssh -o StrictHostKeyChecking=no ${vmapps_production} << EOF 
                    cd ${dir}
                    docker compose down
                    docker pull ${images}:${tag}
                    docker compose up -d
                    echo "Application deployed on Production"
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
}
