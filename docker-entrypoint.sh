#!/bin/sh

if [ -z "${HF_API_TOKEN}" ]; then
  echo "The HF_API_TOKEN was not set. This can be created"
  echo "by logging in to https://huggingface.co/CompVis/stable-diffusion-v-1-4-original"
  echo "then going to https://huggingface.co/settings/tokens to retrieve an access token"
  exit 1
fi

MODEL_FILENAME=$(echo ${STABLE_DIFFUSION_MODEL_URL} | sed -r 's#.*/##g')
if [ ! -f "/models/${MODEL_FILENAME}" ]; then
  echo "Downloading the Stable Diffusion Model: ${STABLE_DIFFUSION_MODEL_URL}"
  curl \
  -H "Authorization: Bearer ${HF_API_TOKEN}" \
  -L -o /models/${MODEL_FILENAME} \
  ${STABLE_DIFFUSION_MODEL_URL}
fi

echo "/models/${MODEL_FILENAME}" >> /venv/lib/python${PYTHON_VERSION}/site-packages/neonpeacasso/ckpt_path.txt
source /venv/bin/activate

exec "$@"
