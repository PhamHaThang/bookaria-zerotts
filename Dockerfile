FROM python:3.11-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    HF_HOME=/app/.cache/huggingface \
    ZEROTTS_HOST=0.0.0.0 \
    ZEROTTS_PORT=8080

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Pre-download model weights (~900 MB) into the image to avoid cold-start downloads.
RUN python -X utf8 -c 'from zerotts import ZeroTTS; ZeroTTS.from_pretrained("zeroweight-ai/ZeroTTS", revision="18d6681518a4becaed3c125ceb3c7db59905fe86")'

COPY server.py .

EXPOSE 8080
CMD ["python", "-X", "utf8", "server.py"]
