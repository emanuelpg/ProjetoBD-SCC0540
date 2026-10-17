import json
from pathlib import Path

from ollama import Client

from BancoDeDados import BancoDeDados


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
    projeto_path = BASE_DIR / "Projeto.txt"
    print(f"Verificando a existência do arquivo: {projeto_path}")

    if not projeto_path.exists():
        print("Erro: Projeto.txt não encontrado.")
        raise SystemExit(1)
    projeto = projeto_path.read_text(encoding="utf-8")

    try:
        ddl_bruto = projeto.split("3. DDL COMPLETO", 1)[1].split("4. CONSULTAS", 1)[0]

        # Remove linhas compostas apenas por '=' ou traços e espaços no início e fim
        linhas = ddl_bruto.splitlines()
        linhas_limpas = []

        for linha in linhas:
            texto = linha.strip()
            # Ignora linhas decorativas como "==========" ou cabeçalhos soltos sem comentário
            if set(texto) == {'='} or texto == "1. Dominios (tipos com regra de validacao reaproveitavel)":
                continue
            linhas_limpas.append(linha)

        ddl = "\n".join(linhas_limpas).strip()

    except IndexError:
        print("Erro: Formato do arquivo Projeto.txt inválido.")
        raise SystemExit(1)

    return ddl

# ddl = extracaoProjtxt()
# print("DDL extraído com sucesso:")
# print(ddl)

if __name__ == "__main__":
    # prompt = f"Crie um script SQL para criar o banco de dados com base no seguinte DDL:\n{ddl}"
    # resposta = chamando_modelo(prompt)
    # print("Resposta do modelo:")
    # print(resposta)
    bd = BancoDeDados()
    bd.test_consulta()