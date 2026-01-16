FROM python:3.10-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Download model at build time
RUN python - <<EOF
from transformers import AutoTokenizer, AutoModelForCausalLM
model_name = "google/gemma-2b-it"
AutoTokenizer.from_pretrained(model_name, cache_dir="/app/model")
AutoModelForCausalLM.from_pretrained(model_name, cache_dir="/app/model")
EOF

# Copy app code
COPY . .

# Expose port (optional)
EXPOSE 8080

# Start server
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]