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
