pipeline {
    agent any

    environment {
        IMAGE_NAME = "velzaros/jenkins-sample:latest"
        CONTAINER_NAME = "jenkins-sample"
        DEPLOY_PORT = "8081"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/velzaros/jenkins-sample.git'
            }
        }

        stage('Build') {
            steps {
                sh '''
                    echo "🏗️ Building application..."
                    chmod +x build.sh
                    ./build.sh
                    echo "✅ Build complete!"
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'velzaros', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "🔑 Logging in to Docker Hub..."
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        echo "📦 Building Docker image..."
                        docker build -t $IMAGE_NAME .
                        echo "⬆️ Pushing image to Docker Hub..."
                        docker push $IMAGE_NAME
                        docker logout
                    '''
                }
            }
        }

        stage('Deploy to Local Docker') {
            steps {
                sh '''
                    echo "🚀 Deploying container locally..."
                    docker pull $IMAGE_NAME

                    echo "🧱 Removing old container (if exists)..."
                    docker stop $CONTAINER_NAME || true
                    docker rm $CONTAINER_NAME || true

                    echo "🧱 Starting new container..."
                    docker run -d --name $CONTAINER_NAME -p $DEPLOY_PORT:80 $IMAGE_NAME

                    echo "🕒 Waiting for healthcheck..."
                    sleep 15

                    HEALTH=$(docker inspect --format='{{json .State.Health.Status}}' $CONTAINER_NAME || echo "null")
                    echo "Container health: $HEALTH"

                    if [ "$HEALTH" != '"healthy"' ]; then
                        echo "❌ Deployment failed! Rolling back..."
                        docker stop $CONTAINER_NAME
                        docker rm $CONTAINER_NAME
                        docker run -d --name $CONTAINER_NAME -p $DEPLOY_PORT:80 $IMAGE_NAME
                        exit 1
                    fi

                    echo "✅ Deployment successful!"
                '''
            }
        }
    }

    post {
        success {
            echo '🎉 Pipeline completed successfully!'
        }
        failure {
            echo '🚨 Pipeline failed! Please check logs.'
        }
    }
}
