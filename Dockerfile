FROM python:3.10-slim

ARG HF_TOKEN
ENV HF_TOKEN=${HF_TOKEN}

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Download model with authentication
RUN python - <<EOF
from transformers import AutoTokenizer, AutoModelForCausalLM
import os

model_name = "google/gemma-2b-it"
token = os.environ["HF_TOKEN"]

AutoTokenizer.from_pretrained(model_name, token=token, cache_dir="/app/model")
AutoModelForCausalLM.from_pretrained(model_name, token=token, cache_dir="/app/model")
EOF

# Copy app code
COPY . .

# Expose port (optional)
EXPOSE 8080

# Start server
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]