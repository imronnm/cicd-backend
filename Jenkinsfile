def dir = '~/team1-docker/backend'
def images = 'imronnm/team1-dumbflx-backend'
def docker_registry = 'docker.io'
def spider_domain = 'https://api.team1.staging.studentdumbways.my.id/'

pipeline {
    agent any
    stages {
        // Stage Build for Staging
        stage("Build for Staging") {
            steps {
                script {
                    def branch = "staging"
                    def timestamp = new Date().format("yyyy-MM-dd HH:mm:ss")
                    
                    sshagent(['SSH_KEY']) {
                        sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                        cd ${dir}
                        git pull origin ${branch}
                        echo "Git Pull Selesai"
                        docker build -t ${images}:${branch} .
                        echo "Docker Build Selesai"
                        # Login to Docker Registry
                        echo "\${DOCKER_PASSWORD}" | docker login ${docker_registry} -u "\${DOCKER_USERNAME}" --password-stdin
                        echo "Docker Login Sukses"
                        # Push the Docker image to the registry
                        docker push ${images}:${branch}
                        echo "Docker Push Sukses"
                        exit
                        EOF"""
                    }
                    // Send notification for staging build success
                    script {
                        def jsonPayload = """
                        {
                            "content": "Build for branch '${branch}' was successful on ${timestamp}!\nDocker Image: ${images}:${branch}",
                            "username": "Jenkins Bot"
                        }
                        """
                        sh """
                        curl -X POST -H "Content-Type: application/json" -d '${jsonPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                        """
                    }
                }
            }
        }

        // Stage Deploy to Staging
        stage("Deploy to Staging") {
            steps {
                script {
                    def branch = "staging"
                    def timestamp = new Date().format("yyyy-MM-dd HH:mm:ss")
                    
                    sshagent(['SSH_KEY']) {
                        sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                        cd ${dir}
                        docker pull ${images}:${branch}
                        docker stop backend_staging || true
                        docker rm backend_staging || true
                        docker run -d --name backend_staging -p 5000:5000 ${images}:${branch}
                        echo "Deploy to Staging Sukses"
                        exit
                        EOF"""
                    }
                    // Send notification for staging deploy success
                    script {
                        def jsonPayload = """
                        {
                            "content": "Deployment to branch '${branch}' was successful on ${timestamp}!\nDocker Image: ${images}:${branch}",
                            "username": "Jenkins Bot"
                        }
                        """
                        sh """
                        curl -X POST -H "Content-Type: application/json" -d '${jsonPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                        """
                    }
                }
            }
        }

        // Stage Build for Production
        stage("Build for Production") {
            steps {
                script {
                    def branch = "main"
                    def timestamp = new Date().format("yyyy-MM-dd HH:mm:ss")
                    
                    sshagent(['SSH_KEY']) {
                        sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                        cd ${dir}
                        git pull origin ${branch}
                        docker build -t ${images}:${branch} .
                        echo "Docker Build for Production Selesai"
                        # Login to Docker Registry
                        echo "\${DOCKER_PASSWORD}" | docker login ${docker_registry} -u "\${DOCKER_USERNAME}" --password-stdin
                        docker push ${images}:${branch}
                        echo "Docker Push for Production Selesai"
                        exit
                        EOF"""
                    }
                    // Send notification for production build success
                    script {
                        def jsonPayload = """
                        {
                            "content": "Build for branch '${branch}' was successful on ${timestamp}!\nDocker Image: ${images}:${branch}",
                            "username": "Jenkins Bot"
                        }
                        """
                        sh """
                        curl -X POST -H "Content-Type: application/json" -d '${jsonPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                        """
                    }
                }
            }
        }

        // Stage Deploy to Production
        stage("Deploy to Production") {
            steps {
                script {
                    def branch = "main"
                    def timestamp = new Date().format("yyyy-MM-dd HH:mm:ss")
                    
                    sshagent(['SSH_KEY']) {
                        sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                        cd ${dir}
                        docker pull ${images}:${branch}
                        docker stop backend_production || true
                        docker rm backend_production || true
                        docker run -d --name backend_production -p 5000:5000 ${images}:${branch}
                        echo "Deploy to Production Sukses"
                        exit
                        EOF"""
                    }
                    // Send notification for production deploy success
                    script {
                        def jsonPayload = """
                        {
                            "content": "Deployment to branch '${branch}' was successful on ${timestamp}!\nDocker Image: ${images}:${branch}",
                            "username": "Jenkins Bot"
                        }
                        """
                        sh """
                        curl -X POST -H "Content-Type: application/json" -d '${jsonPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                        """
                    }
                }
            }
        }
    }
    environment {
        DOCKER_USERNAME = credentials('docker_username')
        DOCKER_PASSWORD = credentials('docker_password')
        vmapps = credentials('vmapps') 
        DISCORD_WEBHOOK = credentials('discord_webhook')
    }
}
def dir = '~/team1-docker/backend'
def images = 'imronnm/team1-dumbflx-backend'
def docker_registry = 'docker.io'
def spider_domain = 'https://api.team1.staging.studentdumbways.my.id/'

pipeline {
    agent any
    stages {
        // Stage Build for Staging
        stage("Build for Staging") {
            steps {
                script {
                    def branch = "staging"
                    def timestamp = new Date().format("yyyy-MM-dd HH:mm:ss")
                    
                    sshagent(['SSH_KEY']) {
                        sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                        cd ${dir}
                        git pull origin ${branch}
                        echo "Git Pull Selesai"
                        docker build -t ${images}:${branch} .
                        echo "Docker Build Selesai"
                        # Login to Docker Registry
                        echo "\${DOCKER_PASSWORD}" | docker login ${docker_registry} -u "\${DOCKER_USERNAME}" --password-stdin
                        echo "Docker Login Sukses"
                        # Push the Docker image to the registry
                        docker push ${images}:${branch}
                        echo "Docker Push Sukses"
                        exit
                        EOF"""
                    }
                    // Send notification for staging build success
                    script {
                        def jsonPayload = """
                        {
                            "content": "Build for branch '${branch}' was successful on ${timestamp}!\nDocker Image: ${images}:${branch}",
                            "username": "Jenkins Bot"
                        }
                        """
                        sh """
                        curl -X POST -H "Content-Type: application/json" -d '${jsonPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                        """
                    }
                }
            }
        }

        // Stage Deploy to Staging
        stage("Deploy to Staging") {
            steps {
                script {
                    def branch = "staging"
                    def timestamp = new Date().format("yyyy-MM-dd HH:mm:ss")
                    
                    sshagent(['SSH_KEY']) {
                        sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                        cd ${dir}
                        docker pull ${images}:${branch}
                        docker stop backend_staging || true
                        docker rm backend_staging || true
                        docker run -d --name backend_staging -p 5000:5000 ${images}:${branch}
                        echo "Deploy to Staging Sukses"
                        exit
                        EOF"""
                    }
                    // Send notification for staging deploy success
                    script {
                        def jsonPayload = """
                        {
                            "content": "Deployment to branch '${branch}' was successful on ${timestamp}!\nDocker Image: ${images}:${branch}",
                            "username": "Jenkins Bot"
                        }
                        """
                        sh """
                        curl -X POST -H "Content-Type: application/json" -d '${jsonPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                        """
                    }
                }
            }
        }

        // Stage Build for Production
        stage("Build for Production") {
            steps {
                script {
                    def branch = "main"
                    def timestamp = new Date().format("yyyy-MM-dd HH:mm:ss")
                    
                    sshagent(['SSH_KEY']) {
                        sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                        cd ${dir}
                        git pull origin ${branch}
                        docker build -t ${images}:${branch} .
                        echo "Docker Build for Production Selesai"
                        # Login to Docker Registry
                        echo "\${DOCKER_PASSWORD}" | docker login ${docker_registry} -u "\${DOCKER_USERNAME}" --password-stdin
                        docker push ${images}:${branch}
                        echo "Docker Push for Production Selesai"
                        exit
                        EOF"""
                    }
                    // Send notification for production build success
                    script {
                        def jsonPayload = """
                        {
                            "content": "Build for branch '${branch}' was successful on ${timestamp}!\nDocker Image: ${images}:${branch}",
                            "username": "Jenkins Bot"
                        }
                        """
                        sh """
                        curl -X POST -H "Content-Type: application/json" -d '${jsonPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                        """
                    }
                }
            }
        }

        // Stage Deploy to Production
        stage("Deploy to Production") {
            steps {
                script {
                    def branch = "main"
                    def timestamp = new Date().format("yyyy-MM-dd HH:mm:ss")
                    
                    sshagent(['SSH_KEY']) {
                        sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                        cd ${dir}
                        docker pull ${images}:${branch}
                        docker stop backend_production || true
                        docker rm backend_production || true
                        docker run -d --name backend_production -p 5000:5000 ${images}:${branch}
                        echo "Deploy to Production Sukses"
                        exit
                        EOF"""
                    }
                    // Send notification for production deploy success
                    script {
                        def jsonPayload = """
                        {
                            "content": "Deployment to branch '${branch}' was successful on ${timestamp}!\nDocker Image: ${images}:${branch}",
                            "username": "Jenkins Bot"
                        }
                        """
                        sh """
                        curl -X POST -H "Content-Type: application/json" -d '${jsonPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                        """
                    }
                }
            }
        }
    }
    environment {
        DOCKER_USERNAME = credentials('docker_username')
        DOCKER_PASSWORD = credentials('docker_password')
        vmapps = credentials('vmapps') 
        DISCORD_WEBHOOK = credentials('discord_webhook')
    }
}
