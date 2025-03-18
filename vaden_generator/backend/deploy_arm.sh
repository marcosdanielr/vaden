#!/bin/bash

IMAGE_NAME="jacobmoura7/vaden-generator-backend"

echo "🚀 Iniciando o build da imagem Docker para múltiplas arquiteturas..."

docker buildx create --use || true
docker buildx inspect --bootstrap

PLATFORMS="linux/amd64,linux/arm64"

docker buildx build --platform $PLATFORMS -t $IMAGE_NAME:latest --push .

echo "✅ Build e push concluídos com sucesso para múltiplas arquiteturas!"