import json
from pathlib import Path

from ollama import Client


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

def extracaoProjtxt():
    projeto_path = BASE_DIR.parent / "Projeto.txt"

    if not projeto_path.exists():
        print("Erro: Projeto.txt não encontrado.")
        raise SystemExit(1)
    projeto = projeto_path.read_text(encoding="utf-8")

    try:
        
        ddl = projeto.split("3. DDL COMPLETO", 1)[1]
        ddl = ddl.split("4. CONSULTAS", 1)[0]
        ddl = ddl.strip()

    return ddl

