pipeline {
    agent any

    environment {
        SHORT_COMMIT="${GIT_COMMIT[0..7]}"
        AWS_CREDENTIALS_ID = "patrick-demo-1"
        FE_IMAGE_NAME="turbo-fe"
        BE_IMAGE_NAME="turbo-be"
        ECR_URL="932782693588.dkr.ecr.ap-southeast-1.amazonaws.com"
        BE_URL="http://backend.turbo.backend.com:3001"
    }

    tools{
        nodejs 'node-20'
        // jdk 'jdk-17'
        // maven 'my-maven'
    }

    stages {
        stage ('Checkout scm'){
            steps {
                script{
                    checkout scm

                }
            }
        }

        // stage ('Run test'){
        //     steps{
        //         sh 'yarn set version 3.2.0'
        //         sh 'yarn install'
        //         sh 'yarn test'
        //     }
        // }

        stage('Build frontend image'){
            steps{
                script{
                    try{
                        docker.withRegistry("https://" + "${env.ECR_URL}/${env.FE_IMAGE_NAME}", 'ecr:ap-southeast-1:patrick-demo-1') {
                            def FE_IMAGE_NAME="${env.ECR_URL}/${env.FE_IMAGE_NAME}:${env.SHORT_COMMIT}"
                            def feImage = docker.build("$FE_IMAGE_NAME", "--build-arg NEXT_PUBLIC_BASE_URL=${env.BE_URL} -f apps/frontend/Dockerfile .")
                            feImage.push(env.SHORT_COMMIT)
                            feImage.push("latest")
                        }
                    } catch (Exception e) {
                        echo "Caught exception: ${e}"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        stage('Build backend image'){
            steps{
                script{
                    try{
                        docker.withRegistry("https://" + "${env.ECR_URL}/${env.BE_IMAGE_NAME}", 'ecr:ap-southeast-1:patrick-demo-1') {
                            def BE_IMAGE_NAME="${env.ECR_URL}/${env.BE_IMAGE_NAME}:${env.SHORT_COMMIT}"
                            def beImage = docker.build("$BE_IMAGE_NAME", "-f apps/backend/Dockerfile .")
                            beImage.push(env.SHORT_COMMIT)
                            beImage.push("latest")
                        }
                    } catch (Exception e) {
                        echo "Caught exception: ${e}"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        stage('Deploy new backend version'){
            steps{
                script{
                    try{
                        withAWS(credentialsId: "${env.AWS_CREDENTIALS_ID}") {
                            sh 'aws ecs update-service --cluster turbo-be --service turbo-be --force-new-deployment'
                        }
                    } catch (Exception e){
                        echo "Caught exception:  ${e}"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        stage('Deploy new frontend version'){
            steps{
                script{
                    try{
                        withAWS(credentialsId: "${env.AWS_CREDENTIALS_ID}") {
                            sh 'aws ecs update-service --cluster turbo-fe --service turbo-fe --force-new-deployment'
                        }
                    } catch (Exception e){
                        echo "Caught exception:  ${e}"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }
    }
}