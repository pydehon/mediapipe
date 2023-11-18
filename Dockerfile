# Dockerfile
FROM probcomp/cudagl:11.8.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt update && \
    apt install -y ffmpeg libmkl-dev libmkl-full-dev wget git curl apt-utils xvfb \
        autoconf automake python3 python3-dev python3-pip checkinstall cmake gfortran git libatlas-base-dev \
        libavcodec-dev libavformat-dev libeigen3-dev libexpat1-dev libglew-dev libgtk-3-dev \
        libjpeg-dev libopenexr-dev libpng-dev libpostproc-dev libpq-dev libqt5opengl5-dev \
        libsm6 libswscale-dev libtbb2 libtbb-dev libtiff-dev libtool libv4l-dev libwebp-dev \
        libxext6 libxrender1 libxvidcore-dev pkg-config protobuf-compiler unzip yasm zlib1g-dev zlib1g \
        libdc1394-utils libavformat-dev libavcodec-dev libavdevice-dev \
        libopencv-contrib-dev libopencv-dev libopencv-dnn-dev libopencv-ml-dev libopencv-photo-dev ffmpeg \
        libavutil-dev libswscale-dev libcudnn8=8.8.0.121-1+cuda11.8 libcudnn8-dev=8.8.0.121-1+cuda11.8 && \
    apt clean

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN python3 -m pip install numpy

# Install Bazel
RUN wget https://github.com/bazelbuild/bazel/releases/download/6.1.1/bazel_6.1.1-linux-x86_64.deb && \
    apt install -y ./bazel_6.1.1-linux-x86_64.deb && \
    rm bazel_6.1.1-linux-x86_64.deb

# Create symbolic links for OpenCV
RUN cd /usr/include/ && ln -s opencv4/opencv2 . && \
    cd /usr/lib/x86_64-linux-gnu/

RUN cd /usr/lib/x86_64-linux-gnu/ && \
    ln -s libopencv_calib3d.so.4.5.4d libopencv_calib3d.so.4.5 && \
    ln -s libopencv_features2d.so.4.5d libopencv_features2d.so.4.5 && \
    ln -s libopencv_highgui.so.4.5d libopencv_highgui.so.4.5 && \
    ln -s libopencv_video.so.4.5d libopencv_video.so.4.5 && \
    ln -s libopencv_videoio.so.4.5d libopencv_videoio.so.4.5 && \
    ln -s libopencv_imgcodecs.so.4.5d libopencv_imgcodecs.so.4.5 && \
    ln -s libopencv_imgproc.so.4.5d libopencv_imgproc.so.4.5 && \
    ln -s libopencv_core.so.4.5d libopencv_core.so.4.5 

COPY . /opt/mediapipe/

RUN cd /opt/mediapipe && \
    python3 -m pip install -r requirements.txt

RUN cd /opt/mediapipe && \
    export TF_CUDA_PATHS=/usr/local/cuda-11.8,/usr/include,/usr/include/x86_64-linux-gnu,/usr/lib/x86_64-linux-gnu,/usr/lib/nvidia-cuda-toolkit,/usr/lib/nvidia-cuda-toolkit/bin && \
    python3 setup.py bdist_wheel

RUN python3 -m pip install /opt/mediapipe/dist/mediapipe-0.10.1-cp310-cp310-linux_x86_64.whl