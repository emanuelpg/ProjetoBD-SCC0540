from pathlib import Path

from BancoDeDados import BancoDeDados


BASE_DIR = Path(__file__).resolve().parent

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