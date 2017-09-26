FROM debian:jessie

ARG DOWNLOAD_URL

RUN apt-get update && \
    apt-get -y --no-install-recommends install libfontconfig curl ca-certificates npm git vim && \
    apt-get clean && \
    curl ${DOWNLOAD_URL} > /tmp/grafana.deb && \
    dpkg -i /tmp/grafana.deb && \
    rm /tmp/grafana.deb && \
    curl -L https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64 > /usr/sbin/gosu && \
    chmod +x /usr/sbin/gosu && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    npm install -g n && \
    n stable && \
    cd /opt && \
    git clone https://github.com/utkarshcmu/wizzy.git && \
    cd wizzy && \
    npm install && \
    npm link && \
    wizzy init && \
    wizzy set grafana url http://localhost:3000 && \
    wizzy set grafana username admin && \
    wizzy set grafana password admin



# VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]

EXPOSE 3000

COPY ./datasources /opt/wizzy/datasources
COPY ./dashboards /opt/wizzy/dashboards

COPY ./run.sh /run.sh

CMD ["/run.sh"]
