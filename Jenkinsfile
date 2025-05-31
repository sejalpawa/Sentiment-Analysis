pipeline {
    agent any

    environment {
        DOCKER_HOST_IP = "54.196.66.38"
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
                bat """
                    echo Copying files to remote host...
                    pscp -r -pw YOUR_PASSWORD * %DOCKER_USER%@%DOCKER_HOST_IP%:/home/%DOCKER_USER%/%DOCKER_APP_DIR%

                    echo Building Docker image on remote host...
                    plink -pw YOUR_PASSWORD %DOCKER_USER%@%DOCKER_HOST_IP% ^
                        "cd %DOCKER_APP_DIR% && docker build -t %IMAGE_NAME% ."
                """
            }
        }

        stage('Run Docker Container') {
            steps {
                bat """
                    echo Running Docker container on remote host...
                    plink -pw YOUR_PASSWORD %DOCKER_USER%@%DOCKER_HOST_IP% ^
                        "docker rm -f %CONTAINER_NAME% || true && docker run -d -p 3000:3000 --name %CONTAINER_NAME% %IMAGE_NAME%"
                """
            }
        }

        stage('Selenium Tests') {
            steps {
                bat """
                    echo Running Selenium tests...
                    REM Add your Windows-based Selenium test commands here
                    REM Example: python -m unittest test_app.py
                """
            }
        }
    }
}
