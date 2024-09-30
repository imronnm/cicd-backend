pipeline {
    agent {
        docker {
            image 'docker:latest' // Docker image yang akan digunakan sebagai agent
            args '-v /var/run/docker.sock:/var/run/docker.sock' // Mengakses Docker daemon dari host
        }
    }
    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
    }
    stages {
        // Stage Build for Staging
        stage("build") {
            steps {
                sh """
                git pull origin ${branch}
                echo "Git Pull Selesai"
                docker build -t ${images}:${tag} .
                echo "Docker Build Selesai"
                """
            }
        }

        // Stage Push to Docker Hub
        stage("push to Docker Hub") {
            steps {
                script {
                    docker.withRegistry('https://registry-1.docker.io/v2/', DOCKER_CREDENTIALS_ID) {
                        sh "docker push ${images}:${tag}"
                    }
                }
            }
        }

        // Stage Deploy to Staging
        stage("deploy to staging") {
            steps {
                sh """
                ssh -o StrictHostKeyChecking=no ${vmapps_staging} << EOF 
                cd ${dir}
                docker compose down
                docker compose up -d
                echo "Application deployed on Staging"
                exit
                EOF
                """
            }
        }

        // Stage Spider Check
        stage("spider check") {
            steps {
                sh """
                ssh -o StrictHostKeyChecking=no ${vmapps_staging} << EOF 
                cd ${dir}
                wget --spider --recursive --no-verbose --level=5 --output-file=wget-log.txt ${spider_domain}
                echo "Spider check completed"
                exit
                EOF
                """
                // Archive the wget log
                archiveArtifacts artifacts: 'wget-log.txt', allowEmptyArchive: true
            }
        }

        // Stage Deploy to Production
        stage("deploy to production") {
            steps {
                sh """
                ssh -o StrictHostKeyChecking=no ${vmapps_production} << EOF 
                cd ${dir}
                docker compose down
                docker pull ${images}:${tag}
                docker compose up -d
                echo "Application deployed on Production"
                exit
                EOF
                """
            }
        }
    }
}
