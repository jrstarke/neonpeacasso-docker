#!/bin/sh

if [ -z "${HF_API_TOKEN}" ]; then
  echo "The HF_API_TOKEN was not set. This can be created"
  echo "by logging in to https://huggingface.co/CompVis/stable-diffusion-v-1-4-original"
  echo "then going to https://huggingface.co/settings/tokens to retrieve an access token"
  exit 1
fi

MODEL_FILENAME=$(echo ${STABLE_DIFFUSION_MODEL_URL} | sed -r 's#.*/##g')
if [ ! -f "${MODEL_FILENAME}" ]; then
  echo "Downloading the Stable Diffusion Model: ${STABLE_DIFFUSION_MODEL_URL}"
  curl \
  -H "Authorization: Bearer ${HF_API_TOKEN}" \
  -L -O \
  ${STABLE_DIFFUSION_MODEL_URL}
fi

rm model.ckpt; ln -s ${MODEL_FILENAME} model.ckpt

exec "$@"
