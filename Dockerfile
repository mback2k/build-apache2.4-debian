FROM debian:wheezy

MAINTAINER Marc Hoersken "info@marc-hoersken.de"

# Based upon https://wiki.debian.org/BuildingFormalBackports
RUN apt-get update
RUN apt-get install -y cowbuilder pbuilder

# Prepare local repo
RUN mkdir -p /usr/src/backports/wheezy/
RUN touch /usr/src/backports/wheezy/Packages

ADD D70results /usr/src/backports/wheezy/D70results
RUN chmod 755 /usr/src/backports/wheezy/D70results

# Create initial environment
RUN pbuilder --create --basetgz /var/cache/pbuilder/base-wheezy-bpo.tar.gz \
             --distribution wheezy \
             --othermirror "deb http://security.debian.org/ wheezy/updates main|deb http://deb.debian.org/debian wheezy-backports main|deb [trusted=yes] file:///usr/src/backports/wheezy ./" \
             --bindmounts /usr/src/backports/wheezy/

# Add source for 'apt-get source'
RUN echo "deb-src http://ftp.fr.debian.org/debian/ jessie main" \
    | tee /etc/apt/sources.list.d/jessie-src.list

RUN apt-get update

# Setup identity
ENV DEBEMAIL="info@marc-hoersken.de"
ENV DEBFULLNAME="Marc Hoersken"

# Configure build
ENV DEB_BUILD_OPTIONS="parallel=2"

# Create a working directory for sources
RUN mkdir /usr/src/backports/sources/
WORKDIR /usr/src/backports/sources/

# Dependencies to add in our local repo
ADD source-apr.sh /tmp/source-apr.sh
ADD source-apr-util.sh /tmp/source-apr-util.sh
RUN /tmp/source-apr.sh
RUN /tmp/source-apr-util.sh

# Apache 2.4 itself
ADD source-apache2.sh /tmp/source-apache2.sh
RUN /tmp/source-apache2.sh

# Sadly there's no hook to do that *after* the packages are installed in --buildresult
RUN (cd /usr/src/backports/wheezy && dpkg-scanpackages . /dev/null > Packages)

# Test
RUN pbuilder --login --basetgz /var/cache/pbuilder/base-wheezy-bpo.tar.gz --bindmounts /usr/src/backports/wheezy/
RUN /usr/src/backports/wheezy/D70results
CMD apt-get install apache2
