#!/bin/bash

function jupyter() {

  docker run -p 8888:8888 --rm --name jupyter \
    -e AWS_DEFAULT_REGION \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY \
    -e AWS_SESSION_TOKEN \
    -e AWS_PROFILE \
    -v ~/.aws:/home/jovyan/.aws \
    -e JUPYTER_ENABLE_LAB=yes \
    -v "$PWD":/home/jovyan/work \
    justmiles/jupyter-notebook jupyter notebook --NotebookApp.token='' --NotebookApp.password=''
}
