# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi

export NVM_DIR="/usr/local/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export NPP_VERSION=11.5.1.53
export NVIDIA_VISIBLE_DEVICES=all
export DALI_BUILD=3362434
export CUSOLVER_VERSION=11.2.1.48
export no_proxy=localhost,127.0.0.1,172.17.146.111,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16
export CUBLAS_VERSION=11.7.3.1
export HOSTNAME=1708a0f72776
export CUFFT_VERSION=10.6.0.54
export NVIDIA_REQUIRE_CUDA="cuda>=9.0"
export CUDA_CACHE_DISABLE=1
export TENSORBOARD_PORT=6006
export TORCH_CUDA_ARCH_LIST="5.2 6.0 6.1 7.0 7.5 8.0 8.6+PTX"
export NCCL_VERSION=2.11.4
export CUSPARSE_VERSION=11.7.0.31
export ENV=/etc/shinit_v2
export OPENUCX_VERSION=1.11.0-rc1
export NSIGHT_SYSTEMS_VERSION=2021.3.2.4
export NVIDIA_DRIVER_CAPABILITIES=compute,utility,video
export TRT_VERSION=8.2.1.8+cuda11.4.2.006
export NVIDIA_PRODUCT_NAME=PyTorch
export RDMACORE_VERSION=36.0
export COCOAPI_VERSION=2.0+nv0.6.0
export CUDA_VERSION=11.5.0.029
export PYTORCH_VERSION=1.11.0a0+b6df043
export CURAND_VERSION=10.2.6.48
export https_proxy=http://172.17.146.34:8889
export PYTORCH_BUILD_NUMBER=0
export USE_EXPERIMENTAL_CUDNN_V8_API=1
export CUTENSOR_VERSION=1.3.3.2
export HPCX_VERSION=2.9.0
export DLPROF_VERSION=21.12
export GDRCOPY_VERSION=2.3
export OPENMPI_VERSION=4.1.1
export NO_PROXY=localhost,127.0.0.1,172.17.146.111,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16
export NVJPEG_VERSION=11.5.3.48
export LIBRARY_PATH=/usr/local/cuda/lib64/stubs:
export PYTHONIOENCODING=utf-8
export CUDNN_V8_API_ENABLED=0
export BASH_ENV=/etc/bash.bashrc
export HTTPS_PROXY=http://172.17.146.34:8889
export HTTP_PROXY=http://172.17.146.34:8889
export CUDNN_VERSION=8.3.1.22
export http_proxy=http://172.17.146.34:8889
export NSIGHT_COMPUTE_VERSION=2021.3.0.13
export DALI_VERSION=1.8.0
export JUPYTER_PORT=8888
export LD_LIBRARY_PATH=/opt/conda/lib/python3.8/site-packages/torch/lib:/opt/conda/lib/python3.8/site-packages/torch_tensorrt/lib:/usr/local/cuda/compat/lib:/usr/local/nvidia/lib:/usr/local/nvidia/lib64
export NVIDIA_BUILD_ID=29870972
export OMPI_MCA_coll_hcoll_enable=0
export OPAL_PREFIX=/opt/hpcx/ompi
export CUDA_DRIVER_VERSION=495.29.05
export LC_ALL=C.UTF-8
export PYTORCH_BUILD_VERSION=1.11.0a0+b6df043
export CUDA_HOME=/usr/local/cuda
export PATH=/usr/local/nvm/versions/node/v16.6.1/bin:/opt/conda/lib/python3.8/site-packages/torch_tensorrt/bin:/opt/conda/bin:/usr/local/mpi/bin:/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/ucx/bin:/opt/tensorrt/bin
export MOFED_VERSION=5.4-rdmacore36.0
export NVIDIA_PYTORCH_VERSION=21.12
export TRTOSS_VERSION=21.12

