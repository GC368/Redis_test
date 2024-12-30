/*************************************************************************************************
// Declarative Jenkinsfile creating infrascture for redis project
**************************************************************************************************/
pipeline {
    agent any
    
    environment {
        SSH_CREDENTIALS = 'Redis_test_id' 
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
        disableConcurrentBuilds()
        durabilityHint('MAX_SURVIVABILITY')
        timeout(time: 30, unit: 'MINUTES') // Prevent long-running jobs
    }

    stages {

        stage('Connect to EC2') {
            steps {
                echo 'Connecting to EC2 instance...'
                withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS, keyFileVariable: 'SSH_KEY')]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no -i \$SSH_KEY ec2-user@3.106.140.67 'echo "Connected successfully"'
                    """
                }
            }
        }

        stage('Prepare Docker') {
            steps {
                echo 'Installing Docker on EC2 instance...'
                withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS, keyFileVariable: 'SSH_KEY')]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no -i \$SSH_KEY ec2-user@3.106.140.67 "
                            # Update the system
                            sudo dnf update -y

                            # Install Docker
                            sudo dnf install -y docker

                            # Start Docker service and enable on boot
                            sudo systemctl start docker
                            sudo systemctl enable docker

                            # Add ec2-user to the docker group
                            sudo usermod -aG docker ec2-user
                        "
                    """
                }
            }
        }

        stage('Run Redis Docker') {
            steps {
                echo 'Starting Redis in Docker container...'
                withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS, keyFileVariable: 'SSH_KEY')]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no -i \$SSH_KEY ec2-user@3.106.140.67 "
                            # Pull Redis Docker image
                            docker pull redis/redis-stack-server:latest

                            # Run Redis in Docker container
                            docker run -d --name redis-stack-server -p 6379:6379 redis/redis-stack-server:latest

                            # Test Redis is running
                            docker exec redis-stack-server redis-cli ping
                        "
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up Jenkins workspace...'
            cleanWs()
        }

        success {
            echo 'Pipeline executed successfully.'
        }

        failure {
            echo 'Pipeline failed. Please check the logs for details.'
        }
    } 
}
