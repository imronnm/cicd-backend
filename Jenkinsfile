def secret = 'SSH_KEY'
def vmapps = 'team1@34.101.126.235'
def dir    = '~/team1-docker/backend'
def branch = 'main'
def tag    = 'latest'

pipeline {
    agent any
    stages {
        stage ("pull") {
           steps {
               sshagent([secret]){
                  sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                  cd ${dir}
                  git pull origin ${branch}
                  echo "Git Pull Telah Selesai"
                  exit
                  EOF"""
                }
            }
        }
        stage ("docker build") {
           steps {
               sshagent([secret]){
                  sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                  cd ${dir}
                  docker build -t ${images}:${tag} .
                  echo "installation dependencies telah selesai"
                  exit
                  EOF"""
                }
            }
        }
        stage ("run") {
           steps {
               sshagent([secret]){
                  sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                  cd ${dir}
                  docker compose up -d
                  echo "apllication already run"
                  exit
                  EOF"""
                }
            }
        }
    }                           
}
