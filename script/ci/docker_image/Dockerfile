# Ubuntu 14.04 and build deps
from buildpack-deps:trusty

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

ENV MIX_ENV=test

RUN yes Y | LC_ALL=en_GB.UTF-8 mix local.hex
RUN yes Y | LC_ALL=en_GB.UTF-8 mix local.rebar

RUN cd /project \
 && mix do deps.get, deps.compile, compile
