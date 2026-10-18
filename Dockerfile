FROM python:3.12-slim

WORKDIR /app

COPY public/ ./public/
COPY backend/ ./backend/
COPY falkordb_schema.cypher ./

EXPOSE 8080

CMD ["python", "backend/server.py"]
