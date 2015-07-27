DOCKER_NAMESPACE =	armbuild/
NAME =			scw-app-rails
VERSION =		latest
VERSION_ALIASES =	14.10 14 latest utopic
TITLE =			Ruby on Rails
DESCRIPTION =		Ruby on Rails is an open-source web framework that’s optimized for programmer happiness and sustainable productivity.
SOURCE_URL =		https://github.com/scaleway/image-app-rails
DOC_URL =		https://scaleway.com/docs/getting-started-with-the-ruby-on-rails-instant-apps
IMAGE_VOLUME_SIZE =	50G

## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/scw-builder | bash
-include docker-rules.mk


## Here you can add custom commands and overrides
