pipeline {
    agent {
        docker {
            image 'docker:19.03' // Menggunakan image Docker di dalam Docker
            args '-v /var/run/docker.sock:/var/run/docker.sock' // Bind Docker socket dari host ke container
        }
    }
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials') // Menggunakan credential DockerHub dari Jenkins
    }
    stages {
        // Stage Build for Staging
        stage("build") {
            steps {
                sshagent(['SSH_KEY']) {
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

        // Stage Push to DockerHub
        stage("Push Docker Image") {
            steps {
                script {
                    sh """
                    echo "Logging in to DockerHub"
                    docker login -u ${DOCKERHUB_CREDENTIALS_USR} -p ${DOCKERHUB_CREDENTIALS_PSW}
                    docker push ${images}:${tag}
                    """
                }
            }
        }
        
        // Stage Deploy to Staging
        stage("deploy to staging") {
            steps {
                sshagent(['SSH_KEY']) {
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
                sshagent(['SSH_KEY']) {
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
                sshagent(['SSH_KEY']) {
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
