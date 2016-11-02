#FROM nginx:1.11.1

FROM nginx:1.11.5-alpine

ENV CONTAINER_DIR /usr/share/nginx/html/
ENV PUBLIC_DIR test/

WORKDIR $CONTAINER_DIR/$PUBLIC_DIR

COPY default.conf /etc/nginx/conf.d/
COPY public $CONTAINER_DIR/$PUBLIC_DIR

#RUN apt-get update && apt-get install -y git && cd /usr/share/nginx/html/ && git clone https://github.com/deliveryprinciples/LightSvr

# docker run --rm -it --name www -p 80:80 -v /Users/andrew/Code/LightSvr/website:/usr/share/nginx/html lightdf/testwww
# docker run --name www --rm -p 80:80 lightdf/testwww
