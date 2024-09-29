pipeline {
    agent any

    environment {
        DISCORD_WEBHOOK = credentials('DISCORD_WEBHOOK')
        SSH_USER = credentials('SSH_USER')
        SSH_KEY = credentials('SSH_KEY')
        DOCKER_CREDENTIALS = credentials('dockerhub-credentials') // assuming it's username:password
    }

    stages {
        stage('Build') {
            steps {
                script {
                    // Login ke Docker Hub menggunakan withCredentials
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
                    }

                    // Membangun image Docker
                    sh 'docker build -t imronnm/backendjenkins:latest ~/team1-docker/backend'
                    
                    // Push image ke Docker Hub
                    sh 'docker push imronnm/backendjenkins:latest'

                    // Kirim notifikasi ke Discord
                    sh """
                        curl -X POST -H 'Content-Type: application/json' \
                        -d '{"content": "Build Done✅! Deployment is starting."}' \
                        ${DISCORD_WEBHOOK}
                    """
                }
            }
        }

        stage('Deploy Staging') {
            when {
                branch 'staging'
            }
            steps {
                script {
                    // Menyimpan kunci SSH ke file sementara
                    writeFile file: 'id_rsa', text: "${SSH_KEY}"
                    sh 'chmod 600 id_rsa'
                    
                    // Deploy aplikasi ke VM Staging
                    sh """
                        ssh -i id_rsa -o StrictHostKeyChecking=no ${SSH_USER}@34.101.126.235 '
                            set -e
                            cd ~/team1-docker/backend
                            docker-compose down || echo "Failed to stop containers"
                            docker pull imronnm/backendjenkins:latest || echo "Failed to pull image"
                            docker-compose up -d || echo "Failed to start containers"
                        '
                    """
                    
                    // Menghapus file kunci SSH
                    sh 'rm id_rsa'
                    
                    // Kirim notifikasi ke Discord
                    sh """
                        curl -X POST -H 'Content-Type: application/json' \
                        -d '{"content": "🚀 Deploy Staging Sukses!!🔥"}' \
                        ${DISCORD_WEBHOOK}
                    """
                }
            }
        }

        stage('Deploy Production') {
            when {
                branch 'main'
            }
            steps {
                script {
                    // Menyimpan kunci SSH ke file sementara
                    writeFile file: 'id_rsa', text: "${SSH_KEY}"
                    sh 'chmod 600 id_rsa'
                    
                    // Deploy aplikasi ke VM Production
                    sh """
                        ssh -i id_rsa -o StrictHostKeyChecking=no ${SSH_USER}@34.101.126.235 '
                            set -e
                            cd ~/team1-docker/backend
                            docker-compose down || echo "Failed to stop containers"
                            docker pull imronnm/backendjenkins:latest || echo "Failed to pull image"
                            docker-compose up -d || echo "Failed to start containers"
                        '
                    """
                    
                    // Menghapus file kunci SSH
                    sh 'rm id_rsa'
                    
                    // Kirim notifikasi ke Discord
                    sh """
                        curl -X POST -H 'Content-Type: application/json' \
                        -d '{"content": "🚀 Deploy Production Sukses!!🔥 Aplikasi kita udah live di production!"}' \
                        ${DISCORD_WEBHOOK}
                    """
                }
            }
        }
    }

    post {
        always {
            // Membersihkan image Docker yang tidak terpakai
            sh 'docker image prune -af'
        }
    }
}
