pipeline {
    agent any

    parameters {
        string(name: 'IMAGE_TAG', defaultValue: 'v1.0', description: 'Tag for the Docker image')
    }

    tools {
        maven 'Maven 3.9.9'
        dockerTool 'Docker'
    }

    stages {
        stage('Build') {
            steps {
                script {
                    bat 'mvn clean install'
                }
            }
        }

        stage('Start Eureka and Dependencies') {
            steps {
                script {
                    bat 'docker-compose up -d eureka-server'
                    sleep 30 // Wait for Eureka to start
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    bat 'mvn test'
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    bat "docker build -t mixaron/eureka-server:${params.IMAGE_TAG} ."
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-hub-credentials', url: '') {
                        bat "docker push mixaron/eureka-server:${params.IMAGE_TAG}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    bat 'docker-compose up -d'
                }
            }
        }

        stage('Stop Eureka and Dependencies') {
            steps {
                script {
                    bat 'docker-compose down'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
