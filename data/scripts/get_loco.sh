#!/bin/bash
# LOCO dataset 
# Download command: bash data/scripts/get_loco.sh
# Train command: python train.py --data loco.yaml

# Clone repository
d='../'
url=https://github.com/mayershoc/loco
echo 'Cloning' $url '...'
git clone $url $d/loco

# Download images and darknet labels using provided scripts
cd $d/loco
bash utils/get_loco.sh
bash utils/get_darknet_labels.sh

# Restructure images to comply with yolov5 folder structure
cd dataset
mkdir images
for d in */ ; do
    if [ $d != 'images/' ]
    then
        echo 'Restructuring' $d 'folder ...'
        # Move images from subfolders to top level directory
        find $d -name '*.jpg' -exec mv {} $d -n \;
        # Remove subfolders
        find $d -mindepth 1 -maxdepth 1 -type d -exec rm {} -rf \;
        mv $d images 
    fi
done

# Restructure labels to comply with yolov5 folder structure
cd ../
mkdir dataset/labels
mv annotations/darknet/* dataset/labels/

