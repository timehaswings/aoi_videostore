From ubuntu:20.04

RUN apt-get update && apt-get upgrade -y

RUN apt install -y  curl build-essential libssl-dev zlib1g-dev linux-generic libpcre3 libpcre3-dev ffmpeg libavcodec-dev libavformat-dev libswscale-dev

RUN mkdir nginx nginx-vod-module

RUN curl -sL https://nginx.org/download/nginx-1.20.1.tar.gz | tar -C /nginx --strip 1 -xz
RUN curl -sL https://github.com/kaltura/nginx-vod-module/archive/399e1a0ecb5b0007df3a627fa8b03628fc922d5e.tar.gz | tar -C /nginx-vod-module --strip 1 -xz

WORKDIR /nginx
RUN ./configure --prefix=/usr/local/nginx \
	--add-module=../nginx-vod-module \
	--with-http_ssl_module \
	--with-file-aio \
	--with-threads \
	--with-cc-opt="-O3"

RUN make && make install
RUN rm -rf /usr/local/nginx/conf/nginx.conf
COPY nginx.conf /usr/local/nginx/conf/
ENTRYPOINT ["/usr/local/nginx/sbin/nginx"]
CMD ["-g", "daemon off;"]




