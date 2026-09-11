#!/usr/bin/env groovy

library identifier: 'jenkins-exercises-shared-library@master', retriever: modernSCM (
    [$class: 'GitSCMSource',
    remote: 'https://gitlab.com/mikey101/jenkins-exercises-shared-library.git',
    credentialsId: 'gitlab-credentials'
    ]
)


pipeline {
    agent any


    environment {
        IMAGE_NAME = 'michael101/java-maven-app:company-app-1.0'

    }

    tools {
            gradle 'gradle-9.8.0'
            jdk 'jdk-21'
     }

    stages {


        stage('Build App') {
            steps {
                script {
                    echo "Building the app"
                    sh 'gradle build'

                }
            }
        }
        
        stage('Build Image and push to Repo') {
            steps {
                script {
                    echo "Building image and pushing to repo"
                    buildDockerImage(env.IMAGE_NAME)
                    dockerLogin('docker-hub-repo')
                    dockerPush(env.IMAGE_NAME)

                }
            }
        }


        stage('Provision EKS cluster') {
            steps {
                script {
                    echo "Provisioning EKS cluster"
                }
            }
        }


        stage('Deploy MYSQL') {
            steps {
                script {
                        echo "Deploying MYSQL"
                }
            }
        }


        stage('Deploy PHPMyAdmin') {
            steps {
                script {
                    echo "Deploying PHPMyAdmin"
                }
            }
        }


        stage('Deploy company application') {
            steps {
                script {
                    echo "Deploying company application"
                }
            }
        }










    }
}
