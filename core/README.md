Build the image
===============
To build the image, you will need to have access to the repository of VIBE,
AMPERES, and AMPERES-DATA.  If you do, you may run the two commands
`git sumodule init` and `git submodule update` to fetch them.
Then, simply type:
```bash
$ docker build -t vibe .
```
This will create a new image called vibe.

Compress the image
==================
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
