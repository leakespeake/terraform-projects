pipeline {
    agent any

    // define tools to auto-install and put on the PATH
    tools {
        "org.jenkinsci.plugins.terraform.TerraformInstallation" "terraform"
    }

    // will appear within 'Build with Parameters' to select the desired options prior to running the build - access via the 'params' object
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'invokeDestroy', defaultValue: false, description: 'Invoke the destroy stages of the pipeline?')
    } 
    
    // access variable values throughout the pipeline via the 'env' object - "${env.VARIABLE_NAME}"
    environment {
        // terraform specific variables for automation
        TF_HOME = tool('terraform')
        TF_IN_AUTOMATION = "TRUE"
        TF_INPUT = "FALSE"
        TF_LOG = "WARN"
        PATH = "$TF_HOME:$PATH"
        // terraform .tf file location
        DIR_PATH = "modules/vsphere/stage/services"     // add repository directory path
        VM_NAME = "jenkins-test-vm"                     // add vm name to complete directory path
    }

    stages {
        stage('Init') {
            steps {
                dir("${env.DIR_PATH}/${env.VM_NAME}"){
                    sh "terraform init"
                    sh "terraform version"
                    sh "echo \$PWD"
                    sh "whoami"                    
                }
            }
        }                
        stage('Validate') {
            steps {
                dir("${env.DIR_PATH}/${env.VM_NAME}"){
                    sh "terraform fmt"
                    sh "terraform validate"
                }
            }
        }
        stage('Plan') {
            steps {
                // load our Vault sourced secret value directly into the TF_VAR_ Terraform environment variable
                withCredentials([vaultString(credentialsId: 'vcenter_password', variable: 'TF_VAR_vcenter_password')]) {
                    dir("${env.DIR_PATH}/${env.VM_NAME}"){
                        sh "terraform plan -no-color -out tfplan"
                        sh "terraform show -no-color tfplan > tfplan.txt"
                    }
                }    
           }
        }
        // stage is skipped when 'autoApprove' parameter is set to 'true' prior to the build (proceed straight to apply)
        stage('Approve') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }
           steps {
                withCredentials([vaultString(credentialsId: 'vcenter_password', variable: 'TF_VAR_vcenter_password')]) {
                    dir("${env.DIR_PATH}/${env.VM_NAME}"){
                        script {
                            def plan = readFile "tfplan.txt"
                            input message: "Do you want to apply the Terraform plan?",
                            parameters: [text(name: 'Plan', description: 'Please review the Terraform plan', defaultValue: plan)]
                        }
                    }
                }    
            }
        }    
        stage('Apply') {
            steps {
                withCredentials([vaultString(credentialsId: 'vcenter_password', variable: 'TF_VAR_vcenter_password')]) {
                    dir("${env.DIR_PATH}/${env.VM_NAME}"){
                        sh "terraform apply tfplan"
                    }
                }      
            }
        }
        // stage only active when 'invokeDestroy' parameter is set to 'true' prior to the build
        stage('Preview Destroy') {
            when {
                not {
                    equals expected: false, actual: params.invokeDestroy
                }
            }            
            steps {
                withCredentials([vaultString(credentialsId: 'vcenter_password', variable: 'TF_VAR_vcenter_password')]) {
                    dir("${env.DIR_PATH}/${env.VM_NAME}"){
                        sh "terraform plan -no-color -destroy -out=tfplan"
                        sh "terraform show -no-color tfplan > tfplan.txt"
                    }
                }      
            }
        }
        // stage only active when 'invokeDestroy' parameter is set to 'true' prior to the build        
        stage('Destroy') {
            when {
                not {
                    equals expected: false, actual: params.invokeDestroy
                }
            }             
           steps {
                withCredentials([vaultString(credentialsId: 'vcenter_password', variable: 'TF_VAR_vcenter_password')]) {
                    dir("${env.DIR_PATH}/${env.VM_NAME}"){
                        script {
                            def plan = readFile "tfplan.txt"
                            input message: "Do you want to proceed with the Terraform destroy?",
                            parameters: [text(name: 'Plan', description: 'Please review the Terraform plan', defaultValue: plan)]
                        }
                        sh "terraform apply -no-color -destroy -auto-approve"
                    }
                }    
            }
        }   
    }
} 