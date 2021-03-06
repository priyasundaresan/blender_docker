# Dockerfile autogenerated on 06/15/2020, 20:19:12 by juniorxsound 
# Please do not edit this file directly 

FROM nvidia/cudagl:10.1-base-ubuntu18.04

LABEL Author="Or Fleisher <or.fleisher@nytimes.com>"
LABEL Title="Blender in Docker"

# Enviorment variables
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV PATH "$PATH:/bin/2.83/python/bin/"
ENV BLENDER_PATH "/bin/2.83"
ENV BLENDERPIP "/bin/2.83/python/bin/pip3"
ENV BLENDERPY "/bin/2.83/python/bin/python3.7m"
ENV HW="GPU"

# Install dependencies
RUN apt-get update && apt-get install -y \ 
    wget \ 
    libopenexr-dev \ 
    bzip2 \ 
    build-essential \ 
    zlib1g-dev \ 
    libxmu-dev \ 
    libxi-dev \ 
    libxxf86vm-dev \ 
    libfontconfig1 \ 
    libxrender1 \ 
    libgl1-mesa-glx \ 
    xz-utils \
    python-opengl 

RUN apt install xvfb -y

# Download and install Blender
RUN wget https://mirror.clarkson.edu/blender/release/Blender2.83/blender-2.83.0-linux64.tar.xz \ 
    && tar -xvf blender-2.83.0-linux64.tar.xz --strip-components=1 -C /bin \ 
    && rm -rf blender-2.83.0-linux64.tar.xz \ 
    && rm -rf blender-2.83.0-linux64 

# Download the Python source since it is not bundled with Blender
RUN wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz \ 
    && tar -xzf Python-3.7.0.tgz \ 
    && cp -r Python-3.7.0/Include/* $BLENDER_PATH/python/include/python3.7m/ \ 
    && rm -rf Python-3.7.0.tgz \ 
    && rm -rf Python-3.7.0 

# Blender comes with a super outdated version of numpy (which is needed for matplotlib / opencv) so override it with a modern one
RUN rm -rf ${BLENDER_PATH}/python/lib/python3.7/site-packages/numpy 

# Must first ensurepip to install Blender pip3 and then new numpy
RUN ${BLENDERPY} -m ensurepip && ${BLENDERPIP} install --upgrade pip && ${BLENDERPIP} install numpy

# @PRIYA
# Fake a display to use Eevee and Workbench headless
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get install -y --no-install-recommends python3.5 python3.5-dev python3-pip python3-tk && \
    pip3 install --no-cache-dir --upgrade pip setuptools && \
    echo "alias python='python3'" >> /root/.bash_aliases && \
    echo "alias pip='pip3'" >> /root/.bash_aliases

RUN pip install --upgrade pip && \
    pip install \
        pyvirtualdisplay \
        piglet

# @PRIYA Set the working directory
WORKDIR /
COPY render /tmp/render
