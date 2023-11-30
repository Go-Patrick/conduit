pipeline {
    agent any

    environment {
        SHORT_COMMIT="${GIT_COMMIT[0..7]}"
        AWS_CREDENTIALS_ID = "patrick-demo-1"
        FE_IMAGE_NAME="turbo-fe"
        BE_IMAGE_NAME="turbo-be"
        ECR_URL="932782693588.dkr.ecr.ap-southeast-1.amazonaws.com"
        BE_URL="http://localhost:3001"
    }

    tools{
        nodejs 'node-20'
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
                            oldTaskDefinition = $(aws ecs --profile demo1 describe-task-definition --task-definition turbo-fe)

                            def content = new groovy.json.JsonSlurperClassic().parseText(oldTaskDefinition)
                            def taskDef = content.taskDefinition
                            taskDef.containerDefinitions[0].image = $newImage

                            sh '''
                            aws ecs register-task-definition --family turbo-fe --container-definitions ${taskDef}

                            aws ecs update-service --cluster turbo-fe --service turbo-fe --image=${newImage} --force-new-deployment --region ap-southeast-1
                            '''
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