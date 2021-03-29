#!/bin/bash
set -e

## CUDA environmental variables configuration for RStudio

## These should be exported as ENV vars too
CUDA_HOME=${CUDA_HOME:-/usr/local/cuda}
PATH={$PATH:-$PATH:$CUDA_HOME/bin}
LD_LIBRARY_PATH=${LD_LIBRARY_PATH:-$LD_LIBRARY_PATH:$CUDA_HOME/lib64:$CUDA_HOME/extras/CUPTI/lib64}
NVBLAS_CONFIG_FILE=${NVBLAS_CONFIG_FILE:-/etc/nvblas.conf}

## cli R inherits these, but RStudio needs to have these set in as follows:
## (From https://tensorflow.rstudio.com/tools/local_gpu.html#environment-variables)
echo "CUDA_HOME=$CUDA_HOME" >> ${R_HOME}/etc/Renviron
echo "PATH=$PATH" >> ${R_HOME}/etc/Renviron

if test -f /etc/rstudio/rserver.conf; then
  sed -i '/^rsession-ld-library-path/d' /etc/rstudio/rserver.conf
  echo "rsession-ld-library-path=$LD_LIBRARY_PATH" >> /etc/rstudio/rserver.conf
fi

## nvblas configuration
touch /var/log/nvblas.log && chown :staff /var/log/nvblas.log
chmod a+rw /var/log/nvblas.log

## Configure R & RStudio to use drop-in CUDA blas
## Allow R to use CUDA for BLAS, with fallback on openblas
echo 'NVBLAS_LOGFILE /var/log/nvblas.log
NVBLAS_CPU_BLAS_LIB /usr/lib/x86_64-linux-gnu/openblas/libblas.so.3
NVBLAS_GPU_LIST ALL' > /etc/nvblas.conf

echo "NVBLAS_CONFIG_FILE=$NVBLAS_CONFIG_FILE" >> ${R_HOME}/etc/Renviron
