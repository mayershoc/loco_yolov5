#! /bin/sh
# Spin up a yolov5 docker container

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

RUNS=$DIR/runs/
DATA=$DIR/data/
WANDB=$DIR/wandb/
SCRIPTS=$DIR/scripts/

docker run --ipc=host --gpus all -it -v $RUNS:/usr/src/app/runs -v $DATA:/usr/src/app/data -v $WANDB:/usr/src/app/wandb -v $SCRIPTS:/usr/src/app/scripts ultralytics/yolov5:v5.0
