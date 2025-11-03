pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/velzaros/jenkins-sample.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'chmod +x build.sh'
                sh './build.sh'
            }
        }

	stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'velzaros', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "🔑 Logging in to Docker Hub..."
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker build -t velzaros/jenkins-sample:latest .
                        docker push velzaros/jenkins-sample:latest
                        docker logout
                    '''
                }
            }
	}
    }
}
