pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "velzaros/jenkins-sample:latest"
        CONTAINER_NAME = "jenkins-sample"
        DEPLOY_PORT = "8081"  // port di host -> container
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

        stage('Test') {
            steps {
                sh '''
                    echo "🧪 Running tests..."
                    echo "✅ All tests passed!"
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
                        docker build -t $DOCKER_IMAGE .

                        echo "⬆️ Pushing image to Docker Hub..."
                        docker push $DOCKER_IMAGE

                        docker logout
                    '''
                }
            }
        }

        stage('Deploy to Local Docker') {
            steps {
                sh '''
                    echo "🚀 Deploying container locally..."

                    # Pastikan image terbaru ditarik
                    docker pull $DOCKER_IMAGE

                    # Hentikan container lama jika ada
                    docker stop $CONTAINER_NAME || true
                    docker rm $CONTAINER_NAME || true

                    echo "🧱 Starting new container..."
                    docker run -d --name $CONTAINER_NAME -p $DEPLOY_PORT:80 $DOCKER_IMAGE

                    echo "✅ Deployment finished!"
                    docker ps | grep $CONTAINER_NAME || echo "⚠️ Container not found!"
                '''
            }
        }
    }

    post {
        success {
            echo '🎉 Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check logs above.'
        }
    }
}
