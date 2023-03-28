FROM ubuntu


RUN set -x \
 && apt update \
 && apt install -y git curl tar bash

ENV GH_RUNNER_VERSION 2.303.0
ENV GH_RUNNER_CHECKSUM e4a9fb7269c1a156eb5d5369232d0cd62e06bec2fd2b321600e85ac914a9cc73
ENV RUNNER_ALLOW_RUNASROOT 1

RUN set -x \
 && mkdir /actions-runner \
 && cd /actions-runner \
 && curl -o actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${GH_RUNNER_VERSION}/actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz \
 && echo "${GH_RUNNER_CHECKSUM}  actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz" | shasum -a 256 -c \
 && tar xzf ./actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz \
 && ls -al \
 && ./bin/installdependencies.sh

ARG TOKEN=please-set-via-build-arg

RUN set -x \
 && cd /actions-runner \
 && ./config.sh --url https://github.com/steve-todorov/github-runner-concurrency-test --token "$TOKEN"

WORKDIR /actions-runner

ENTRYPOINT [ "./run.sh" ]
