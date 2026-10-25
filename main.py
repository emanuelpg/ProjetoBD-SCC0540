from pathlib import Path

from BancoDeDados import BancoDeDados
from Chat import Chat


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
    chat = Chat(ddl=bd.ddl)
    prompt = input("Digite o prompt para o modelo: ")
    resposta = chat.make_prompt(prompt)
    sql_code = chat.extract_sql_from_response(resposta)
    if sql_code:
        print("Código SQL extraído da resposta do modelo:")
        print(sql_code)
        if sql_code.strip().lower().startswith("select"):
            print("Executando consulta SQL...")
            result, cursor = bd.realiza_consulta(sql_code)
            bd.plotar_resultado_sql(result, cursor=cursor)
            cursor.close()
    ### Testes ###
    # prompt = f"Crie um script SQL para consultar todos os registros da tabela 'evento'"
    # resposta = chat.make_prompt(prompt)
    # print("Resposta do modelo:")
    # print(resposta)
    # sql_code = chat.extract_sql_from_response(resposta)
    # if sql_code:
    #     result, cursor = bd.realiza_consulta(sql_code)
    #     bd.plotar_resultado_sql(result, cursor=cursor)
    # else:
    #     print("Nenhum código SQL encontrado na resposta do modelo.")