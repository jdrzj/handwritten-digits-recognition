FROM ruby:2.7.1

WORKDIR /hdr_app
COPY . /hdr_app

# install packages
RUN apt-get update && apt-get install -y --no-install-recommends \
  autoconf \
  automake \
  build-essential \
  libczmq-dev \
  libffi-dev \
  libreadline-dev \
  libsox-dev \
  libsox-fmt-all \
  libssl-dev \
  libtool \
  libyaml-dev \
  libzmq3-dev \
  make \
  unzip \
  wget \
  zlib1g-dev \
  && \
  rm -rf /var/lib/apt/lists/*

# install LibTorch
RUN cd /opt && \
  wget -O libtorch.zip -q https://download.pytorch.org/libtorch/cu92/libtorch-cxx11-abi-shared-with-deps-1.7.1%2Bcu92.zip && \
  unzip -q libtorch.zip

RUN gem install --verbose -v 0.5.3 torch-rb -- --with-torch-dir=/opt/libtorch

RUN bundle install

EXPOSE 4567
ENTRYPOINT ["bash", "run_app.sh"]
