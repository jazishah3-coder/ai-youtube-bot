FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg espeak-ng fonts-dejavu \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt

RUN sed -n "/cat > bot.py <<'PY'/,/^          PY$/p" .github/workflows/daily.yml \
    | sed '1d;$d' \
    | sed 's/^          //' \
    | sed 's/MODEL = "gemini-3.5-flash"/MODEL = "gemini-3.5-flash-lite"/' \
    > bot.py

CMD ["python", "bot.py"]
