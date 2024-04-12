pipeline {
    agent any

    environment {
        // Remplacez ces valeurs par vos informations d'identification et d'accès.
        DOCKER_IMAGE = "solofonore/hermann"
        //KUBE_CONFIG = '/path/to/your/kubeconfig'
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
                    // Crée l'image Docker et la tague avec la dernière version.
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
                        sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD ${DOCKER_REGISTRY}"
                    }
                    
                    // Pousser l'image Docker vers le registre.
                    def imageTag = "${DOCKER_IMAGE}:v2"
                    sh "docker push ${imageTag}"
                }
            }
        }
