pipeline {
    agent any

    environment {
        DISCORD_WEBHOOK = credentials('DISCORD_WEBHOOK')
        SSH_KEY = credentials('SSH_KEY')
        SSH_USER = credentials('SSH_USER')
        DOCKER_CREDENTIALS = credentials('dockerhub-credentials')
    }

    stages {
        stage('Build') {
            steps {
                script {
                    // Login ke Docker Hub
                    sh "echo '${DOCKER_CREDENTIALS}' | docker login -u '${DOCKER_CREDENTIALS}' --password-stdin"

                    // Membangun image Docker
                    sh 'docker build -t imronnm/backendjenkins:latest ${dir}'
                    
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
                        ssh -i id_rsa -o StrictHostKeyChecking=no ${SSH_USER}'
                            set -e
                            cd ${dir}
                            docker compose down || echo "Failed to stop containers"
                            docker pull imronnm/backendjenkins:latest || echo "Failed to pull image"
                            docker compose up -d || echo "Failed to start containers"
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
                        ssh -i id_rsa -o StrictHostKeyChecking=no ${SSH_USER} '
                            set -e
                            cd ${dir}
                            docker compose down || echo "Failed to stop containers"
                            docker pull imronnm/backendjenkins:latest || echo "Failed to pull image"
                            docker compose up -d || echo "Failed to start containers"
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
