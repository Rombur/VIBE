FROM dalg24/vibe

RUN apt-get update && \
    apt-get install -y openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd

COPY id_rsa_vibe.pub /root/.ssh/authorized_keys

# The sshd daemon scrubs the environment before it starts the shell so we need 
# to push the ENV variable to a shell initialization file
RUN echo "export TPL_INSTALL_DIR=/opt/tpls" >> /etc/profile
RUN echo "export AMP_INSTALL_DIR=/opt/amp" >> /etc/profile
RUN echo "export AMPERES_INSTALL_DIR=/opt/amperes" >> /etc/profile
RUN echo "export HDF5_INSTALL_DIR=/opt/tpls/hdf5" >> /etc/profile
RUN echo "export SILO_INSTALL_DIR=/opt/tpls/silo" >> /etc/profile
RUN echo "export CGNS_BUILD_DIR=/opt/build" >> /etc/profile
RUN echo "export CGNS_INSTALL_DIR=/opt/CGNS" >> /etc/profile
RUN echo "export OAS_INSTALL_DIR=/opt/OAS" >> /etc/profile
RUN echo "export VIBE_INSTALL_DIR=/opt/vibe" >> /etc/profile
RUN echo "export LD_LIBRARY_PATH=/opt/tpls/hdf5/lib:/opt/tpls/silo/lib:/opt/amperes/lib:/opt/CGNS/lib" \
    >> /etc/profile

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
