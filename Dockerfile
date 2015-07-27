## -*- docker-image-name: "armbuild/scw-app-rails:latest" -*-
FROM armbuild/scw-distrib-ubuntu:trusty
MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)

# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

RUN apt-get -q update \
  && apt-get --force-yes -y -qq upgrade \
  && apt-get install -y -qq nginx nodejs

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
  && curl -sSL https://get.rvm.io | bash -s stable --rails

# Install rvm
RUN echo 'source /etc/profile.d/rvm.sh' >> /etc/profile \
  && /bin/bash -l -c "rvm requirements;" \
  && /bin/bash -l -c "gem install bundler rails unicorn"

# Create rails user
RUN adduser --disabled-password --shell /bin/bash --gecos 'Ruby on Rails user' rails \
  && usermod -a -G rvm rails

# Create default rails application
RUN /bin/bash -l -c "cd /home/rails && rails new default"  \
  && /bin/bash -l -c "cd /home/rails/default && rails generate controller welcome index" \
  && sed -ie "s/# root 'welcome#index'/root 'welcome#index'/" /home/rails/default/config/routes.rb \
  && chown -R rails:rails /home/rails/default

# Configure Unicorn
RUN mkdir -p /var/log/unicorn

# Configure Nginx
RUN cd /etc/nginx/sites-enabled/ \
  && rm default \
  && ln -s ../sites-available/rails .

# Patches
ADD patches/etc/ /etc/
ADD patches/usr/ /usr/
ADD patches/home/ /home/

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
