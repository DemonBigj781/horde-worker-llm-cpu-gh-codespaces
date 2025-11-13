FROM mcr.microsoft.com/devcontainers/python:3.10

RUN sudo apt-get update \
    && sudo apt-get install -y git-lfs google-perftools bc libgl1 lshw

RUN git clone https://huggingface.co/segmind/tiny-sd \
    && cd tiny-sd \

# RUN git clone https://github.com/lshqqytiger/stable-diffusion-webui-directml

# RUN pip install xformers torch torchvision
