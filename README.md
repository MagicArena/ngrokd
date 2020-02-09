# ngrokd
Run this container:

    docker run \
    --name ngrokd \
    --publish published=80,target=7070,protocol=tcp \
    --publish published=443,target=7071,protocol=tcp \
    --publish published=4443,target=7443,protocol=tcp \
    --publish published=1222,target=1222,protocol=tcp \
    --detach \
    --restart always \
    magicarena/ngrokd