FROM debian
ARG TARGETPLATFORM
RUN echo "I'm building for $TARGETPLATFORM"
VOLUME tmp root home
MAINTAINER Bhaskar Jayaraman bhaskar.jayaraman@pantheon.io

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles

RUN apt-get update
RUN apt-get --assume-yes install apt-transport-https
RUN apt-get --assume-yes install wget
RUN apt-get --assume-yes install sudo
RUN apt-get --assume-yes install systemctl
RUN apt-get --assume-yes install curl
RUN apt-get --assume-yes install vim
RUN apt-get --assume-yes install git
RUN apt-get --assume-yes install gcc
RUN curl -L https://github.com/fastly/cli/releases/download/v0.42.0/fastly_v0.42.0_linux-amd64.tar.gz | tar zxv && mv ./fastly /bin/
###RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable 
#RUN export PATH="$HOME/.cargo/bin:$PATH"
#RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
#ENV PATH="/root/.cargo/bin:${PATH}"
#RUN /root/.cargo/bin/rustup target add wasm32-wasi --toolchain stable
#RUN rustup target add wasm32-wasi --toolchain stable
###RUN $HOME/.cargo/bin/rustc target add wasm32-wasi --toolchain stable

RUN apt-get update && apt-get install -y wget
RUN mkdir -m777 /opt/rust /opt/cargo
ENV RUSTUP_HOME=/opt/rust CARGO_HOME=/opt/cargo PATH=/opt/cargo/bin:$PATH
RUN wget --https-only --secure-protocol=TLSv1_2 -O- https://sh.rustup.rs | sh /dev/stdin -y
#RUN rustup target add x86_64-unknown-freebsd
RUN rustup target add wasm32-wasi --toolchain stable
RUN printf '#!/bin/sh\nexport CARGO_HOME=/opt/cargo\nexec /bin/sh "$@"\n' >/usr/local/bin/sh
RUN chmod +x /usr/local/bin/sh



RUN mkdir /home/branch-dir
WORKDIR /home/branch-dir
RUN git clone "https://github.com/lotusbaba/First-Project"

WORKDIR /home/branch-dir/First-Project

EXPOSE 80 
EXPOSE 7676
RUN echo $DOCKER_HOST

ENTRYPOINT ["/bin/fastly", "compute", "serve","--addr", "0.0.0.0:7676"]
