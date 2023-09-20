FROM nginx

ADD https://git.io/get-mo /usr/local/bin/mo
RUN chmod a+x /usr/local/bin/mo

RUN mkdir /www
COPY nginx.template /nginx.template
COPY run.bash /run.bash

EXPOSE 80
EXPOSE 443

ENV WHITELIST_LOCAL_IP true

ENTRYPOINT ["bash", "/run.bash"]
