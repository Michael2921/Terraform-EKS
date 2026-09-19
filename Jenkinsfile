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

            AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
            AWS_SECRET_ACCESS_KEY = credentials ('jenkins_aws_secret_access_key')

        }
            steps {

                dir('terraform/infrastructure') {
               
                    echo "Provisioning Infrastructure"
                    sh 'terraform init'
                 //   sh 'terraform plan'
                 //   sh 'terraform apply --auto-approve'
            

                

                }
                
            }
        }




        stage('Provision Kubernetes Resources') {
            environment {
            AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
            AWS_SECRET_ACCESS_KEY = credentials ('jenkins_aws_secret_access_key')

        }
            steps {
                dir('terraform/kubernetes') {
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
               
                    echo "Provisioning Kubernetes resources"
                    sh 'terraform init -input=false -reconfigure'
                    sh 'terraform plan'
                  //  sh 'terraform apply --auto-approve'

                }
            

                

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
