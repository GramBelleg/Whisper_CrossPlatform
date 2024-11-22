pipeline {
    agent any
    options {
        disableConcurrentBuilds()
        timeout(time: 3, unit: 'HOURS')
    }
    environment {
        JOB_PATH = "/home/azureuser/Whisper_Devops/jenkins/jenkins_home/workspace/whisperCrossPlatform_${BRANCH_NAME}"
        AZURE_STORAGE_ACCOUNT=credentials('azureStorageAccount')
        AZURE_STORAGE_KEY=credentials('azureStorageKey')
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('testing') {
            steps {
                sh """
                echo "******* testing ********"
                docker run --rm -v "${JOB_PATH}/whisper:/app" \
                    -w /app grambell003/flutter_sdk_image:latest /bin/bash \
                        -c "flutter pub get && \
                            flutter test 'test/production-test.dart'" > testsLogs.txt
                """
            }
        }

        stage('building apk') {
            when {
                branch 'production'
            }
            steps {
                sh 'echo "******* building the apk ********"'
                sh """
                docker run --rm -v "${JOB_PATH}/whisper:/app" \
                    -w /app grambell003/flutter_sdk_image:latest /bin/bash \
                        -c "flutter clean && flutter build apk"
                """
            }
        }

        stage('Deploying') {
            when {
                branch 'production'
            }
            steps {
                sh """
                echo "******* deploying ********"
                az storage blob upload --account-name $AZURE_STORAGE_ACCOUNT \
                    --account-key $AZURE_STORAGE_KEY --container-name container1 \
                            --file build/app/outputs/flutter-apk/app-release.apk --name flutterApk.apk
                """
            }
        }

    }
    post {
        always {
            emailext (
                    subject: "Build Notification: ${JOB_NAME} #${BUILD_NUMBER} [${BRANCH_NAME}]",
                    body: """
                        The build for ${BRANCH_NAME} has completed.
                        - Job Name: ${JOB_NAME}
                        - Build Number: ${BUILD_NUMBER}
                        - Build Status: ${currentBuild.result ?: 'SUCCESS'}
                
                    """,
                    to: "grambell.whisper@gmail.com",
                    attachmentsPattern: "testsLogs.txt"
            )
            echo 'Cleaning up the workspace...'
            cleanWs()
        }
    }   
}