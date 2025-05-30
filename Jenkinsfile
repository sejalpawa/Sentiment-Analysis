pipeline {
    agent any

    environment {
        DOCKER_HOST_IP = "51.20.143.145"
        DOCKER_USER = "ubuntu"
        DOCKER_APP_DIR = "Sentiment-Analysis"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/sejalpawa/Sentiment-Analysis.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    scp -o StrictHostKeyChecking=no -r . ${DOCKER_USER}@${DOCKER_HOST_IP}:${DOCKER_APP_DIR}
                    ssh -o StrictHostKeyChecking=no ${DOCKER_USER}@${DOCKER_HOST_IP} '
                        cd ${DOCKER_APP_DIR} &&
                        docker build -t sentiment-analysis-node .
                    '
                """
            }
        }

        stage('Run Container') {
            steps {
                sh """
                    ssh ${DOCKER_USER}@${DOCKER_HOST_IP} '
                        docker rm -f sentiment-analysis-container || true &&
                        docker run -d -p 3000:3000 --name sentiment-analysis-container sentiment-analysis-node
                    '
                """
            }
        }

        stage('Selenium UI Test') {
            steps {
                sh """
                    ssh ${DOCKER_USER}@${DOCKER_HOST_IP} '
                        cd ${DOCKER_APP_DIR} &&
                        python3 selenium_test.py
                    '
                """
            }
        }
    }
}
