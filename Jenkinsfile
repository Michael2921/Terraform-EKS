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


        // stage('Build App') {
        //     steps {
        //         dir('java-app') {
        //         script {
        //             echo "Building the app"
        //             sh 'gradle build'

        //         }
        //         }
        //     }
        // }
        
        // stage('Build Image and push to Repo') {
        //     steps {
        //         script {
        //             echo "Building image and pushing to repo"
        //             buildDockerImage(env.IMAGE_NAME)
        //             dockerLogin('docker-hub-repo')
        //             dockerPush(env.IMAGE_NAME)

        //         }
        //     }
        // }


        stage('Provision Infrastructure (Networking + EKS)') { 

        environment {
          //  TF_VAR_cluster_name = "company-cluster"
          //  TF_VAR_region = "us-east-1"
            AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
            AWS_SECRET_ACCESS_KEY = credentials ('jenkins_aws_secret_access_key')

        }
            steps {

                dir('terraform/infrastructure') {
               
                    echo "Provisioning Infrastructie"
                    sh 'terraform init'
                    sh 'terraform plan'
                //  sh 'terraform destroy --auto-approve'
            

                

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
