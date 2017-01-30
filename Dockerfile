FROM node:6.9.4-wheezy

RUN mkdir /opt/st2web \
	&& mkdir /scripts/ \
	&& mkdir /data/

RUN chown -R node /opt/st2web	

ADD scripts /scripts/
ADD data /data/
RUN chmod 755 /scripts/*

RUN npm install -g gulp 

USER node

EXPOSE 3000

CMD /scripts/run.sh