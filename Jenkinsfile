pipeline {
    agent any

    environment {
        DOCKER_HOST_IP = "44.218.245.222"   // Update if different
        DOCKER_USER = "ubuntu"
        DOCKER_APP_DIR = "Sentiment-Analysis"
        IMAGE_NAME = "sentiment-analysis-node"
        CONTAINER_NAME = "sentiment-app"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'master', url: 'https://github.com/sejalpawa/Sentiment-Analysis.git'
            }
        }

        stage('Build Docker Image on Remote Host') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'KEY')]) {
                    sh """
                        chmod 400 \$KEY

                        echo "Preparing remote directory..."
                        ssh -i \$KEY -o StrictHostKeyChecking=no ${DOCKER_USER}@${DOCKER_HOST_IP} '
                            rm -rf ${DOCKER_APP_DIR} && mkdir -p ${DOCKER_APP_DIR}
                        '

                        echo "Copying files..."
                        scp -i \$KEY -o StrictHostKeyChecking=no -r * ${DOCKER_USER}@${DOCKER_HOST_IP}:${DOCKER_APP_DIR}/

                        echo "Building Docker image..."
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
                    sh """
                        chmod 400 \$KEY

                        echo "Running Docker container..."
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
                sh """
                    echo "Running Selenium tests..."
                    # TODO: Add Selenium test commands here
                """
            }
        }
    }
}
