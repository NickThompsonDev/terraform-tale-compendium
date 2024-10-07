pipeline {
    agent any
    environment {
        MINIKUBE_IP = sh(script: 'docker inspect -f "{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}" minikube', returnStdout: true).trim()

        // Secrets stored in Jenkins Credentials
        DATABASE_USER = "user"
        DATABASE_PASSWORD = credentials('DATABASE_PASSWORD')
        DATABASE_NAME = "mydatabase"

        // These will use the Minikube IP
        NEXT_PUBLIC_API_URL = "http://${MINIKUBE_IP}:5000/api"
        NEXT_PUBLIC_WEBAPP_URL = "http://${MINIKUBE_IP}:3000"

        // Ingress TLS secret for HTTPS
        TLS_SECRET_NAME = "tls-secret"
    }
    parameters {
        string(name: 'SERVICE', defaultValue: '', description: 'Specify the service to deploy: api or webapp')
    }
    stages {
        stage('Install Terraform') {
            steps {
                script {
                    // Download and install Terraform if not available
                    sh """
                    if ! [ -x "\$(command -v terraform)" ]; then
                      echo "Terraform not found, installing..."
                      curl -LO https://releases.hashicorp.com/terraform/1.5.4/terraform_1.5.4_linux_amd64.zip
                      mkdir -p /tmp/terraform-install
                      unzip -o terraform_1.5.4_linux_amd64.zip -d /tmp/terraform-install
                      mv /tmp/terraform-install/terraform /usr/local/bin/terraform
                      rm -rf /tmp/terraform-install terraform_1.5.4_linux_amd64.zip
                    fi
                    """
                }
            }
        }

        stage('Checkout Code') {
            steps {
                // Checkout the Terraform repository
                git url: 'https://github.com/NickThompsonDev/terraform-tale-compendium.git', branch: 'master'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('local') {
                    // Initialize Terraform
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('local') {
                    script {
                        if (params.SERVICE == 'api') {
                            // Generate and show Terraform plan for API only
                            sh """
                            terraform plan \
                              -target=kubernetes_deployment.api \
                              -var="minikube_ip=${MINIKUBE_IP}" \
                              -var="DATABASE_USER=${DATABASE_USER}" \
                              -var="DATABASE_PASSWORD=${DATABASE_PASSWORD}" \
                              -var="DATABASE_NAME=${DATABASE_NAME}" \
                              -var="NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL}" \
                              -var="tls_secret_name=${TLS_SECRET_NAME}"
                            """
                        } else if (params.SERVICE == 'webapp') {
                            // Generate and show Terraform plan for Webapp only
                            sh """
                            terraform plan \
                              -target=kubernetes_deployment.webapp \
                              -var="minikube_ip=${MINIKUBE_IP}" \
                              -var="NEXT_PUBLIC_WEBAPP_URL=${NEXT_PUBLIC_WEBAPP_URL}" \
                              -var="tls_secret_name=${TLS_SECRET_NAME}"
                            """
                        } else {
                            // Generate and show Terraform plan for both API and Webapp
                            sh """
                            terraform plan \
                              -var="minikube_ip=${MINIKUBE_IP}" \
                              -var="DATABASE_USER=${DATABASE_USER}" \
                              -var="DATABASE_PASSWORD=${DATABASE_PASSWORD}" \
                              -var="DATABASE_NAME=${DATABASE_NAME}" \
                              -var="NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL}" \
                              -var="NEXT_PUBLIC_WEBAPP_URL=${NEXT_PUBLIC_WEBAPP_URL}" \
                              -var="tls_secret_name=${TLS_SECRET_NAME}"
                            """
                        }
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('local') {
                    script {
                        if (params.SERVICE == 'api') {
                            // Apply the changes to the API only
                            sh """
                            terraform apply -auto-approve \
                              -target=kubernetes_deployment.api \
                              -var="minikube_ip=${MINIKUBE_IP}" \
                              -var="DATABASE_USER=${DATABASE_USER}" \
                              -var="DATABASE_PASSWORD=${DATABASE_PASSWORD}" \
                              -var="DATABASE_NAME=${DATABASE_NAME}" \
                              -var="NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL}" \
                              -var="tls_secret_name=${TLS_SECRET_NAME}"
                            """
                        } else if (params.SERVICE == 'webapp') {
                            // Apply the changes to the Webapp only
                            sh """
                            terraform apply -auto-approve \
                              -target=kubernetes_deployment.webapp \
                              -var="minikube_ip=${MINIKUBE_IP}" \
                              -var="NEXT_PUBLIC_WEBAPP_URL=${NEXT_PUBLIC_WEBAPP_URL}" \
                              -var="tls_secret_name=${TLS_SECRET_NAME}"
                            """
                        } else {
                            // Apply the changes for both API and Webapp
                            sh """
                            terraform apply -auto-approve \
                              -var="minikube_ip=${MINIKUBE_IP}" \
                              -var="DATABASE_USER=${DATABASE_USER}" \
                              -var="DATABASE_PASSWORD=${DATABASE_PASSWORD}" \
                              -var="DATABASE_NAME=${DATABASE_NAME}" \
                              -var="NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL}" \
                              -var="NEXT_PUBLIC_WEBAPP_URL=${NEXT_PUBLIC_WEBAPP_URL}" \
                              -var="tls_secret_name=${TLS_SECRET_NAME}"
                            """
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Terraform pipeline finished.'
        }
        success {
            echo 'Terraform applied successfully!'
        }
        failure {
            echo 'Terraform failed to apply.'
        }
    }
}
