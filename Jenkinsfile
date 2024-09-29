pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                script { 
                    // Your build steps here
                    echo 'Building...'
                }
            }
        }

        stage('Test') {
            steps {
                script { 
                    // Your test steps here
                    echo 'Testing...'
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script { 
                    // Your deploy steps here
                    echo 'Deploying...'
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
