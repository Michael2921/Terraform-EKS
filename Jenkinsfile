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


        stage('Provision EKS cluster and MYSQL') { // define credentialsId in jenkins using secret text type
        // update kubeconfig to run kubectl, but first set needed env variables
        environment {
            TF_VAR_cluster_name = "company-cluster"
            TF_VAR_region = "us-east-1"
        }
            steps {

                dir('terraform') {
                withCredentials ([
                    string(
                        credentialsId: 'mysql-root-password',
                        variable: 'TF_VAR_mysql_root_password'
                    ), 

                    string(

                        credentialsId : 'mysql-replication-password',
                        variable: 'TF_VAR_mysql_replication_password'
                    ),

                    
                    string(
                        credentialsId: 'mysql-password',
                        variable: 'TF_VAR_mysql_user_password'
                    )


                ]) {
               
                    echo "Provisioning EKS cluster"
                    sh 'terraform init'
                    sh 'terraform providers'
                    //sh 'terraform plan'
                    sh "aws eks update-kubeconfig --name ${TF_VAR_cluster_name} --region ${TF_VAR_region}"

                }

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
