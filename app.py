from fastapi import FastAPI
from transformers import AutoModelForCausalLM, AutoTokenizer
import torch

app = FastAPI()

model_name = googlegemma-2b-it  # small, cheap, works for both tasks
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(model_name)

@app.post(generate)
def generate(prompt str)
    inputs = tokenizer(prompt, return_tensors=pt)
    outputs = model.generate(inputs, max_new_tokens=150)
    text = tokenizer.decode(outputs[0], skip_special_tokens=True)
    return {text text}

@app.post(embed)
def embed(text str)
    inputs = tokenizer(text, return_tensors=pt)
    with torch.no_grad()
        hidden = model(inputs, output_hidden_states=True).hidden_states[-1]
        embedding = hidden.mean(dim=1).squeeze().tolist()
    return {embedding embedding}