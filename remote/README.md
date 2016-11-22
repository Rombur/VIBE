Build and run the container
===========================
Build container
---------------
```bash
$ docker-compose build
```

Run container
-------------
```bash
$ docker-compose up -d
$ ssh -i id_rsa_vibe -p 2222 root@localhost
```

Compress image
==============
Creating a image with only one or two layers can significantly decrease the
size of the image.
Docker 1.12 and older
---------------------
Use [docker import and export](https://intercityup.com/blog/downsizing-docker-containers.html).
This method has the disadvantage that all the environment variables inside the
image are erased. Thus after the image has been flatten, a new image has to be
built to restore the environment variables.

Docker 1.13 and newer
---------------------
Use the `--squash` option of `docker build`.
