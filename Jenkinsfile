pipeline {
    agent any

    environment {
        // Definisikan variabel lingkungan
        SECRET = credentials('SSH_KEY') // menggunakan kredensial SSH
        VMAPPS = 'team1@34.143.177.29'
        DIR = '~/team1-backend/backend'
        BRANCH = 'main'
        TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                // Mengambil kode dari repositori
                git branch: "${BRANCH}", url: 'https://github.com/imronnm/cicd-backend.git'
            }
        }

        stage('Build') {
            steps {
                // Menjalankan perintah build
                sh 'echo "Building the application..."'
                // Tambahkan perintah build yang sesuai jika diperlukan
                // Contoh: sh 'npm install'
            }
        }

        stage('Deploy') {
            steps {
                // Menghubungkan ke server dan mendistribusikan aplikasi
                sshagent([SECRET]) {
                    sh """
                    ssh ${VMAPPS} "mkdir -p ${DIR} && rm -rf ${DIR}/*"
                    scp -o StrictHostKeyChecking=no -r ./* ${VMAPPS}:${DIR}
                    ssh ${VMAPPS} "cd ${DIR} && docker-compose down && docker-compose up -d --build"
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
