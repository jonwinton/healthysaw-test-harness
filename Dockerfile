FROM ghcr.io/kyverno/chainsaw:v0.2.4

# Switch to root user to install additional packages
USER root
RUN apk --no-cache add curl

# This is where you can install your own chainsaw tests
WORKDIR /chainsaw-tests
COPY examples ./examples
RUN chmod 755 /chainsaw-tests

COPY chainsaw-runner.sh /chainsaw-runner.sh
RUN chmod +x /chainsaw-runner.sh
ENTRYPOINT ["/chainsaw-runner.sh"]