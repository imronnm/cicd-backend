def secret = 'SSH_KEY'
def vmapps = 'team1@34.101.126.235'
def dir = '~/team1-docker/backend'
def images = 'imronnm/backendjenkins'
def tag = 'latest'
def docker_registry = 'docker.io'
def docker_username = 'docker_username'
def docker_password = 'docker_password'
def spider_domain = 'https://api.team1.staging.studentdumbways.my.id/login'
def discord_webhook = 'https://discord.com/api/webhooks/1288738076243263511/tF3j9enIM27eZB_NVfv_0gtXpcGm13PrYgbObobY9jDMdhZk9Z_JNHENTpA_4G9dFwJH'
def staging_branch = 'staging' // Define the staging branch name

pipeline {
    agent any
    stages {
        // Stage Build untuk Staging
        stage("build for staging") {
            steps {
                sshagent([secret]) {
                    sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                    cd ${dir}
                    git pull origin ${staging_branch}  // Use defined variable
                    echo "Git Pull Selesai"

                    // Membersihkan image yang tidak terpakai
                    docker image prune -af
                    echo "Docker image pruned"

                    // Build image untuk staging
                    docker build -t ${images}:staging .
                    echo "Docker Build Selesai untuk Staging"

                    // Login ke Docker Registry
                    echo "${docker_password}" | docker login ${docker_registry} -u ${docker_username} --password-stdin
                    echo "Docker Login Sukses"

                    // Push image Docker ke registry
                    docker push ${images}:staging
                    echo "Docker Push Sukses untuk Staging"
                    exit
                    EOF"""
                }
                // Kirim notifikasi untuk build staging sukses
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
                sshagent([secret]) {
                    sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
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
                sshagent([secret]) {
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

        // Stage Build untuk Production
        stage("build for production") {
            steps {
                sshagent([secret]) {
                    sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                    cd ${dir}
                    git pull origin main
                    echo "Git Pull Selesai untuk Production"

                    // Membersihkan image yang tidak terpakai
                    docker image prune -af
                    echo "Docker image pruned untuk Production"

                    // Build image untuk production
                    docker build -t ${images}:production .
                    echo "Docker Build Selesai untuk Production"

                    // Login ke Docker Registry
                    echo "${docker_password}" | docker login ${docker_registry} -u ${docker_username} --password-stdin
                    echo "Docker Login Sukses"

                    // Push image Docker ke registry
                    docker push ${images}:production
                    echo "Docker Push Sukses untuk Production"
                    exit
                    EOF"""
                }
                // Kirim notifikasi untuk build production sukses
                script {
                    def jsonPayload = """
                    {
                        "content": "Build for production branch was successful!",
                        "username": "Jenkins Bot"
                    }
                    """
                    sh """
                    curl -X POST -H "Content-Type: application/json" -d '${jsonPayload}' ${discord_webhook}
                    """
                }
            }
        }

        // Stage Deploy to Production
        stage("deploy to production") {
            steps {
                sshagent([secret]) {
                    sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                    cd ${dir}
                    docker compose down
                    docker pull ${images}:production
                    docker compose up -d
                    echo "Application deployed on Production"
                    exit
                    EOF"""
                }
                // Kirim notifikasi untuk deployment production sukses
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
}
