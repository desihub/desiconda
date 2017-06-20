#!/bin/bash

img="$1"

docker run -it -v /home/kisner/git/desi/desiconda/condabuild:/usr/src/condabuild ${img}

