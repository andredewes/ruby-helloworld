FROM ruby:2.7.7

# ===============  Preparing container for the App Service =============== 

RUN apt-get update -qq \
    && apt-get install -y nodejs openssh-server vim curl wget tcptraceroute --no-install-recommends \
    && echo "root:Docker!" | chpasswd \
    && echo "cd /home" >> /etc/bash.bashrc

# Make temp directory for ruby images
RUN mkdir -p /tmp/bundle
RUN chmod 777 /tmp/bundle

COPY init_container.sh /bin/
COPY startup.sh /opt/
COPY sshd_config /etc/ssh/

RUN chmod 755 /bin/init_container.sh \
  && mkdir -p /home/LogFiles/ \
  && chmod 755 /opt/startup.sh

# =============== Install application source code =============== 

WORKDIR /home/site/wwwroot

COPY src/Gemfile* .

ENV NOKOGIRI_USE_SYSTEM_LIBRARIES=true
RUN bundle config --global build.nokogiri -- --use-system-libraries
RUN bundle install
COPY src/ .
RUN bundle exec rails assets:precompile

EXPOSE 2222 8080

ENV PORT 8080
ENV SSH_PORT 2222
ENV WEBSITE_ROLE_INSTANCE_ID localRoleInstance
ENV WEBSITE_INSTANCE_ID localInstance
ENV PATH ${PATH}:/home/site/wwwroot

ENTRYPOINT [ "/bin/init_container.sh" ]