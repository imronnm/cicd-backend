def secret = 'SSH_KEY'
def vmapps_staging = 'team1@34.101.126.235'
def vmapps_production = 'team1@34.101.126.235'
def dir = '~/team1-docker/backend'
def branch = 'main'
def images = 'imronnm/backendjenkins'
def tag = 'latest'

pipeline {
    agent any
    stages {
        // Stage Build
        stage ("build") {
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
            }
        }
        
        // Stage Deploy to Staging
        stage ("deploy to staging") {
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
        
        // Manual approval before production deployment
        stage('approval') {
            steps {
                input message: 'Deploy to production?'
            }
        }

        // Stage Deploy to Production
        stage ("deploy to production") {
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
            }
        }
    }
}
