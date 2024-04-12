pipeline {
    agent any

    environment {
        // Définition de l'image Docker à utiliser.
        DOCKER_IMAGE = "solofonore/hermann:v2"
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

        stage('Build Docker Image') {
            steps {
                script {
                    dir('HTML') {
                        // Construire l'image Docker et la taguer avec la version spécifiée.
                        sh "docker build -t ${DOCKER_IMAGE} ."
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
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Appliquer le fichier de configuration Kubernetes.
                    def manifestFilePath = "${MANIFEST_DIR}/deploye.yaml" // Remplacez `your-k8s-manifest.yaml` par le nom de votre fichier YAML
                     def manifestFilePath1 = "${MANIFEST_DIR}/service.yaml"

                    // Appliquer le fichier YAML
                    sh "kubectl apply -f ${manifestFilePath}"
                    sh "kubectl apply -f ${manifestFilePath1}"
                }
            }
        }
    }

    post {
        always {
            script {
                // Nettoyage des ressources : déconnexion du registre Docker.
                sh "docker logout"
            }
        }
    }
}
