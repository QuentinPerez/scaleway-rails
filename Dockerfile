## -*- docker-image-name: "scaleway/rails:latest" -*-
FROM scaleway/ruby:latest
MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)

# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

RUN apt-get -q update \
  && apt-get --force-yes -y -qq upgrade \
  && apt-get install -y -qq nginx nodejs

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
