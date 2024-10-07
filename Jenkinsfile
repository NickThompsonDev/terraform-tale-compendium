pipeline {
    agent any
    environment {
        MINIKUBE_IP = sh(script: 'docker inspect -f "{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}" minikube', returnStdout: true).trim()
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
                    // Generate and show Terraform plan
                    sh 'terraform plan -var="minikube_ip=${MINIKUBE_IP}"'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('local') {
                    // Apply the changes to the Minikube cluster
                    sh 'terraform apply -auto-approve -var="minikube_ip=${MINIKUBE_IP}"'
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
