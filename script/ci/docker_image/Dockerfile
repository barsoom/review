from buildpack-deps:jessie

ENV OTP_VERSION=18.2.3

RUN set -xe \
  && OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-$OTP_VERSION.tar.gz" \
  && OTP_DOWNLOAD_SHA1="3c530cc8b72a0a5760ab61cd001041eea3de589b" \
  && curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
  && echo "$OTP_DOWNLOAD_SHA1 otp-src.tar.gz" | sha1sum -c - \
  && mkdir -p /usr/src/otp-src \
  && tar -xzf otp-src.tar.gz -C /usr/src/otp-src --strip-components=1 \
  && rm otp-src.tar.gz \
  && cd /usr/src/otp-src \
  && ./otp_build autoconf \
  && ./configure \
  && make -j$(nproc) \
  && make install \
  && find /usr/local -name examples |xargs rm -rf \
  && rm -rf /usr/src/otp-src

ENV ELIXIR_VERSION=1.2.1 \
    ELIXIR_SHA=9def4c1ee8eede93bf7e64c1861956dc30b2edda233fef423b790c4b31aeda54 \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

RUN set -xe \
  && curl -SL https://github.com/elixir-lang/elixir/archive/v${ELIXIR_VERSION}.tar.gz -o elixir.tar.gz \
  && echo "${ELIXIR_SHA}  elixir.tar.gz" | sha256sum -c - \
  && mkdir -p /usr/src/elixir \
  && tar -xzC /usr/src/elixir --strip-components=1 -f elixir.tar.gz \
  && rm elixir.tar.gz \
  && cd /usr/src/elixir \
  && make -j $(nproc) \
  && make install \
  && rm -rf /usr/src/elixir

ENV NODE_VERSION=5.5.0 \
    NODE_SHA=3e593d91b6d2ad871efaaf8e9a17b3608ca98904959bcfb7c42e6acce89e80f4

RUN curl -SL https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz -o node.tar.gz \
  && echo "${NODE_SHA}  node.tar.gz" | sha256sum -c - \
  && tar -xzC /usr/local --strip-components=1 -f node.tar.gz

ENV PHANTOMJS_VERSION=phantomjs-2.1.1-linux-x86_64 \
    PHANTOMJS_PATH=$HOME/$PHANTOMJS_VERSION \
    PHANTOMJS_SHA="86dd9a4bf4aee45f1a84c9f61cf1947c1d6dce9b9e8d2a907105da7852460d2f"

RUN wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOMJS_VERSION.tar.bz2 \
 && echo "$PHANTOMJS_SHA  phantomjs-2.1.1-linux-x86_64.tar.bz2" | sha256sum -c - \
 && tar xfj $PHANTOMJS_VERSION.tar.bz2 -C /tmp \
 && cp -rf /tmp/$PHANTOMJS_VERSION/* /usr/local \
 && rm -rf /tmp/$PHANTOMJS_VERSION

RUN locale-gen "en_US.UTF-8"
