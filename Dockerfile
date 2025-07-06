FROM python:3.13-slim-bookworm
COPY --from=ghcr.io/astral-sh/uv:0.7.17 /uv /uvx /bin/
ADD . /app
WORKDIR /app
RUN uv venv /opt/venv
RUN uv pip install --requirements requirements.txt --system
EXPOSE 8000
CMD ["sh", "-c", "datasette serve --host 0.0.0.0 --port 8000 --metadata metadata.yaml *.db"]
