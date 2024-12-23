/*************************************************************************************************
// Declarative Jenkinsfile creating infrascture for redis project
**************************************************************************************************/
pipeline {
    agent any

    // environment {
    //     WORKING_DIR = "Redis"
    //     AWS_CREDENTIALS = credentials('aws-test-key')
    //     ENV = "uat"
    // }

    parameters {
        booleanParam(name: 'destroy', defaultValue: false, description: 'Destroy Terraform build?')
    }

    options {
        // Keep maximum 10 archived artifacts
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
        // No simultaneous builds
        disableConcurrentBuilds()
        durabilityHint('MAX_SURVIVABILITY') // PERFORMANCE_OPTIMIZED or SURVIVABLE_NONATOMIC
    }

    stages {
        stage('Terraform Init & Plan') {
            steps {
                dir(WORKING_DIR) {
                    // withVault(configuration: [timeout: 60, vaultCredentialId: 'Vault Credential', vaultUrl: 'https://vault.jiangren.com.au'], vaultSecrets: [[path: 'secret_aws/aws_uat', secretValues: [[vaultKey: 'AWS_ACCESS_KEY_ID'], [vaultKey: 'AWS_SECRET_ACCESS_KEY']]]]) {    
                    withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS, keyFileVariable: 'SSH_KEY')]) {                    
                        sh '''
                        cd $ENV
                        terraform init
                        terraform plan -out=tfplan
                        '''
                    }
                }
            }
        }

        stage('Terraform Apply') {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            steps {
                dir(WORKING_DIR) {
                    withVault(configuration: [timeout: 60, vaultCredentialId: 'Vault Credential', vaultUrl: 'https://vault.jiangren.com.au'], vaultSecrets: [[path: 'secret_aws/aws_uat', secretValues: [[vaultKey: 'AWS_ACCESS_KEY_ID'], [vaultKey: 'AWS_SECRET_ACCESS_KEY']]]]) {                        
                        // Ask for user approval before applying
                        script {
                            def userInput = input(
                                id: 'UserApproval',
                                message: 'Do you want to proceed with the Terraform apply?',
                                parameters: [[$class: 'BooleanParameterDefinition', name: 'Proceed', defaultValue: true]]
                            )

                            // Proceed with terraform apply if approved
                            if (userInput) {
                                sh '''
                                cd $ENV
                                terraform apply -auto-approve tfplan
                                '''
                            } else {
                                echo 'Terraform apply was not approved. Exiting.'
                                error('User did not approve the apply step.')
                            }
                        }
                    }
                }
            }
        }

    post {
        always {
            // clean workspace
            cleanWs()
        }
        success {
            bitbucketStatusNotify(buildState: 'SUCCESSFUL')
            echo 'Success.'
        }
        failure {
            bitbucketStatusNotify(buildState: 'FAILED')
            echo 'Failure.'
        }
    }
}
