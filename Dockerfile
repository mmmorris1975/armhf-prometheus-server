FROM arm32v7/busybox:1.27-uclibc
MAINTAINER Mike Morris

COPY prometheus          /bin/prometheus
COPY promtool            /bin/promtool
COPY prometheus.yml      /etc/prometheus/prometheus.yml
COPY console_libraries/  /usr/share/prometheus/console_libraries/
COPY consoles/           /usr/share/prometheus/consoles/

RUN ln -s /usr/share/prometheus/console_libraries /usr/share/prometheus/consoles/ /etc/prometheus/

EXPOSE     9090
VOLUME     [ "/prometheus" ]
WORKDIR    /prometheus
ENTRYPOINT [ "/bin/prometheus" ]
CMD        [ "-config.file=/etc/prometheus/prometheus.yml", \
             "-storage.local.path=/prometheus", \
             "-web.console.libraries=/usr/share/prometheus/console_libraries", \
             "-web.console.templates=/usr/share/prometheus/consoles" ]
HEALTHCHECK --start-period=8m --interval=10s --timeout=5s --retries=3 \
  CMD ["/bin/wget", "-q", "-O", "/dev/null", "http://localhost:9090/prometheus/graph"]
