ARG PYTHON_MINOR_VERSION=3.10

FROM python:${PYTHON_MINOR_VERSION}-bullseye

ARG TAMING_TRANSFORMERS_VERSION=20220113 \
ARG NEONPEACASSO_VERISON=20220915

RUN python -m venv venv \
    && . venv/bin/activate \
    && pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu116 \
    && pip install -e "git+https://github.com/jrstarke/taming-transformers.git@${TAMING_TRANSFORMERS_VERSION}#egg=taming-transformers" \
    && pip install "git+https://github.com/jrstarke/neonpeacasso.git@${NEONPEACASSO_VERISON}" \
    && mkdir /models

ENV STABLE_DIFFUSION_MODEL_URL="https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4.ckpt" \
    PORT=8080 \
    PATH="/venv/bin:$PATH" \
    NVIDIA_VISIBLE_DEVICES="all" \
    NVIDIA_DRIVER_CAPABILITIES="compute,utility"

ADD docker-entrypoint.sh /usr/bin/

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
CMD "neonpeacasso ui --port=$PORT"
