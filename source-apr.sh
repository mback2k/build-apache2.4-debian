#!/bin/sh
apt-get source apr/jessie
(
    cd apr-1.5.1/
    dch --bpo "No changes."
    pdebuild --debbuildopts '-v1.4.6-3+deb7u1' \
        --use-pdebuild-internal --buildresult /usr/src/backports/wheezy/ \
        --pbuildersatisfydepends /usr/lib/pbuilder/pbuilder-satisfydepends-experimental \
        -- --basetgz /var/cache/pbuilder/base-wheezy-bpo.tar.gz \
           --bindmounts /usr/src/backports/wheezy/ \
           --hookdir /usr/src/backports/wheezy/
)
