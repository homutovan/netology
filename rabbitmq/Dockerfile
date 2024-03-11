FROM bitnami/rabbitmq:latest
USER root
RUN echo 12345 > /var/lib/rabbitmq/.erlang.cookie
RUN chmod 400 /var/lib/rabbitmq/.erlang.cookie
