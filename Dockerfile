#Firefox with SOCKS5 proxy configuration, but you can edit any configuration available in about:config
#To understand firefox configuration: https://developer.mozilla.org/en-US/Firefox/Enterprise_deployment
#LucasZanella.com

FROM ubuntu:zesty

ENV SOCKS_IP=127.0.0.1
ENV SOCKS_PORT=1080
ENV SOCKS_VERSION=5
#I couldn't find a way to set the username and password in firefox yet, but I'm gonna leave this here
#ENV SOCKS_USERNAME=""
#ENV SOCKS_PASSWORD="" 
ENV SOCKS_REMOTE_DNS=true

RUN apt-get update && apt-get install -y wget bzip2 libgtk-3-0 libdbus-glib-1-2 libxt6

WORKDIR /home

#The wget URL is already designed to download the latest firefox for linux 64
RUN wget --progress=bar:force:noscroll -O Firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest-SSL&os=linux64&lang=en-US" \
    && echo "Extracting Firefox.tar.bz2..." && tar jxf Firefox.tar.bz2 \
    && rm Firefox.tar.bz2

#multiline echo: https://github.com/moby/moby/issues/1799#issuecomment-126083922

RUN touch firefox/defaults/pref/autoconfig.js \
&& echo '//\n\
pref("general.config.filename", "mozilla.cfg");\n\
pref("general.config.obscure_value", 0);'\
>> firefox/defaults/pref/autoconfig.js

#Clean everything
RUN apt-get remove --purge -y wget bzip2 \
	&& apt autoremove -y \
	&& rm -rf /tmp/* /var/tmp/* \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

#You should edit only THIS command (and the ENVs above if needed):

CMD touch firefox/mozilla.cfg \
&& echo "//\n\
pref('network.proxy.socks_remote_dns', $SOCKS_REMOTE_DNS);\n\
pref('network.proxy.socks', \"$SOCKS_IP\");\n\
pref('network.proxy.socks_port', $SOCKS_PORT);\n\
pref('network.proxy.socks_version', $SOCKS_VERSION);\n\
pref('network.proxy.type', 1);\n\
pref('browser.startup.page', 0);\n\
pref('datareporting.policy.dataSubmissionEnabled', false);\n\
pref('browser.startup.homepage_override.mstone', \"ignore\");" \
>> firefox/mozilla.cfg \
&& /home/firefox/firefox
