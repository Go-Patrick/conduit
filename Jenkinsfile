pipeline {
    agent any

    environment {
        SHORT_COMMIT="${GIT_COMMIT[0..7]}"
        AWS_CREDENTIALS_ID = "patrick-demo-1"
        FE_IMAGE_NAME="turbo-fe"
        BE_IMAGE_NAME="turbo-be"
        FE_ECR_URL=
        BE_ECR_URL=
        BE_URL=
    }

    tools{
        nodejs 'node-20'
    }

    stages {
        stage ('Checkout scm'){
            checkout scm
        }

        stage ('Run test'){
            sh 'yarn install'
            sh 'yarn test'
        }

        stage('Build frontend image'){
            script{
                try{
                    docker.withRegistry("https://" + "${env.FE_ECR_URL}", 'ecr:ap-southeast-1:patrick-demo-1') {
                        def FE_IMAGE_NAME="${env.ECR_URL}/${env.FE_IMAGE_NAME}:${env.SHORT_COMMIT}"
                        def feImage = docker.build("$IMAGE_NAME", "--build-arg NEXT_PUBLIC_BASE_URL=${env.BE_URL} -f apps/frontend/Dockerfile .")
                        feImage.push()
                    }
                } catch (Exception e) {
                    echo "Caught exception: ${e}"
                    currentBuild.result = 'FAILURE'
                }
            }
        }

        stage('Deploy new frontend version'){
            script{
                try{
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]){
                        sh '''
                        cd deploy
                        aws ecs update-service --cluster turbo-fe --service turbo-fe --force-new-deployment --region ap-southeast-1
                        '''
                    }
                } catch (Exception e){
                    echo "Caught exception: ${e}"
                    currentBuild.result = 'FAILURE'
                }
            }
        }
    }
}