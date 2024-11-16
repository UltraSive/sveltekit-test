FROM ghcr.io/railwayapp/nixpacks:ubuntu-1731369831

ENTRYPOINT ["/bin/bash", "-l", "-c"]
WORKDIR /app/

COPY .nixpacks/nixpkgs-e05605ec414618eab4a7a6aea8b38f6fbbcc8f08.nix .nixpacks/nixpkgs-e05605ec414618eab4a7a6aea8b38f6fbbcc8f08.nix
RUN nix-env -if .nixpacks/nixpkgs-e05605ec414618eab4a7a6aea8b38f6fbbcc8f08.nix && nix-collect-garbage -d

ARG CI EXAMPLE_NAME NIXPACKS_METADATA NODE_ENV NPM_CONFIG_PRODUCTION
ENV CI=$CI EXAMPLE_NAME=$EXAMPLE_NAME NIXPACKS_METADATA=$NIXPACKS_METADATA NODE_ENV=$NODE_ENV NPM_CONFIG_PRODUCTION=$NPM_CONFIG_PRODUCTION

# setup phase
# noop

# install phase
ENV NIXPACKS_PATH=/app/node_modules/.bin:$NIXPACKS_PATH
COPY . /app/.
RUN --mount=type=cache,id=o26Iv131hE8-/root/npm,target=/root/.npm npm ci

# build phase
COPY . /app/.
RUN --mount=type=cache,id=o26Iv131hE8-node_modules/cache,target=/app/node_modules/.cache npm run build

RUN printf '\nPATH=/app/node_modules/.bin:$PATH' >> /root/.profile

# start
COPY . /app
CMD ["npm run start"]
