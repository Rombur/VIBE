# Launch the VIBE container and connect into it using SSH

Here we install a SSH server on top of the VIBE Docker image.
We use a Compose file to configure the VIBE container.

To run that container and connect into it via SSH, do:
```bash
$ docker run -d -p 2222:22 --name vibe_ssh rombur/vibe-ssh
$ ssh -i id_rsa_vibe -p 2222 root@localhost
```
To stop and remove the container use:
```bash
$ docker stop vibe_ssh
$ docker rm vibe_ssh
```

Note that it is not necessary to run a SSH server to launch a interactive bash session.
This configuration is intended to launch VIBE remotely from ICE.
