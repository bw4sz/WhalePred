#!/bin/bash 

# spawn instance and store id
instance_id=$(aws ec2 run-instances --image-id ami-5232cd32 --security-group-ids sg-890a37ed --count 1 --instance-type t2.medium --key-name rstudio --instance-initiated-shutdown-behavior terminate --query 'Instances[0].{d:InstanceId}' --output text)

# wait until instance is up and running
aws ec2 wait instance-running --instance-ids $instance_id

# retrieve public dns
dns=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[*].Instances[*].PublicDnsName' --output text | grep a)

#Wait for port to be ready, takes about a minute.
sleep 60

# copy over Job.bash to instance
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i '/c/Users/Ben/.ssh/rstudio.pem' /c/Users/Ben/Documents/Whales/Amazon/Job.bash ubuntu@$dns:~

# run job script on instance
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i "/c/Users/Ben/.ssh/rstudio.pem" ubuntu@$dns "bash ~/Job.bash"