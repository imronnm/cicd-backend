pipeline {
    agent any

    environment {
        // Define your environment variables here
        SSH_KEY = credentials('SSH_KEY')
        SSH_USER = 'team1'
        VM_IP = '34.101.126.235'
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        APP_DIR = '~/team1-docker/backend'
        BRANCH = 'main'
    }

    stages {
        stage('Build') {
            steps {
                script { 
                    // Build your application
                    echo 'Building...'
                    // Example: sh 'docker build -t your-image-name:${env.BUILD_ID} .'
                }
            }
        }

        stage('Test') {
            steps {
                script { 
                    // Test your application
                    echo 'Testing...'
                    // Example: sh 'docker run your-image-name:${env.BUILD_ID} npm test'
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script { 
                    // SSH into the VM and deploy your application
                    echo 'Deploying...'
                    
                    // Example of using SSH to run commands on the remote server
                    sh """
                        ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${SSH_USER}@${VM_IP} << EOF
                            cd ${APP_DIR}
                            git checkout ${BRANCH}
                            docker compose down
                            docker compose up -d --build
                        EOF
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'This will always run'
        }
        success {
            echo 'This will run only on success'
        }
        failure {
            echo 'This will run only on failure'
        }
    }
}
