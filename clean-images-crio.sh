#!/bin/bash

# capturando a lista de imagens com crictl
images=$(crictl images -q)

# loop das versoes
for image in $images; do
  versions=$(crictl image-inspect --format '{{.Id}}' $image)
  latest=$(echo "$versions" | tail -n 1)

# remove todas as versoes de imagens deixando apenas a ultima versao
  for version in $versions; do
    if [ "$version" != "$latest" ]; then
      crictl rmi $version
    fi
  done
done
