FROM ubuntu:18.04
LABEL maintainer="idhant123@gmail.com"

# ENV PYTHONUNBUFFERED 1

WORKDIR /code

COPY . /code

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN apt-get update

RUN apt-get install -y wget && rm -rf /var/lib/apt/lists/*

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh \
RUN conda --version
RUN apt-get update && apt-get install -y swi-prolog 

ADD ./requirements.txt /code/requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# DEpn 
# ADD src/ /code/src/
# ADD lexical/ /code/lexical/
# ADD samples/ /code/samples/
# ADD ./execute.py /code



# CMD ["tail", "-f", "/dev/null"]
CMD ["python", "execute.py", "samples/sample1.txt"] 

#CMD ["./run.sh"]
