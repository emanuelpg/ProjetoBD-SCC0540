from ollama import Client
from pathlib import Path
import json
from BancoDeDados import BancoDeDados

BASE_DIR = Path(__file__).resolve().parent

class Chat:
    def __init__(self, ddl=None):

        with open(BASE_DIR / "config.json", encoding="utf-8") as f:
            config = json.load(f)

        ollama_config = config['ollama']
        self.client = Client(
            host=ollama_config["host"]
        )
        self.model = ollama_config["model"]
        self.ddl = ddl if ddl is not None else BancoDeDados().ddl
    def make_prompt(self, prompt):
        # chamada do modelo
        response = self.client.chat(
            model=self.model,
            messages=[
                {
                    "role": "system",
                    "content": f"Você é um assistente de banco de dados cuja resposta sempre é um código SQL com base no(s) prompt(s) fornecido(s) (SEMPRE traduzindo os prompt para código). forneça o código SQL dentro de blocos de código formatados com a linguagem SQL e que esteja de acordo com o DDL: {self.ddl}."
                },
                {
                    "role": "user",
                    "content": prompt
                }
            ]
        )

        resposta = response["message"]["content"]
        return resposta

    def extract_sql_from_response(self, response):
        # Extrai o SQL da resposta do modelo
        start_index = response.find("```sql")
        end_index = response.find("```", start_index + 1)

        if start_index != -1 and end_index != -1:
            sql_code = response[start_index + len("```sql"):end_index].strip()
            return sql_code
        else:
            return None


#print(Chat().make_prompt("Crie um script SQL para criar o banco de dados com base no seguinte DDL:\nCREATE TABLE exemplo (id SERIAL PRIMARY KEY, nome VARCHAR(100));"))