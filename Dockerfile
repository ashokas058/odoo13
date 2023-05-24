FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN adduser --system --home=/opt/odoo13 --group odoo13

RUN apt update \
&& apt-get install -y git wget \
&& apt-get install -y python3-pip \
&& apt-get install -y python-dev python3-dev libxml2-dev libxslt1-dev zlib1g-dev libsasl2-dev libldap2-dev build-essential libssl-dev libffi-dev libmysqlclient-dev libjpeg-dev libpq-dev libjpeg8-dev liblcms2-dev libblas-dev libatlas-base-dev

RUN apt-get install -y npm \
&& npm install -g less less-plugin-clean-css \
&& apt-get install -y node-less

RUN git clone https://www.github.com/odoo/odoo --depth 1 --branch 13.0 --single-branch /opt/odoo13 \
&& chown -R odoo13:odoo13 /opt/odoo13 \
&& pip3 install -r /opt/odoo13/requirements.txt

RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb \
&& apt install -y xfonts-75dpi xfonts-base gvfs colord glew-utils libvisual-0.4-plugins gstreamer1.0-tools opus-tools qt5-image-formats-plugins qtwayland5 qt5-qmltooling-plugins librsvg2-bin lm-sensors \
&& dpkg -i wkhtmltox_0.12.5-1.bionic_amd64.deb

RUN mkdir -p /etc/odoo13 /var/log/odoo13 /opt/odoo13/addons /opt/odoo13/custom-addons  \
&& rm /opt/odoo13/debian/odoo.conf
COPY odoo.conf /opt/odoo13/debian/
COPY startup.sh /opt/odoo13/
RUN chown -R odoo13:odoo13 /etc/odoo13/ \
&& chown -R odoo13:odoo13 /var/log/odoo13/ \
&& chown -R odoo13:odoo13 /opt/odoo13/ \
&& chmod -R 777 /etc/odoo13/ \
&& usermod -aG root odoo13 \
&& chmod 777 /opt/odoo13/startup.sh
WORKDIR /opt/odoo13/
USER odoo13
CMD [ "sh", "startup.sh" ]
