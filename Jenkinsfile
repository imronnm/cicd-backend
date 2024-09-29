pipeline {
    agent any

    environment {
        DISCORD_WEBHOOK = credentials('DISCORD_WEBHOOK')
        DOCKER_HUB_PASSWD = credentials('DOCKER_HUB_PASSWD')
        SSH_KEY = credentials('SSH_KEY')
        SSH_USER = 'team1@34.101.126.235'
    }

    stages {
        stage('Build') {
            steps {
                script {
                    echo 'Building the Docker image...'
                    // Login to Docker Hub
                    sh '''
                        echo "$DOCKER_HUB_PASSWD" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin
                    '''
                    // Build and push the Docker image
                    sh '''
                        docker build -t imronnm/backendjenkins:latest .
                        docker push imronnm/backendjenkins:latest
                    '''
                    // Notify Discord
                    sh '''
                        curl -X POST -H "Content-Type: application/json" \
                        -d '{"content": "Build Done✅! Deployment is starting."}' \
                        $DISCORD_WEBHOOK
                    '''
                }
            }
            post {
                cleanup {
                    // Clean up unused Docker images
                    sh 'docker image prune -af'
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                script {
                    echo 'Deploying to the staging environment...'
                    // Write SSH key to a file
                    writeFile file: 'id_rsa', text: "$SSH_KEY"
                    sh 'chmod 600 id_rsa'
                    // SSH into the server and deploy
                    sh """
                        ssh -i id_rsa -o StrictHostKeyChecking=no $SSH_USER <<EOF
                        set -e
                        cd $dir
                        docker-compose down || echo "Failed to stop containers"
                        docker pull imronnm/backendjenkins:latest || echo "Failed to pull image"
                        docker-compose up -d || echo "Failed to start containers"
                        EOF
                    """
                    // Notify Discord
                    sh '''
                        curl -X POST -H "Content-Type: application/json" \
                        -d '{"content": "🚀 *Deploy Staging Sukses!!🔥"}' \
                        $DISCORD_WEBHOOK
                    '''
                    // Check the staging domain
                    sh '''
                        wget --spider -r -nd -nv -l 2 https://team1.studentdumbways.my.id/ || echo "Some pages might be unreachable"
                    '''
                }
            }
            post {
                cleanup {
                    // Clean up unused Docker images
                    sh 'docker image prune -af'
                    // Remove the SSH key
                    sh 'rm -f id_rsa'
                }
            }
            when {
                branch 'staging'
            }
        }

        stage('Deploy to Production') {
            steps {
                script {
                    echo 'Deploying to the production environment...'
                    // Write SSH key to a file
                    writeFile file: 'id_rsa', text: "$SSH_KEY"
                    sh 'chmod 600 id_rsa'
                    // SSH into the server and deploy
                    sh """
                        ssh -i id_rsa -o StrictHostKeyChecking=no $SSH_USER <<EOF
                        set -e
                        cd $dir
                        docker-compose down || echo "Failed to stop containers"
                        docker pull imronnm/backendjenkins:latest || echo "Failed to pull image"
                        docker-compose up -d || echo "Failed to start containers"
                        EOF
                    """
                    // Notify Discord
                    sh '''
                        curl -X POST -H "Content-Type: application/json" \
                        -d '{"content": "🚀 *Deploy Production Sukses!!🔥 Aplikasi kita udah live di production! Cek deh! 👀."}' \
                        $DISCORD_WEBHOOK
                    '''
                    // Check the production domain
                    sh '''
                        wget --spider -r -nd -nv -l 2 https://team1.studentdumbways.my.id/ || echo "Some pages might be unreachable"
                    '''
                }
            }
            post {
                cleanup {
                    // Clean up unused Docker images
                    sh 'docker image prune -af'
                    // Remove the SSH key
                    sh 'rm -f id_rsa'
                }
            }
            when {
                branch 'main'
            }
        }
    }
}
