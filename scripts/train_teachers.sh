#! /bin/sh
COMMON="--epochs 30 --batch-size 16"


# Pretraining 1: Data: LOCO_synth, Pretrained: No
python train.py --data loco_synth.yaml --weights '' --cfg yolov5x.yaml --name 'pre_synth_p0' $COMMON
# Pretraining 2: Data: LOCO_synth, Pretrained: COCO
python train.py --data loco_synth.yaml --weights 'yolov5x.pt' --name 'pre_synth_p1' $COMMON

# Teacher 1: Data: LOCO_train, Pretrained: No
python train.py --data loco_natural.yaml --weights '' --cfg yolov5x.yaml --name 'teacher_1' $COMMON
# Teacher 2: Data: LOCO_train, Pretrained: COCO
python train.py --data loco_natural.yaml --weights 'yolov5x.pt' --name 'teacher_2' $COMMON
# Teacher 3: Data: LOCO_train, Pretrained: LOCO_synth
python train.py --data loco_natural.yaml --weights 'runs/train/pre_synth_p0/best.pt' --name 'teacher_3' $COMMON
# Teacher 4: Data: LOCO_train, Pretrained: COCO & LOCO_synth
python train.py --data loco_natural.yaml --weights 'runs/train/pre_synth_p1/best.pt' --name 'teacher_4' $COMMON

# Teacher 5: Data: LOCO_train + LOCO_synth, Pretrained: No
python train.py --data loco_all.yaml --weights '' --cfg yolov5x.yaml --name 'teacher_5' $COMMON
# Teacher 6: Data: LOCO_train + LOCO_synth, Pretrained: COCO
python train.py --data loco_all.yaml --weights 'yolov5x.pt' --name 'teacher_6' $COMMON
# Teacher 7: Data: LOCO_train + LOCO_synth, Pretrained: LOCO_synth
python train.py --data loco_all.yaml --weights 'runs/train/pre_synth_p0/best.pt' --name 'teacher_7' $COMMON
# Teacher 8: Data: LOCO_train + LOCO_synth, COCO & Pretrained: LOCO_synth
python train.py --data loco_all.yaml --weights 'runs/train/pre_synth_p1/best.pt' --name 'teacher_8' $COMMON



