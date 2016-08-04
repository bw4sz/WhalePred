#!/bin/bash 

#cd into whales, if directory doesn't exist, kill the run.
cd Whales||sudo halt

#git pull to make sure we are at HEAD
git pull

#make new branch
#name it the instance ID
iid=$(ec2metadata --instance-id)

git checkout -b $iid

#render script
Rscript -e "rmarkdown::render('SingleSpecies.Rmd')" &> run.txt

#push results
git add --all
git commit -m "ec2 run complete"
git push -u origin $iid

#kill instance
sudo halt
