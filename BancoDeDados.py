import psycopg
import json
from pathlib import Path
import pandas as pd

BASE_DIR = Path(__file__).resolve().parent

class BancoDeDados:
    def __init__(self):
        with open(BASE_DIR / "config.json", "r") as config_file:
            config = json.load(config_file)

        db = config["database"]
        self.conn = psycopg.connect(
            host=db["host"],
            port=db["port"],
            dbname=db["dbname"],
            user=db["user"],
            password=db["password"]
        )

        ddl = self.extracaoProjtxt()

        # Criação do banco de dados
        with self.conn.cursor() as cursor:
            cursor.execute(ddl)
            self.conn.commit()
            print("Banco de dados criado com sucesso.")


    @staticmethod
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

    def realiza_consulta(self, query=None):
        if query is None:
            query = "SELECT * FROM evento;"
        with self.conn.cursor() as cursor:
            cursor.execute(query)
            result = cursor.fetchall()
            print("Resultado da consulta:")
            for row in result:
                print(row)
            return result, cursor  # Retorna também o cursor para extração de nomes de colunas

    @staticmethod
    def plotar_resultado_sql(linhas, cursor=None):
        if not linhas:
            print("Nenhum dado retornado.")
            return

        colunas = [col.name if hasattr(col, "name") else col[0] for col in cursor.description] if (cursor is not None and cursor.description is not None) else None
        df = pd.DataFrame(linhas, columns=colunas)
        
        # Exibe no console preservando colunas e alinhamento
        print(df.to_string(index=False))