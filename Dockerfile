FROM ubuntu:20.04

ARG buildroot_version=2025.02.3
RUN test -n "$buildroot_version" || (echo "required argument 'buildroot_version' does not specified." && false)

RUN apt-get update && apt upgrade -y && apt-get install -y --no-install-recommends \
    tzdata \
    && rm -rf /var/lib/apt/lists/*; \
    update-locale LANG=en_US.UTF8; \
    dpkg-reconfigure tzdata

# cf: https://buildroot.org/downloads/manual/manual.html#requirement-mandatory
RUN apt-get update && apt upgrade -y && apt-get install -y --no-install-recommends \
    git sed binutils build-essential diffutils patch gzip bzip2 perl tar cpio \
    unzip rsync file bc wget findutils libncursesw5-dev ssh \
    && rm -rf /var/lib/apt/lists/*

# cf: https://buildroot.org/downloads/manual/manual.html#requirement-optional
RUN apt-get update && apt upgrade -y && apt-get install -y --no-install-recommends \
    python3 asciidoc w3m graphviz python3-pip python3-setuptools \
    && rm -rf /var/lib/apt/lists/*
RUN pip3 install matplotlib

ARG buildroot_name=buildroot-${buildroot_version}
RUN wget https://buildroot.org/downloads/${buildroot_name}.tar.gz
RUN tar xzf ${buildroot_name}.tar.gz
RUN rm ${buildroot_name}.tar.gz
RUN mv /${buildroot_name} /buildroot
WORKDIR /buildroot

ENTRYPOINT [ "/bin/bash" ]
