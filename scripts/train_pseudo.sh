#!/bin/bash
# This script pseudo labels unlabelled data using a trained model and trains a new model on that data.
# Command: bash scripts/pseudolabel.sh /path/to/trained/weights.pt

WEIGHTS=$1

TEACHER=$( echo $WEIGHTS | cut -d/ -f3 )
STUDENT="trained_by_$TEACHER"
D="runs/pseudo"

BATCH="--batch-size 6"
COMMON="--epochs 30 $BATCH"

# Pseudo label the data and save output under 'runs/pseudo/'
python detect.py --weights $WEIGHTS --source ../loco/dataset/images/unlabelled/ --conf-thres 0.7 --save-txt --augment --project $D --name $TEACHER

# Restructure labels to comply to yolov5 folder structure
find runs/pseudo/$TEACHER -name '*.jpg' -exec rm {} \;
# Compress labels for storing
zip $D/$TEACHER/$(date -I)_label.zip $D/$TEACHER/labels/*
# Move and rename labels to corresponding loco path
mv $D/$TEACHER/labels ../loco/dataset/labels/unlabelled

# Train the Student: 
# Student: Data: LOCO_train + LOCO_synth + LOCO_unlabelled, Pretrained: COCO
python train.py --data loco_all_unlabelled.yaml --weights 'yolov5x.pt' --project 'runs/students' --name $STUDENT $COMMON

