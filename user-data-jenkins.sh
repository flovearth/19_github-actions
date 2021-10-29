#!/bin/bash

#clone repo
#NOTE: for testing purposes bitbucket password used to clone the repo 
#and secret file didnt used. when terraform secret activated, 
#app-password will be removed inside this script.
cd /home/ubuntu
git clone https://flovearth:jj9rHddfJUTKdPSmSpwr@bitbucket.org/flovearth/terraform-on-aws.git
cd /home/ubuntu/terraform-on-aws

#change mod of the file to be able to run as a script
chmod 766 install_docker_and_docker_compose.sh

#install docker and docker-compose with downloaded script
sudo ./install_docker_and_docker_compose.sh

#create infrastructure with docker-compose
cd /home/ubuntu/terraform-on-aws/jenkins
sudo docker-compose up -d

#remove secret file as no more needed
sudo rm -f cd /home/ubuntu/terraform-on-aws/secret.tf

#stop jenkins container before restore
sudo docker stop jenkins

#install aws cli
sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
unzip awscliv2.zip 
sudo ./aws/install
sudo rm awscliv2.zip 
#the jenkins' data folder: /var/lib/docker/volumes/jenkins_jenkins-data/_data/
# aws s3 sync s3://jenkins-daily-backup-files2 /var/lib/docker/volumes/jenkins_jenkins-data/_data/ --delete
#--delete option will be enabled on live usage
#create s3 bucket
#create role for EC2 named "terraform-on-aws-role-for-s3" includes AmazonS3FullAccess
#attach role to EC2
sudo aws s3 sync s3://jenkins-daily-backup-files2 /var/lib/docker/volumes/jenkins_jenkins-data/_data/  

#aws configure import --csv file://aws.csv

#start jenkins container
sudo docker start jenkins