#!/bin/sh
apt-get source apr-util/jessie
(
    cd apr-util-1.5.3/
    dch --bpo "No changes."
    pdebuild --debbuildopts '-v1.4.1-3' \
        --use-pdebuild-internal --buildresult /usr/src/backports/wheezy/ \
        --pbuildersatisfydepends /usr/lib/pbuilder/pbuilder-satisfydepends-experimental \
        -- --basetgz /var/cache/pbuilder/base-wheezy-bpo.tar.gz \
           --bindmounts /usr/src/backports/wheezy/ \
           --hookdir /usr/src/backports/wheezy/
)
