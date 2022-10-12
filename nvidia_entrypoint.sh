#!/bin/bash
set -e
cat <<EOF

=============
== PyTorch ==
=============

NVIDIA Release ${NVIDIA_PYTORCH_VERSION} (build ${NVIDIA_BUILD_ID})
PyTorch Version ${PYTORCH_VERSION}

Container image Copyright (c) 2021, NVIDIA CORPORATION.  All rights reserved.

Copyright (c) 2014-2021 Facebook Inc.
Copyright (c) 2011-2014 Idiap Research Institute (Ronan Collobert)
Copyright (c) 2012-2014 Deepmind Technologies    (Koray Kavukcuoglu)
Copyright (c) 2011-2012 NEC Laboratories America (Koray Kavukcuoglu)
Copyright (c) 2011-2013 NYU                      (Clement Farabet)
Copyright (c) 2006-2010 NEC Laboratories America (Ronan Collobert, Leon Bottou, Iain Melvin, Jason Weston)
Copyright (c) 2006      Idiap Research Institute (Samy Bengio)
Copyright (c) 2001-2004 Idiap Research Institute (Ronan Collobert, Samy Bengio, Johnny Mariethoz)
Copyright (c) 2015      Google Inc.
Copyright (c) 2015      Yangqing Jia
Copyright (c) 2013-2016 The Caffe contributors
All rights reserved.

NVIDIA Deep Learning Profiler (dlprof) Copyright (c) 2021, NVIDIA CORPORATION.  All rights reserved.

Various files include modifications (c) NVIDIA CORPORATION.  All rights reserved.

This container image and its contents are governed by the NVIDIA Deep Learning Container License.
By pulling and using the container, you accept the terms and conditions of this license:
https://developer.nvidia.com/ngc/nvidia-deep-learning-container-license
EOF

if [[ "$(find -L /usr -name libcuda.so.1 2>/dev/null | grep -v "compat") " == " " || "$(ls /dev/nvidiactl 2>/dev/null) " == " " ]]; then
  echo
  echo "WARNING: The NVIDIA Driver was not detected.  GPU functionality will not be available."
  echo "   Use 'nvidia-docker run' to start this container; see"
  echo "   https://github.com/NVIDIA/nvidia-docker/wiki/nvidia-docker ."
else
  ( /usr/local/bin/checkSMVER.sh )
  DRIVER_VERSION=$(sed -n 's/^NVRM.*Kernel Module *\([0-9.]*\).*$/\1/p' /proc/driver/nvidia/version 2>/dev/null || true)
  if [[ ! "$DRIVER_VERSION" =~ ^[0-9]*.[0-9]*(.[0-9]*)?$ ]]; then
    echo "Failed to detect NVIDIA driver version."
  elif [[ "${DRIVER_VERSION%%.*}" -lt "${CUDA_DRIVER_VERSION%%.*}" ]]; then
    if [[ "${_CUDA_COMPAT_STATUS}" == "CUDA Driver OK" ]]; then
      echo
      echo "NOTE: Legacy NVIDIA Driver detected.  Compatibility mode ENABLED."
    else
      echo
      echo "ERROR: This container was built for NVIDIA Driver Release ${CUDA_DRIVER_VERSION%.*} or later, but"
      echo "       version ${DRIVER_VERSION} was detected and compatibility mode is UNAVAILABLE."
      echo
      echo "       [[${_CUDA_COMPAT_STATUS}]]"
      sleep 2
    fi
  fi
fi

if ! cat /proc/cpuinfo | grep flags | sort -u | grep avx >& /dev/null; then
  echo
  echo "ERROR: This container was built for CPUs supporting at least the AVX instruction set, but"
  echo "       the CPU detected was $(cat /proc/cpuinfo |grep "model name" | sed 's/^.*: //' | sort -u), which does not report"
  echo "       support for AVX.  An Illegal Instrution exception at runtime is likely to result."
  echo "       See https://en.wikipedia.org/wiki/Advanced_Vector_Extensions#CPUs_with_AVX ."
  sleep 2
fi

DETECTED_MOFED=$(cat /sys/module/mlx5_core/version 2>/dev/null || true)
case "${DETECTED_MOFED}" in
  "${MOFED_VERSION}")
    echo
    echo "Detected MOFED ${DETECTED_MOFED}."
    ;;
  "")
    echo
    echo "NOTE: MOFED driver for multi-node communication was not detected."
    echo "      Multi-node communication performance may be reduced."
    ;;
  *)
    if dpkg --compare-versions "${DETECTED_MOFED}" lt 4.9 >& /dev/null && [[ -z "${DISABLE_MOFED_VERSION_WARNING}" ]]; then
      echo
      echo "ERROR: Detected MOFED driver ${DETECTED_MOFED}, but this container has version ${MOFED_VERSION}."
      echo "       Please upgrade to MOFED 4.9 or higher for multi-node operation support."
      sleep 2
    fi
    ;;
esac

DETECTED_NVPEERMEM=$(cat /sys/module/nv_peer_mem/version 2>/dev/null || true)
if [[ "${DETECTED_MOFED} " != " " && "${DETECTED_NVPEERMEM} " == " " ]]; then
  echo
  echo "NOTE: MOFED driver was detected, but nv_peer_mem driver was not detected."
  echo "      Multi-node communication performance may be reduced."
fi

if [[ "$(df -k /dev/shm |grep ^shm |awk '{print $2}') " == "65536 " ]]; then
  echo
  echo "NOTE: The SHMEM allocation limit is set to the default of 64MB.  This may be"
  echo "   insufficient for PyTorch.  NVIDIA recommends the use of the following flags:"
  echo "   nvidia-docker run --ipc=host ..."
fi

echo

service ssh restart
echo "SSH started"

if [[ $# -eq 0 ]]; then
  exec "/bin/bash"
else
  exec "$@"
fi

