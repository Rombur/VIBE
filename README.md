* The `core` folder contains the Dockerfile used to build an image of 
  [VIBE](http://batterysim.org/vibe).
* The `remote` folder sets up VIBE to be launched remotely via SSH.

It is however not necessary to build VIBE's image since it can be pulled using:
```bash
$ docker pull dalg24/vibe
```
To run the image simply use:
```bash
$ docker run --rm -it dalg24/vibe /bin/bash
```

To install Docker simply follow the instruction on the [Docker
website](https://docs.docker.com/engine/installation).
