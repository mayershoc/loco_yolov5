#! /bin/sh
# Pretraining 1: Data: LOCO_synth, Pretrained: No
python train.py --data loco_synth.yaml --weights '' --name 'pre_synth_p0'
# Pretraining 2: Data: LOCO_synth, Pretrained: COCO
python train.py --data loco_synth.yaml --weights 'yolov5x.pt' --name 'pre_synth_p1'

# Teacher 1: Data: LOCO_train, Pretrained: No
python train.py --data loco_natural.yaml --weights '' --name 'teacher_1'
# Teacher 2: Data: LOCO_train, Pretrained: COCO
python train.py --data loco_natural.yaml --weights 'yolov5x.pt' --name 'teacher_2'
# Teacher 3: Data: LOCO_train, Pretrained: LOCO_synth
python train.py --data loco_natural.yaml --weights 'runs/train/pre_synth_p0/best.pt' --name 'teacher_3'
# Teacher 4: Data: LOCO_train, Pretrained: COCO & LOCO_synth
python train.py --data loco_natural.yaml --weights 'runs/train/pre_synth_p1/best.pt' --name 'teacher_4'

# Teacher 5: Data: LOCO_train + LOCO_synth, Pretrained: No
python train.py --data loco_all.yaml --weights '' --name 'teacher_5'
# Teacher 6: Data: LOCO_train + LOCO_synth, Pretrained: COCO
python train.py --data loco_all.yaml --weights 'yolov5x.pt' --name 'teacher_6'
# Teacher 7: Data: LOCO_train + LOCO_synth, Pretrained: LOCO_synth
python train.py --data loco_all.yaml --weights 'runs/train/pre_synth_p0/best.pt' --name 'teacher_7'
# Teacher 8: Data: LOCO_train + LOCO_synth, COCO & Pretrained: LOCO_synth
python train.py --data loco_all.yaml --weights 'runs/train/pre_synth_p1/best.pt' --name 'teacher_8'



