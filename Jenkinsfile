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
                script {
                    // Supprimer le dernier répertoire cloné (s'il existe)
                    sh "rm -rf HTML"

                    // Cloner le dépôt depuis GitHub
                    sh "git clone https://github.com/Hermann-Brainbox/HTML.git"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Chemin vers le répertoire contenant le Dockerfile
                    dir('HTML') {
                        // Créer l'image Docker et la taguer avec la version spécifiée.
                        def imageTag = "${DOCKER_IMAGE}:v3"
                        sh "docker build -t ${imageTag} ."
                    }
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
                    def imageTag = "${DOCKER_IMAGE}:v3"
                    sh "docker push ${imageTag}"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Appliquer le fichier de configuration Kubernetes depuis le répertoire `manifest`
                    def manifestFilePath = "${MANIFEST_DIR}/." // Remplacez `your-k8s-manifest.yaml` par le nom de votre fichier YAML

                    // Appliquer le fichier YAML
                    sh "kubectl apply -f ${manifestFilePath}"
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
