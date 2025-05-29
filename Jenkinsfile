 pipeline {
    agent any
    environment {
        DOCKER_HOST_IP = "16.171.115.248"
        DOCKER_USER = "ubuntu"
        DOCKER_APP_DIR ="Sentiment_Analysis"
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
                    scp -o StrictHostKeyChecking=no -r . ${DOCKER_USER}@${DOCKER_HOST_IP}:${DOCKER_A
                    ssh -o StrictHostKeyChecking=no ${DOCKER_USER}@${DOCKER_HOST_IP} '
                        cd ${DOCKER_APP_DIR} &&
                        docker build -t "sentiment_analysis" 
                    '
                """
            }
        }
        stage('Run Container') {
            steps {
                sh """
                    ssh ${DOCKER_USER}@${DOCKER_HOST_IP} '
                        docker rm -f analysis_container || true &&
                        docker run -d -p 3000:3000 --name analysis_container sentiment_analysis
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
