# docker-panda

Build for https://github.com/moyix/panda

## Install container

docker pull itsuugo/docker-panda

## Run panda inside container

docker run -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v /home/itsuugo:/home \
           -e DISPLAY=$DISPLAY \
           -it itsuugo/docker-panda

## You can test it with an example 

[PANDA SSL tutorial](http://www.rrshare.org/detail/47/)

/src/panda/scripts/rrunpack.py ssltut.rr 



