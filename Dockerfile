FROM programfan/docker-gitit:latest
LABEL maintainer="Yang Zhang <zyangmath@gmail.com>"

VOLUME ["/data/gitit-wiki", "/data/gitit-run"]
ADD ./gitit-templates-enhanced /data/gitit-templates-enhanced/
ADD ./docker-entrypoint.sh /data/gitit-run/
ADD ./run-service.sh /data/gitit-run/

EXPOSE 7500
WORKDIR "/data/gitit-run"
ENTRYPOINT ["/data/gitit-run/docker-entrypoint.sh"]
