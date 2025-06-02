pipeline {
    agent any

    environment {
        DOCKER_HOST_IP = "44.218.245.222"
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

        stage('Prepare Remote Directory & Copy Files') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'KEY')]) {
                    bat """
                    REM Fix SSH private key permissions
                    icacls "%KEY%" /inheritance:r
                    icacls "%KEY%" /grant:r "%USERNAME%:R"

                    ssh -i %KEY% -o StrictHostKeyChecking=no %DOCKER_USER%@%DOCKER_HOST_IP% "rmdir /s /q %DOCKER_APP_DIR% & mkdir %DOCKER_APP_DIR%"
                    scp -i %KEY% -o StrictHostKeyChecking=no -r * %DOCKER_USER%@%DOCKER_HOST_IP%:%DOCKER_APP_DIR%/
                    """
                }
            }
        }

        stage('Build Docker Image on Remote Host') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'KEY')]) {
                    bat """
                    REM Fix SSH private key permissions
                    icacls "%KEY%" /inheritance:r
                    icacls "%KEY%" /grant:r "%USERNAME%:R"

                    ssh -i %KEY% -o StrictHostKeyChecking=no %DOCKER_USER%@%DOCKER_HOST_IP% "cd %DOCKER_APP_DIR% && docker build -t %IMAGE_NAME% ."
                    """
                }
            }
        }

        stage('Run Docker Container on Remote Host') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'KEY')]) {
                    bat """
                    REM Fix SSH private key permissions
                    icacls "%KEY%" /inheritance:r
                    icacls "%KEY%" /grant:r "%USERNAME%:R"

                    ssh -i %KEY% -o StrictHostKeyChecking=no %DOCKER_USER%@%DOCKER_HOST_IP% "docker rm -f %CONTAINER_NAME% || exit 0 && docker run -d -p 3000:3000 --name %CONTAINER_NAME% %IMAGE_NAME%"
                    """
                }
            }
        }

        stage('Selenium Tests') {
            steps {
                bat """
                echo Running Selenium tests...
                REM Add your Selenium test commands here, e.g.:
                REM python3 -m unittest test_app.py
                """
            }
        }
    }
}
