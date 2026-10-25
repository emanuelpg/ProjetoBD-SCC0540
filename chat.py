from ollama import Client
from pathlib import Path
import json

BASE_DIR = Path(__file__).resolve().parent


def chamando_modelo( prompt):
    with open(BASE_DIR / "config.json", encoding="utf-8") as f:
        config = json.load(f)

    ollama_config = config['ollama']
    client = Client(
        host=ollama_config["host"]
    )

    #chamada do modelo
    response = client.chat(
        model=ollama_config["model"],
        messages=[
        {
        "role": "user",
        "content": prompt
        }
        ]
    )

    resposta = response["message"]["content"]
    return resposta

print(chamando_modelo("Crie um script SQL para criar o banco de dados com base no seguinte DDL:\nCREATE TABLE exemplo (id SERIAL PRIMARY KEY, nome VARCHAR(100));"))