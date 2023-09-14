#!/bin/bash
dir=$PWD
scm_root=~/icds
local_cd_dev=$scm_root/sedicdsaas-dev
local_cd_verify=$scm_root/sedicdsaas-verify
local_cd_prod=$scm_root/sedicdsaas-prod

if [ "$1" = "dev" ];then
  cd $local_cd_dev || exit
  git checkout pipeline_sedicdsaas_images-predev && git pull
  rm -f tmp/push-images.yml
  cp push-images.yml tmp
  git checkout pipeline_sedicdsaas_images && git pull
  cp tmp/push-images.yml .
  git add push-images.yml && git commit -m "promote images from predev to dev" && git push

elif [ "$1" = "verify" ];then
  cd $local_cd_dev || exit
  git checkout pipeline_sedicdsaas_images && git pull
  rm -f $local_cd_verify/tmp/push-images.yml
  cp push-images.yml $local_cd_verify/tmp
  cd $local_cd_verify || exit
  git checkout pipeline_sedicdsaas-images && git pull
  cp tmp/push-images.yml .
#  git status
  git add push-images.yml && git commit -m "promote images from dev to verify" && git push

elif [ "$1" = "prod" ];then
  cd $local_cd_verify || exit
  git checkout pipeline_sedicdsaas_images && git pull
  rm -f $local_cd_prod/tmp/push-images.yml
  cp push-images.yml $local_cd_prod/tmp
  cd $local_cd_prod || exit
  git checkout pipeline_sedicdsaas_images && git pull
  cp tmp/push-images.yml .
#  git add push-images.yml && git commit -m "promote images from verify to prod" && git push
fi
cd $dir || exit
