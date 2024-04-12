pipeline {
    agent any

    environment {
        // Définition de l'image Docker à utiliser.
        DOCKER_IMAGE = "solofonore/hermann"
        // Chemin complet vers le répertoire des manifests Kubernetes.
        MANIFEST_DIR = '/var/jenkins_home/workspace/ops/manifest'
    }

    stages {
        stage('Checkout') {
            steps {
                // Vérifie la dernière version du code source depuis GitHub
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

        stage('Deploy') {
            steps {
                script {
                    // Appliquer le fichier de configuration Kubernetes depuis le répertoire `manifest` situé dans l'espace de travail Jenkins.
                    def manifestFilePath = "${MANIFEST_DIR}/."
                    //withEnv(["KUBECONFIG=${KUBE_CONFIG}"]) {
                        sh "kubectl apply -f ${manifestFilePath}"
                    }
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
