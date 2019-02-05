
## AWS Codebuild + Packer = AMI baked with love (POC)
Quick and dirty project for using AWS codebuild/pipeline for CI / build of a custom AMI.  Uses a custom docker build image located [here](https://github.com/brian-provenzano/aws-codebuild-alpine-container): 

### Ingredients
- This project 
    - [packer template for simple PHP app](https://github.com/brian-provenzano/aws-codebuild-packer-poc/blob/master/Basic-WebPHP-EC2AMI.json)
    - [config bootstrap script](https://github.com/brian-provenzano/aws-codebuild-packer-poc/blob/master/deploy-bootstrap.sh) (optionally you can use ansible or another config mgmt tool)
    - [buildspec.yaml - AWS codebuild](https://github.com/brian-provenzano/aws-codebuild-packer-poc/blob/master/buildspec.yaml)
- This container for the build container [aws-codebuild-alpine-container](https://github.com/brian-provenzano/aws-codebuild-alpine-container)
- This [json skel](https://github.com/brian-provenzano/aws-codebuild-packer-poc/blob/master/build_ami.codebuild.project.aws-cli.json) for the codebuild project details the config
- This [json skel](https://github.com/brian-provenzano/aws-codebuild-packer-poc/blob/master/build_ami_pipeline.codepipeline.project.aws-cli.json) for the aws pipeline details the config

Note: You can reuse the json referenced above and in this repo as a template, but you will have to adjust for your aws acct and environment.  Use in conjunciton with the following aws cli commands:

#### CodeBuild
Example of get and update via AWS CLI:

- `aws codebuild update-project --name name_of_your_codebuildprj --profile yourprofile` - retrieves codebuild proj as json which you can edit and feed back into the following command.
- `aws codebuild update-project --environment your_jsonsnippet_edited --profile yourprofile` - Here we are changing the 'environment'.  See example in this [Makefile](https://github.com/brian-provenzano/aws-codebuild-alpine-container/blob/master/Makefile) which automates this during docker image creation

#### Pipeline
Example of get and update via AWS CLI:

- `aws codepipeline get-pipeline --name name_of_your_pipeline --profile yourprofile` - retrieves pipeline as json which you can edit and feed back into the following command
- `aws codepipeline update-pipeline --pipeline your_json_edited --profile yourprofile`


More examples here in AWS CLI documentation:
- [AWS CLI codepipeline docs](https://docs.aws.amazon.com/cli/latest/reference/codepipeline/index.html#cli-aws-codepipeline)
- [AWS CLI codebuild docs](https://docs.aws.amazon.com/cli/latest/reference/codebuild/index.html)


### Extended Note
This is mainly a recreation of my [jenkins-pipeline-immut](https://github.com/brian-provenzano/jenkins-pipeline-immut) project using aws codebuild/pipeline.  Learning tool POC mostly.  The AWS codebuild/pipeline was created manually in the AWS console.  Although currently without IaC provisioning that the jenkins repo contains (using terrafrom) which is a TODO for this project/repo.

### TODO
- Cloudformation or Terraform to:
    - create the codebuild, pipeline itself
    - create infra envs for deployment
- add deployment (CD) steps for an application
- automate, automate, automate....

### Thanks 
Hashicorp
AWS
