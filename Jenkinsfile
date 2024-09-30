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
                    try {
                        // Gunakan kredensial SSH_KEY
                        sshagent(['SSH_KEY']) {
                            sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                            cd ${dir}
                            git pull origin staging
                            echo "Git Pull Selesai"
                            docker build --cache-from=${images}:staging -t ${images}:staging .
                            echo "Docker Build Selesai"
                            # Login ke Docker Registry
                            echo "\${DOCKER_PASSWORD}" | docker login ${docker_registry} -u "\${DOCKER_USERNAME}" --password-stdin
                            echo "Docker Login Sukses"
                            # Push image Docker ke registry
                            docker push ${images}:staging
                            echo "Docker Push Sukses"
                            exit
                            EOF"""
                        }
                        // Kirim notifikasi sukses
                        def jsonPayload = """
                        {
                            "content": "Build for staging branch 'staging' was successful!\nImage Version: ${images}:staging\nBuild Time: ${new Date()}",
                            "username": "Jenkins Bot"
                        }
                        """
                        sh """
                        curl -X POST -H "Content-Type: application/json" -d '${jsonPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                        """
                    } catch (Exception e) {
                        // Kirim notifikasi error
                        def errorPayload = """
                        {
                            "content": "Build for staging failed: ${e.getMessage()}\nBranch: 'staging'\nTime: ${new Date()}",
                            "username": "Jenkins Bot"
                        }
                        """
                        sh """
                        curl -X POST -H "Content-Type: application/json" -d '${errorPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                        """
                        error("Build for staging failed")
                    }
                }
            }
        }

        // Stage Deploy to Staging
        stage("Deploy to Staging") {
            steps {
                script {
                    try {
                        sshagent(['SSH_KEY']) {
                            sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                            cd ${dir}
                            docker pull ${images}:staging
                            docker stop backend_staging || true
                            docker rm backend_staging || true
                            docker run -d --name backend_staging -p 5000:5000 ${images}:staging
                            echo "Deploy to Staging Sukses"
                            exit
                            EOF"""
                        }
                        // Kirim notifikasi sukses
                        def jsonPayload = """
                        {
                            "content": "Deployment to Staging was successful!\nImage Version: ${images}:staging\nTime: ${new Date()}",
                            "username": "Jenkins Bot"
                        }
                        """
                        sh """
                        curl -X POST -H "Content-Type: application/json" -d '${jsonPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                        """
                    } catch (Exception e) {
                        // Kirim notifikasi error
                        def errorPayload = """
                        {
                            "content": "Deployment to Staging failed: ${e.getMessage()}\nImage Version: ${images}:staging\nTime: ${new Date()}",
                            "username": "Jenkins Bot"
                        }
                        """
                        sh """
                        curl -X POST -H "Content-Type: application/json" -d '${errorPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                        """
                        error("Deployment to Staging failed")
                    }
                }
            }
        }

        // Stage Build for Production
        stage("Build for Production") {
            steps {
                script {
                    try {
                        sshagent(['SSH_KEY']) {
                            sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                            cd ${dir}
                            git pull origin main
                            docker build --cache-from=${images}:production -t ${images}:production .
                            echo "Docker Build for Production Selesai"
                            # Login ke Docker Registry
                            echo "\${DOCKER_PASSWORD}" | docker login ${docker_registry} -u "\${DOCKER_USERNAME}" --password-stdin
                            docker push ${images}:production
                            echo "Docker Push for Production Selesai"
                            exit
                            EOF"""
                        }
                        // Kirim notifikasi sukses
                        def jsonPayload = """
                        {
                            "content": "Build for Production was successful!\nImage Version: ${images}:production\nBuild Time: ${new Date()}",
                            "username": "Jenkins Bot"
                        }
                        """
                        sh """
                        curl -X POST -H "Content-Type: application/json" -d '${jsonPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                        """
                    } catch (Exception e) {
                        // Kirim notifikasi error
                        def errorPayload = """
                        {
                            "content": "Build for Production failed: ${e.getMessage()}\nBranch: 'main'\nTime: ${new Date()}",
                            "username": "Jenkins Bot"
                        }
                        """
                        sh """
                        curl -X POST -H "Content-Type: application/json" -d '${errorPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                        """
                        error("Build for Production failed")
                    }
                }
            }
        }

        // Stage Deploy to Production
        stage("Deploy to Production") {
            steps {
                script {
                    try {
                        sshagent(['SSH_KEY']) {
                            sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                            cd ${dir}
                            docker pull ${images}:production
                            docker stop backend_production || true
                            docker rm backend_production || true
                            docker run -d --name backend_production -p 5000:5000 ${images}:production
                            echo "Deploy to Production Sukses"
                            exit
                            EOF"""
                        }
                        // Kirim notifikasi sukses
                        def jsonPayload = """
                        {
                            "content": "Deployment to Production was successful!\nImage Version: ${images}:production\nTime: ${new Date()}",
                            "username": "Jenkins Bot"
                        }
                        """
                        sh """
                        curl -X POST -H "Content-Type: application/json" -d '${jsonPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                        """
                    } catch (Exception e) {
                        // Kirim notifikasi error
                        def errorPayload = """
                        {
                            "content": "Deployment to Production failed: ${e.getMessage()}\nImage Version: ${images}:production\nTime: ${new Date()}",
                            "username": "Jenkins Bot"
                        }
                        """
                        sh """
                        curl -X POST -H "Content-Type: application/json" -d '${errorPayload.replace("'", "\\'")}' ${DISCORD_WEBHOOK}
                        """
                        error("Deployment to Production failed")
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
