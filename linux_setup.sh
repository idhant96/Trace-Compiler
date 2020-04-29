#!/bin/bash
apt-get update  
apt-get install -y

# INSTALL SWI PROLOG
apt-get install swi-prolog swi-prolog-nox -y


#install miniconda
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
apt-get update

apt-get install -y wget && rm -rf /var/lib/apt/lists/*

wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh \
conda --version

pip install -r requirements.txt
# source ~/.bashrc
# create new prolog environment
# conda env create -f environment.yml

if [ $major -lt  3 ]
then
	echo "Intall python version greater than 3.5"
else
	minor=$(python -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
	if [ $minor -lt 5 ]
	then
		echo "Install python version greater than 3."
	fi
fi

# ACTIVATE THE NEW ENVIRONMENT
# conda activate prolog


