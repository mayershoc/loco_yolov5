#!/bin/bash
# LOCO dataset 
# Download command: bash data/scripts/get_loco.sh
# Train command: python train.py --data loco.yaml

# Clone repository
d='../'
url=https://github.com/mayershoc/loco
echo 'Cloning' $url '...'
git clone $url $d/loco

# Download/unzip images
sh "../loco/utils/download.sh" 

# Download/unzip darknet formatted labels
sh "../loco/utils/darknet.sh"

mv ../dataset/ ../loco/

# Restructure data
mkdir -p ../loco/dataset/images/synth ../loco/dataset/images/train ../loco/dataset/images/val  
mkdir -p ../loco/dataset/labels/synth ../loco/dataset/labels/train ../loco/dataset/labels/val

f1=synth
f2=val
f3=train
for f in $f1 $f2 $f3; do
  echo 'Restructuring LOCO' $f '...'
  find ../loco/dataset/$f/ -name '*.jpg' -exec mv {} ../loco/dataset/images/$f/ \;
  find ../loco/dataset/$f/ -name '*.txt' -exec mv {} ../loco/dataset/labels/$f/ \;
  #rm ../loco/dataset/$f -rf
done
wait # finish background tasks
