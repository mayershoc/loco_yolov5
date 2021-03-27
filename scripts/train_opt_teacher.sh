#! /bin/sh
# Using the best performing teacher configuration (i.e. 6) we now try to find a good set of hyperparameters, before using the models for self-training.
# Change batch size according to your machines memory. Weights are always updated after 64 batches.
BATCH="--batch-size 16"
# Fine-Tuning with 30 epochs return reasonable results
COMMON="--epochs 30 $BATCH"

# Teacher 6: Data: LOCO_train + LOCO_synth, Pretrained: COCO, hyperparameter tuning on
python train.py --data loco_all.yaml --weights 'yolov5x.pt' --name 'teacher_6_optimized' --hyp 'data/hyp.loco.evolved.yaml' $COMMON

