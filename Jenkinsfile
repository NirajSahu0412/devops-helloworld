pipeline {

    agent any

    options {
        timestamps()
        skipDefaultCheckout(true)
    }

    environment {
        IMAGE_NAME = 'helloworld-app'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build and Test') {
            steps {
                echo 'Compiling and testing Java application'

                sh '''
                    docker run --rm \
                    -v "$WORKSPACE":/app \
                    -w /app \
                    eclipse-temurin:21-jdk \
                    sh -c "javac HelloWorld.java && java HelloWorld"
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image'

                sh '''
                    docker build \
                    -t ${IMAGE_NAME}:${BUILD_NUMBER} .
                '''
            }
        }

        stage('Deploy Container') {
            steps {
                echo 'Deploying application container'

                sh '''
                    docker rm -f helloworld-container \
                    >/dev/null 2>&1 || true

                    docker run \
                    --name helloworld-container \
                    ${IMAGE_NAME}:${BUILD_NUMBER}

                    docker inspect \
                    --format='Container exit code: {{.State.ExitCode}}' \
                    helloworld-container
                '''
            }
        }
    }

    post {
        success {
            echo 'SUCCESS: Application deployed successfully!'
        }

        failure {
            echo 'FAILURE: Please check the Jenkins console output.'
        }
    }
}
