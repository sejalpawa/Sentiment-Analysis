pipeline {
    agent any

    environment {
        DOCKER_HOST_IP = "52.91.69.5"
        DOCKER_USER = "ubuntu"
        DOCKER_APP_DIR = "Sentiment-Analysis"
        IMAGE_NAME = "sentiment-analysis-app"
        CONTAINER_NAME = "sentiment-analysis-container"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'master', url: 'https://github.com/sejalpawa/Sentiment-Analysis.git'
            }
        }

        stage('Prepare Remote Directory & Copy Files') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'KEY')]) {
                    bat """
                    ssh -i \$KEY -o StrictHostKeyChecking=no ${DOCKER_USER}@${DOCKER_HOST_IP} '
                        rm -rf ${DOCKER_APP_DIR} && mkdir -p ${DOCKER_APP_DIR}
                    '

                    scp -i \$KEY -o StrictHostKeyChecking=no -r * ${DOCKER_USER}@${DOCKER_HOST_IP}:${DOCKER_APP_DIR}/
                    """
                }
            }
        }

        stage('Build Docker Image on Remote Host') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'KEY')]) {
                    bat """
                    ssh -i \$KEY -o StrictHostKeyChecking=no ${DOCKER_USER}@${DOCKER_HOST_IP} '
                        cd ${DOCKER_APP_DIR} &&
                        docker build -t ${IMAGE_NAME} .
                    '
                    """
                }
            }
        }

        stage('Run Docker Container on Remote Host') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'KEY')]) {
                    bat """
                    ssh -i \$KEY -o StrictHostKeyChecking=no ${DOCKER_USER}@${DOCKER_HOST_IP} '
                        docker rm -f ${CONTAINER_NAME} || true &&
                        docker run -d -p 3000:3000 --name ${CONTAINER_NAME} ${IMAGE_NAME}
                    '
                    """
                }
            }
        }

        stage('Selenium Tests') {
            steps {
                bat """
                echo "Running Selenium tests..."
                # Add your Selenium test commands here, e.g.:
                # python3 -m unittest test_app.py
                """
            }
        }
    }
}
