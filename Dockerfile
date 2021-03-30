  
FROM nvidia/cuda:11.2.2-base-ubuntu20.04

ENV CUDA_VERSION=11.1
ENV NCCL_VERSION=2.7.8
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_REQUIRE_CUDA=cuda>=11.1 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=440,driver<441 brand=tesla,driver>=450,driver<451
ENV CUDA_HOME=/usr/local/cuda
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/lib64:$CUDA_HOME/extras/CUPTI/lib64:$CUDA_HOME/lib64/libnvblas.so:
ENV LIBRARY_PATH=/usr/local/cuda/lib64/stubs
ENV NVBLAS_CONFIG_FILE=/etc/nvblas.conf
ENV WORKON_HOME=/opt/venv
ENV PYTHON_VENV_PATH=/opt/venv/reticulate
ENV RETICULATE_MINICONDA_ENABLED=FALSE
ENV PATH=${PYTHON_VENV_PATH}/bin:${CUDA_HOME}/bin:/usr/local/nviida/bin:${PATH}:/usr/local/texlive/bin/x86_64-linux

ENV S6_VERSION=v2.0.0.1
ENV RSTUDIO_VERSION=1.3.959
ENV PATH=/usr/lib/rstudio-server/bin:$PATH

ENV R_VERSION=4.0.4
ENV TERM=xterm
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV R_HOME=/usr/local/lib/R
ENV CRAN=https://packagemanager.rstudio.com/all/__linux__/focal/latest
ENV TZ=Etc/UTC

ARG UBUNTU_VERSION=focal 
ARG R_HOME=/usr/lib/R
ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive 

COPY installers /installers
RUN chmod +x /installers/install_R.sh

# R_cuda cofig
#COPY config_R_cuda.sh /tmp/config_R_cuda.sh
#RUN config_R_cuda.sh

# Rstudio
RUN chmod +x /installers/install_rstudio.sh

# Python
# RUN /installers/install_python.sh

# Pandoc
RUN chmod +x /installers/install_pandoc.sh

EXPOSE 8888
EXPOSE 8787

ENTRYPOINT ["chmod +x /run.sh"]
