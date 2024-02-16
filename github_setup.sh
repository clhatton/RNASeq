#! /bin/bash
set -e

clhatton=git@github.com:clhatton/RNASeq.git
moorelab=git@github.com:Moore-Lab-UMass/Courtney-Hatton-Projects.git

git remote set-url --delete --push origin

git remote add clhatton $clhatton
git remote add moorelab $moorelab

git remote add origin $clhatton

git remote set-url --add --push origin $clhatton
git remote set-url --add --push origin $moorelab

git remote show origin
