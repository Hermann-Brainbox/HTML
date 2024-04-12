pipeline {
    agent any

    environment {
        // Définition de l'image Docker à utiliser.
        DOCKER_IMAGE = "solofonore/hermann"
    }

    stages {
        stage('Checkout') {
            steps {
                // Clone le dépôt depuis GitHub
                  sh "git clone https://github.com/Hermann-Brainbox/HTML.git"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Crée l'image Docker et la tague avec la version spécifiée.
                    def imageTag = "${DOCKER_IMAGE}:v2"
                    sh "docker build -t ${imageTag} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Connexion au registre Docker.
                    withCredentials([usernamePassword(credentialsId: 'docker_hub', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                    }
                    
                    // Pousser l'image Docker vers le registre.
                    def imageTag = "${DOCKER_IMAGE}:v2"
                    sh "docker push ${imageTag}"
                }
            }
        }
    }

    post {
        always {
            // Nettoyage des ressources : déconnexion du registre Docker.
            script {
                sh "docker logout"
            }
        }
    }
}
