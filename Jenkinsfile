pipeline {
    agent any
    stages {
        // Stage Build for Staging
        stage("build") {
            steps {
                script {
                    sshagent(['SSH_KEY']) {
                        sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                        cd ${dir}
                        git pull origin staging
                        echo "Git Pull Selesai"
                        docker build -t ${images}:staging .
                        echo "Docker Build Selesai"

                        # Login to Docker Registry
                        echo "\${DOCKER_PASSWORD}" | docker login ${docker_registry} -u "\${DOCKER_USERNAME}" --password-stdin
                        echo "Docker Login Sukses"

                        # Push the Docker image to the registry
                        docker push ${images}:staging
                        echo "Docker Push Selesai"
                        exit
                        EOF"""
                    }
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
                sshagent(['SSH_KEY']) {
                    sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                    cd ${dir}
                    docker compose down
                    docker compose up -d --build
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
                    sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
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
                // Step 1: Pull staging image and deploy
                sshagent(['SSH_KEY']) {
                    sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                    cd ${dir}
                    git pull origin main
                    echo "Git Pull Selesai for Production"
                    docker compose down
                    # Pull the staging image for production
                    docker pull ${images}:staging
                    docker compose up -d --build
                    echo "Application deployed on Production using Staging image"
                    exit
                    EOF"""
                }

                // Step 2: Build and push production image
                sshagent(['SSH_KEY']) {
                    sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                    cd ${dir}
                    docker build -t ${images}:production .
                    echo "Docker Build for Production Selesai"

                    # Login to Docker Registry
                    echo "\${DOCKER_PASSWORD}" | docker login ${docker_registry} -u "\${DOCKER_USERNAME}" --password-stdin
                    echo "Docker Login Sukses"

                    # Push the Docker image to the registry
                    docker push ${images}:production
                    echo "Docker Push for Production Selesai"
                    exit
                    EOF"""
                }

                // Step 3: Deploy production image after push
                sshagent(['SSH_KEY']) {
                    sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                    cd ${dir}
                    docker compose down
                    # Pull the production image and start the container
                    docker pull ${images}:production
                    docker compose up -d --build
                    echo "Application deployed on Production using Production image"
                    exit
                    EOF"""
                }

                // Step 4: Send notification for production deploy success
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
    environment {
        DOCKER_USERNAME = credentials('docker_username')
        DOCKER_PASSWORD = credentials('docker_password')
    }
}
