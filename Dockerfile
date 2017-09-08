#Firefox with SOCKS5 proxy configuration, but you can edit any configuration available in about:config
#To understand firefox configuration: https://developer.mozilla.org/en-US/Firefox/Enterprise_deployment
#LucasZanella.com

FROM ubuntu:zesty

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

#You should edit only THIS 'run' command:

RUN touch firefox/mozilla.cfg \
&& echo '//\n\
pref("network.proxy.socks_remote_dns", true);\n\
pref("network.proxy.socks", "127.0.0.1");\n\
pref("network.proxy.socks_port", 12345);\n\
pref("network.proxy.socks_version", 5);\n\
pref("network.proxy.type", 1);' \
>> firefox/mozilla.cfg

#Clean everything
RUN apt-get remove --purge -y wget bzip2 \
	&& apt autoremove -y \
	&& rm -rf /tmp/* /var/tmp/* \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

ENTRYPOINT /home/firefox/firefox
