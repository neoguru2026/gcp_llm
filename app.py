from fastapi import FastAPI
from pydantic import BaseModel
from transformers import AutoModelForCausalLM, AutoTokenizer
import torch
import uvicorn
import os

app = FastAPI()

#Model Path
MODEL_PATH = "/app/model"

tokenizer = AutoTokenizer.from_pretrained(MODEL_PATH)
model = AutoModelForCausalLM.from_pretrained(MODEL_PATH)

class GenerateRequest(BaseModel):
    prompt: str

class EmbedRequest(BaseModel):
    text: str

@app.post("/generate")
def generate(req: GenerateRequest):
    inputs = tokenizer(req.prompt, return_tensors="pt")
    outputs = model.generate(**inputs, max_new_tokens=150)
    text = tokenizer.decode(outputs[0], skip_special_tokens=True)
    return {"text": text}

@app.post("/embed")
def embed(req: EmbedRequest):
    inputs = tokenizer(req.text, return_tensors="pt")
    with torch.no_grad():
        hidden = model(**inputs, output_hidden_states=True).hidden_states[-1]
        embedding = hidden.mean(dim=1).squeeze().tolist()
    return {"embedding": embedding}

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    uvicorn.run(app, host="0.0.0.0", port=port)