from haskell:7.10

RUN apt-get update && apt-get install -y git curl time bash

RUN curl -sL https://raw.githubusercontent.com/elm-lang/elm-platform/master/installers/BuildFromSource.hs -o BuildFromSource.hs
RUN curl -sL https://dl.bintray.com/elmlang/elm-platform/0.18.0/linux-x64.tar.gz -o /elm-bins.tar.gz && \
    mkdir /elmbin && \
    tar -xvzf /elm-bins.tar.gz -C /elmbin 
RUN rm /elm-bins.tar.gz

RUN runhaskell BuildFromSource.hs 0.18
# To recompile with rtsopts enabled
RUN sed -i "s/-threaded -O2 -W.*/-threaded -O2 -W -rtsopts/" /Elm-Platform/0.18/elm-make/elm-make.cabal
RUN runhaskell BuildFromSource.hs 0.18

RUN cp /Elm-Platform/0.18/.cabal-sandbox/bin/elm-make /elmbin/elm-make-rts

COPY benchmarks.sh /benchmarks.sh

CMD ["bash", "/benchmarks.sh"]