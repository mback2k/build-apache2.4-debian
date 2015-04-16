#!/bin/sh
apt-get source apache2/jessie
(
    cd apache2-2.4.10/
    dch --bpo "Note: depends on backported libapr."
    pdebuild --debbuildopts '-v2.2.22-13+deb7u3' \
        --use-pdebuild-internal --buildresult /usr/src/backports/wheezy/ \
        --pbuildersatisfydepends /usr/lib/pbuilder/pbuilder-satisfydepends-experimental \
        -- --basetgz /var/cache/pbuilder/base-wheezy-bpo.tar.gz \
           --bindmounts /usr/src/backports/wheezy/ \
           --hookdir /usr/src/backports/wheezy/
)
