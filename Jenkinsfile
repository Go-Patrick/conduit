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
        jdk 'jdk-17'
        maven 'my-maven'
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
                            feImage.push()
                        }
                    } catch (Exception e) {
                        echo "Caught exception: ${e}"
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
                            newImage="${env.ECR_URL}/${env.FE_IMAGE_NAME}:${env.SHORT_COMMIT}"
                            def oldTaskDefinition = sh(script: 'aws ecs describe-task-definition --task-definition turbo-fe', returnStdout: true).trim()

                            def json = readJSON text: oldTaskDefinition
                            def taskDefinition = json.taskDefinition
                            taskDefinition.containerDefinitions[0].image = "${newImage}"

                            echo "Updated Task Definition: ${updatedTaskDefinition}"

                            def registerOutput = sh(script: "aws ecs register-task-definition --cli-input-json '${taskDefinition}' --region ap-southeast-1", returnStdout: true).trim()

                            echo "Register Output: ${registerOutput}"

                            sh "aws ecs update-service --cluster turbo-fe --service turbo-fe --task-definition ${registerOutput.taskDefinition.taskDefinitionArn} --force-new-deployment --region ap-southeast-1"
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