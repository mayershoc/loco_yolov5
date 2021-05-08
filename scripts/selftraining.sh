#! /bin/bash

### Parameters
TEACHER_WEIGHTS=$1                          # Starting model to be used for self-training.

TEACHER="$( echo $TEACHER_WEIGHTS | cut -d/ -f3 )"    # Teacher name. To be used for logging.
STUDENT="trained_by_$TEACHER"               # Name of first student. To be used for logging.
STUDENT2="trained_by_$STUDENT"              # Name of second student. To be used for logging 

NAT="../loco/dataset/images/nat-unlabelled/"    # Path to unlabelled natural data 
WEB="../loco/dataset/images/web-unlabelled/"    # Path to unlabelled web data 

DATA3="loco_data3.yaml"                         # Training definition. Train on Train, Synth and Nat, Validate on Val
DATA4="loco_data4.yaml"                         # Training definition. Train on Train, Synth, Nat and Web, Validate on Val

BS="16"                                        # Batch Size
EPOCHS="30"                                    # Epochs
CONF="0.7"                                    # Confidence threshold for pseudolabeling.

### Performs pseudolabeling
function pseudolabel() {
    local WEIGHTS=$1
    local PATH_TO_DATA_IMAGES=$2
    local PATH_TO_DATA_ROOT="$( echo $PATH_TO_DATA_IMAGES | cut -d/ -f1,2,3 )"
    local DATA_NAME="$( echo $PATH_TO_DATA_IMAGES | cut -d/ -f5 )"
    local PATH_TO_DATA_LABELS="$PATH_TO_DATA_ROOT/labels/$DATA_NAME"
    local CONF=$3
    local NAME="$( echo $WEIGHTS | cut -d/ -f3 )_$DATA_NAME"
    local DIR='runs/pseudo/'

    # Perform detection and save them as labels
    python detect.py --weights "$WEIGHTS" --source "$PATH_TO_DATA_IMAGES" --conf-thres "$CONF" --save-txt --augment --project "$DIR" --name "$NAME" --no-save

    # Clean up the mess
    # find "$DIR$NAME" -name '*.jpg' -exec rm {} \;	# Remove images
    zip -r "$DIR$NAME/$(date -I)_label.zip" "$DIR$NAME/labels/"     # Compress labels for storing
    rm  "$PATH_TO_DATA_ROOT/labels/*.cache"			   # Remove cache
    rm -rf "$PATH_TO_DATA_LABELS"                                  # Remove old labels
    mv "$DIR$NAME/labels" "$PATH_TO_DATA_LABELS"     # Move and rename labels to corresponding loco path. Ugly but it works.
}

### Performs training
function train() {
    local DATA=$1
    local WEIGHTS=$2
    local NAME=$3
    local BATCH_SIZE=$4
    local EPOCHS=$5

    local DIR='runs/selftraining/'

    # Do the training
    python train.py --data "$DATA" --weights "$WEIGHTS" --project "$DIR" --name "$NAME" --batch-size "$BATCH_SIZE" --epochs "$EPOCHS" --cache-images

}

# Step 1: Use TEACHER to pseudo-label NAT.
pseudolabel "$TEACHER_WEIGHTS" "$NAT" "$CONF" "$TEACHER"

# Step 2: Initialize STUDENT using TEACHER_WEIGHTS and train on DATA1
train "$DATA3" "$TEACHER_WEIGHTS" "$STUDENT" "$BS" "$EPOCHS"

# Step 3: Use STUDENT to pseudo-label NAT and WEB
STUDENT_WEIGHTS="runs/selftraining/$STUDENT/weights/best.pt"
pseudolabel "$STUDENT_WEIGHTS" "$NAT" "$CONF" "$STUDENT"
pseudolabel "$STUDENT_WEIGHTS" "$WEB" "$CONF" "$STUDENT"

# Step 4: Initialize STUDENT2 using STUDENT_WEIGHTS and train on DATA2
train "$DATA4" "$STUDENT_WEIGHTS" "$STUDENT2" "$BS" "$EPOCHS"
