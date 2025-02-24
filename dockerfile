FROM python:3.8-slim
COPY . .
CMD ["python3", "sum.py"]

