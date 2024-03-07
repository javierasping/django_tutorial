pipeline {
    agent none
    stages {
        stage ('Testing django') { 
            agent { 
                docker { image 'python:3.12'
                args '-u root:root'
                }
            }
            stages {
                stage('Clone') {
                    steps {
                        git branch:'master',url:'https://github.com/Juanmanueldupi/django_tutorial.git'
                    }
                }
                stage('Install') {
                    steps {
                        sh 'pip install -r requirements.txt'
                    }
                }
                stage('Test') {
                    steps {
                        sh 'python3 manage.py test'
                    }
                } 
            }
        }
        stage('Using new settings.py') {
            agent any
            steps {
                cp django_tutorial/settings.bak django_tutorial/settings.py
                    }
                }
            } 
        }
        stage('Upload img') {
            agent any
            stages {
                stage('Build and push') {
                    steps {
                        script {
                            withDockerRegistry([credentialsId: 'DOCKER_HUB', url: '']) {
                            def dockerImage = docker.build("jmdpsysadmin/django_tutorial:${env.BUILD_ID}")
                            dockerImage.push()
                            }
                        }
                    }
                }
                stage('Remove image') {
                    steps {
                        script {
                            sh "docker rmi jmdpsysadmin/django_tutorial:${env.BUILD_ID}"
                        }
                    }
                }
                stage ('SSH') {
                    steps{
                        sshagent(credentials : ['ssh_key']) {
                            sh 'ssh -o StrictHostKeyChecking=no debian@vps.jduranasir.site wget https://raw.githubusercontent.com/Juanmanueldupi/django_tutorial/master/docker-compose.yaml -O docker-compose.yaml'
                            sh 'ssh -o StrictHostKeyChecking=no debian@vps.jduranasir.site docker compose up -d --force-recreate'
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            mail to: 'juanmadupi@gmail.com',
            subject: "Status of pipeline: ${currentBuild.fullDisplayName}",
            body: "${env.BUILD_URL} has result ${currentBuild.result}"
        }
    }
}
