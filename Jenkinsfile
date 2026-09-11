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

                }
            }
        }
        
        stage('Build Image and push to Repo') {
            steps {
                script {

                }
            }
        }


        stage('Provision EKS cluster') {
            steps {
                script {

                }
            }
        }


        stage('Deploy MYSQL') {
            steps {
                script {

                }
            }
        }


        stage('Deploy PHPMyAdmin') {
            steps {
                script {

                }
            }
        }


        stage('Deploy company application') {
            steps {
                script {

                }
            }
        }










    }
}
