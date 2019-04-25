FROM ruby:2.5.3-stretch

CMD [ "--help" ]

ENTRYPOINT [ "travis" ]

RUN useradd -m travis

ENV PATH=${PATH}:/home/travis/.gem/ruby/2.5.0/bin

USER travis

RUN gem install travis \
      -v 1.8.9 \
      --user-install

WORKDIR /home/travis/app

VOLUME [ "/home/travis/.travis", "/home/travis/app" ]


ARG spec="org.opencontainers.image"
ARG BRANCH_NAME
ARG BUILD_DATE
ARG COMMIT_SHA

LABEL ${spec}.created=${BUILD_DATE}
LABEL ${spec}.documenation="https://github.com/darrengruen/docker-travisci/README.md"
LABEL ${spec}.source="https://github.com/darrengruen/docker-travisci"
LABEL ${spec}.revision=${COMMIT_SHA}
LABEL ${spec}.version=${BRANCH_NAME}
LABEL ${spec}.title="TravisCI CLI Runtime"
LABEL ${spec}.description="Run TravisCI CLI in a docker container"

