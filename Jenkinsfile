pipeline {
    agent any

    environment {
        DOCKER_HOST_IP = "51.20.143.145"
        DOCKER_USER = "ubuntu"
        DOCKER_APP_DIR = "Sentiment-Analysis"
        IMAGE_NAME = "sentiment-analysis-app"
        CONTAINER_NAME = "sentiment-analysis-container"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/sejalpawa/Sentiment-Analysis.git'
            }
        }

        stage('Copy to Remote & Build Docker Image') {
            steps {
                sh '''
                    echo "Copying files to remote host..."
                    scp -o StrictHostKeyChecking=no -r . ${DOCKER_USER}@${DOCKER_HOST_IP}:${DOCKER_APP_DIR}

                    echo "Building Docker image on remote host..."
                    ssh -o StrictHostKeyChecking=no ${DOCKER_USER}@${DOCKER_HOST_IP} '
                        cd ${DOCKER_APP_DIR} &&
                        docker build -t ${IMAGE_NAME} .
                    '
                '''
            }
        }

        stage('Run Docker Container') {
            steps {
                sh '''
                    echo "Running Docker container on remote host..."
                    ssh -o StrictHostKeyChecking=no ${DOCKER_USER}@${DOCKER_HOST_IP} '
                        docker rm -f ${CONTAINER_NAME} || true &&
                        docker run -d -p 3000:3000 --name ${CONTAINER_NAME} ${IMAGE_NAME}
                    '
                '''
            }
        }

        stage('Selenium Tests') {
            steps {
                sh '''
                    echo "Running Selenium tests..."
                    # Add your Selenium test commands here
                    # e.g., python3 -m unittest test_app.py
                '''
            }
        }
    }
}
