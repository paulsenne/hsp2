FROM buildpack-deps:zesty
MAINTAINER Paul Senne <paul.senne@respec.com>

RUN apt-get update && apt-get install --yes --no-install-recommends locales && apt-get purge && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen &&     locale-gen
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV SHELL /bin/bash
ENV NB_USER jupyter
ENV NB_UID 1000
ENV HOME /home/${NB_USER}
EXPOSE 8888

RUN useradd -ms /bin/bash -u 1000 ${NB_USER}
RUN chown -R ${NB_USER} ${HOME}

RUN apt-get update && apt-get install -y python python-dev python-pip virtualenv gfortran unzip && apt-get purge && apt-get clean && rm -rf /var/lib/apt/lists/*

USER ${NB_USER}
ENV SHELL /bin/bash

RUN pip install --no-cache jupyter

ENV PATH ${PATH}:/home/${NB_USER}/.local/bin

USER root
# build jupyter config file and set an empy token
RUN jupyter notebook --generate-config && echo "c.NotebookApp.token = ''" > /home/${NB_USER}/.jupyter/jupyter_notebook_config.py

# get HSP2 and build
COPY . ${HOME}/HSPsquared

RUN cd ${HOME}/HSPsquared \
    && rm -r wdmtoolbox \
    && pip install --no-cache -r requirements.txt \
    && pip install --no-cache wdmtoolbox

RUN chown -R ${NB_USER} ${HOME}

USER ${NB_USER}
# set python path to include hsp2 modules
ENV PYTHONPATH ${HOME}/HSPsquared:${PYTHONPATH}

WORKDIR ${HOME}

# ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser"]

