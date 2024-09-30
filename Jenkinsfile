def secret = 'SSH_KEY'
def vmapps_staging = 'team1@34.101.126.235'
def vmapps_production = 'team1@34.101.126.235'
def dir = '~/team1-docker/backend'
def branch = 'main'
def images = 'imronnm/backendjenkins'
def tag = 'latest'
def spider_domain = 'http://api.team1.staging.my.id'

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
            }
        }

        // Stage Push to Docker Hub
        stage("push to Docker Hub") {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        sh "docker push ${images}:${tag}"
                    }
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
            }
        }
    }
}
