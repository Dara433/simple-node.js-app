# CodePipeline for a simple-node.js-app

Source Provider Connection: Github


## CodeBuild 

 use a configured IAM that has these permission 

- AmazonS3ReadOnlyAccess - gives Codebuild general read access to S3

Add this inline policy using JSON - named as 'CodePipelineArtifactAccess - 


        {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Action": [
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:GetBucketVersioning"
        ],
        "Resource": [
            "arn:aws:s3:::codepipeline-artifacts-01",
            "arn:aws:s3:::codepipeline-artifacts-01/*"
        ]
        }
    ]
    }

*the inline policy is required to allow CodeBuld to read from particular CodePipeline artifact bucket*
*make sure an S3 bucket named as codepipeline-artifacts-01 has been created*

Repository name - `Dara433/simple-node-js-app`
Branch - `main`


## Code Deploy

Choose IAM role 

role name - AWSCodeDeployRole 

Environment configuration
choose
- Amazon EC2 instance
- Select Tag group 
    Key: Name 
    Value: MyNodeServer

**note that tag name must be exactly the same as the created EC2 instance 
Serive role must follow this syntax: arn:aws:iam::<ACCOUNT-ID>:role/<ROLE-NAME>


## CodePipeline

Service role: Let AWS create a new one
Source stage
    - Source Provider: Github
    - Repository: Dara433/simple-node-js-app
    - branch: main
    - change detection: start the pipeline on source changes

Build stage:
    specify CodeBuild project name 
    use source artifact from github


deploy stage: 
    specify CodeDeploy project name
    use build artifact for deploy stage: received artifacts produced by CodeBuild,  

Specify artifact as S3 codepipeline-artifacts-01

Use build artifact for deploy s

## EC2 instance

Create an EC2 instance on AWS console 

### Creating IAM role for EC2 for CodeDeploy
Before launching the EC2 instance, you need an IAM role that allows the instance to talk to CodeDeploy

Attach these policies
- 	AmazonEC2RoleforAWSCodeDeploy
• 	AmazonS3ReadOnlyAccess (needed for pulling artifacts)

name the role: EC2CodeDeployRole

- Launch instance with the specific tags as its in CodeDeloy (Name:MyNodeServer)
- Select IAM role: EC2CodeDeployRole 
- Create a new security group: allowing SSH, HTTP, and custom TCP (3000) inbound traffic

- Install CodeDeploy agent on your EC2 instance
            sudo yum update -y
            sudo yum install ruby -y
            sudo yum install wget -y

            cd /home/ec2-user
            wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
            sudo chmod +x ./install
            sudo ./install auto

- Install Node.js on your EC2 instance
- SSH into instance and fix file ownership and permssion on the EC2 instance: this ensures the ec2 user (the one CodeDeploy uses) owns all files and can write to them 
            sudo chown -R ec2-user:ec2-user /home/ec2-user/simple-node-app
            sudo chmod -R 755 /home/ec2-user/simple-node-app

Update `install_dependencies.sh` to include permssions to fix automatically (prevents future permission errorsif CodeDeploy unpacks files with root ownership)

- Run Node app in background in script/start_server.sh keep process alive and avoid timeouts

test your server on your local brower
        http://<EC2-PUBLIC-IP>:3000


