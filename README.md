Training repository for [YOLOv5](https://github.com/ultralytics/yolov5) and the [LOCO dataset](https://github.com/mayershoc/loco) using the provided [Docker image](https://github.com/ultralytics/yolov5/wiki/Docker-Quickstart).

# Requirements
- Docker, Nvidia-Docker and Nvidia Driver, see [here](https://github.com/ultralytics/yolov5/wiki/Docker-Quickstart#1-install-docker-and-nvidia-docker)

# Quickstart
1. Spin up the container `bash start.sh`
2. Within the container, install Weights&Biases: `pip install wandb`
3. Train a model on loco
  ```
  $ python train.py --data loco_all.yaml  # train a model
  $ python test.py --data loco_all.yaml --weights yolov5s.pt  # test a model for Precision, Recall and mAP
  $ python detect.py --weights yolov5s.pt --source path/to/images  # run inference on images and videos
  ```
