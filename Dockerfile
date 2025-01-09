# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/devcontainers/python:1-3.12

COPY add-user.sh /tmp/add-user.sh

RUN chmod +x /tmp/add-user.sh && /tmp/add-user.sh

USER dev
