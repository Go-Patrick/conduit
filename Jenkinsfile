pipeline {
    agent any

    environment {
        SHORT_COMMIT="${GIT_COMMIT[0..7]}"
        AWS_CREDENTIALS_ID = "patrick-demo-1"
        FE_IMAGE_NAME="turbo-fe"
        BE_IMAGE_NAME="turbo-be"
        ECR_URL="932782693588.dkr.ecr.ap-southeast-1.amazonaws.com"
        BE_URL="http://turbo-be-prod-1442580070.ap-southeast-1.elb.amazonaws.com"
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

        stage('Set Deploy Environment') {
            steps {
                script {
                    if (env.BRANCH_NAME  == 'dev') {
                        env.DEPLOY_ENV = 'dev'
                    } else {
                        env.DEPLOY_ENV = 'prod'
                    }
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

        stage('Build backend image'){
            when {
                anyOf {
                    branch 'main'
                    branch 'dev'
                }
            }
            steps{
                script{
                    try{
                        docker.withRegistry("https://" + "${env.ECR_URL}/${env.BE_IMAGE_NAME}-${DEPLOY_ENV}", 'ecr:ap-southeast-1:patrick-demo-1') {
                            def BE_IMAGE_NAME="${env.ECR_URL}/${env.BE_IMAGE_NAME}-${DEPLOY_ENV}:${env.SHORT_COMMIT}"
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
            when {
                anyOf {
                    branch 'main'
                    branch 'dev'
                }
            }
            steps{
                script{
                    try{
                        withAWS(credentialsId: "${env.AWS_CREDENTIALS_ID}") {
                            sh 'aws ecs update-service --cluster turbo-be-${DEPLOY_ENV} --service turbo-be-${DEPLOY_ENV} --force-new-deployment'
                        }
                    } catch (Exception e){
                        echo "Caught exception:  ${e}"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        stage('Build frontend image'){
            when {
                anyOf {
                    branch 'main'
                    branch 'dev'
                }
            }
            steps{
                script{
                    try{
                        docker.withRegistry("https://" + "${env.ECR_URL}/${env.FE_IMAGE_NAME}-${DEPLOY_ENV}", 'ecr:ap-southeast-1:patrick-demo-1') {
                            def FE_IMAGE_NAME="${env.ECR_URL}/${env.FE_IMAGE_NAME}-${DEPLOY_ENV}:${env.SHORT_COMMIT}"
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

        stage('Deploy new frontend version'){
            when {
                anyOf {
                    branch 'main'
                    branch 'dev'
                }
            }
            steps{
                script{
                    try{
                        withAWS(credentialsId: "${env.AWS_CREDENTIALS_ID}") {
                            sh 'aws ecs update-service --cluster turbo-fe-${DEPLOY_ENV} --service turbo-fe-${DEPLOY_ENV} --force-new-deployment'
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