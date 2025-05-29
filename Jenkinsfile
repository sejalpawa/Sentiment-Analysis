 pipeline {
    agent any
    environment {
        DOCKER_HOST_IP = "your-docker-ec2-ip"
        DOCKER_USER = "ubuntu"
        DOCKER_APP_DIR = "Sentimet_Analysis"
    }
    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/ArunSadalgekar07/devops.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh """
                    scp -o StrictHostKeyChecking=no -r . ${DOCKER_USER}@${DOCKER_HOST_IP}:${DOCKER_A
                    ssh -o StrictHostKeyChecking=no ${DOCKER_USER}@${DOCKER_HOST_IP} '
                        cd ${DOCKER_APP_DIR} &&
                        docker build -t vite-chat-app .
                    '
                """
            }
        }
        stage('Run Container') {
            steps {
                sh """
                    ssh ${DOCKER_USER}@${DOCKER_HOST_IP} '
                        docker rm -f vite-chat-container || true &&
                        docker run -d -p 3000:3000 --name vite-chat-container vite-chat-app
                    '
                """
            }
        }
        stage('Selenium Tests') {
            steps {
                sh """
                    # Clone test repo or use local test scripts
                    # Example: run headless Chrome test using Selenium
                    echo "Running Selenium tests..."
                    # Place your selenium test command here
                """
            }
        }
    }
 }
