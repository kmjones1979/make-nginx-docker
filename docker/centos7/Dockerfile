FROM centos:centos7

LABEL authors="Kevin Jones - kevin@kevinjonescreates.com"

#environment variables
ENV nginxVersion "1.25.4"
ENV tmp "/tmp/nginx/src"
ENV container docker

# systemd prep
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
    systemd-tmpfiles-setup.service ] || rm -f $i; done); \
        rm -f /lib/systemd/system/multi-user.target.wants/*;\
        rm -f /etc/systemd/system/*.wants/*;\
        rm -f /lib/systemd/system/local-fs.target.wants/*; \
        rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
        rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
        rm -f /lib/systemd/system/basic.target.wants/*;\
        rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

# create nginx group and user
RUN groupadd -r nginx && useradd -r -g nginx nginx

# install dependencies
RUN yum install -y wget gcc gcc-c++ make zlib-devel pcre-devel openssl-devel

# download nginx source code
RUN mkdir -p $tmp

# Download nginx inside the container
#RUN wget http://nginx.org/download/nginx-$nginxVersion.tar.gz -P $tmp
#RUN tar -zxvf $tmp/nginx-$nginxVersion.tar.gz -C $tmp

# OR Download the package locally and upload to the container
#COPY tmp/nginx/src/nginx-$nginxVersion.tar.gz $tmp
#RUN tar -zxvf $tmp/nginx-$nginxVersion.tar.gz -C $tmp

# OR copy the source code to the container
ADD ../../tmp/nginx/src/nginx-$nginxVersion $tmp/nginx-$nginxVersion

# build nginx from source
RUN cd $tmp/nginx-$nginxVersion && ./configure \
    --prefix=/etc/nginx/ \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --user=nginx \
    --group=nginx \
    --with-http_v2_module \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-file-aio \
    --with-ipv6
RUN cd $tmp/nginx-$nginxVersion && make && make install

# install supervisord
RUN yum -y install epel-release
RUN yum -y install supervisor
RUN mkdir -p /var/log/supervisor

# copy supervisor configuration
COPY ../../etc/supervisor/conf.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# copy static nginx configuration and files
COPY ../../etc/nginx /etc/nginx

# clean up
RUN yum clean all

# clean up
RUN rm -rf /tmp/*

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
