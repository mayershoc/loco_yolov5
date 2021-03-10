#! /bin/sh
# Change batch size according to your machines memory. Weights are always updated after 64 batches.
BATCH="--batch-size 6"

# Training the optimized teacher: Data: LOCO_train + LOCO_synth, Pretrained: COCO
python train.py --data loco_all.yaml --weights 'yolov5x.pt' --name 'teacher_opt' --epochs 30 --hyp loco.hyp.opt.yaml $BATCH

