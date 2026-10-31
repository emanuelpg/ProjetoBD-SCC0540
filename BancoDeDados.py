import psycopg
import json
from pathlib import Path
import pandas as pd
from IPython.display import display, Markdown
import tkinter as tk
from tkinter import ttk

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

        self.ddl = self.extracaoProjtxt()

        # Criação do banco de dados
        with self.conn.cursor() as cursor:
            cursor.execute(self.ddl)
            self.conn.commit()
            print("Banco de dados criado com sucesso.")

        # População das tabelas com dados de exemplo
        with self.conn.cursor() as cursor:
            with open(BASE_DIR / "DML.sql", "r") as sql_file:
                cursor.execute(sql_file.read())
            self.conn.commit()
            print("Tabelas populadas com dados.")

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
        cursor = self.conn.cursor()
        cursor.execute(query)
        result = cursor.fetchall()
        # print("Resultado da consulta:")
        # for row in result:
        #     print(row)
        return result, cursor  # Retorna também o cursor para extração de nomes de colunas

    @staticmethod
    def plotar_resultado_sql(linhas, cursor=None):
        if not linhas:
            print("Nenhum dado retornado.")
            return

        colunas = [col.name if hasattr(col, "name") else col[0] for col in cursor.description] if (cursor is not None and cursor.description is not None) else None
        df = pd.DataFrame(linhas, columns=colunas)
        
        # Exibe no console preservando colunas e alinhamento
        print("### Resultado da Consulta SQL")
        print(df.to_string(index=False))

        # Exibe em uma janela Tkinter com barras de rolagem
        BancoDeDados.exibir_tabela(df, titulo="Resultado da Consulta SQL")

    def exibir_tabela(df: pd.DataFrame, titulo: str = "Visualização de Dados"):
        """Cria uma janela Tkinter com barras de rolagem (vertical e horizontal)

        para exibir um DataFrame do Pandas.
        """
        janela = tk.Tk()
        janela.title(titulo)
        janela.geometry("750x420")

        # Frame container para agrupar a tabela e as barras de rolagem
        frame = ttk.Frame(janela)
        frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)

        # Scrollbars (Vertical e Horizontal)
        scroll_y = ttk.Scrollbar(frame, orient=tk.VERTICAL)
        scroll_x = ttk.Scrollbar(frame, orient=tk.HORIZONTAL)

        # Componente de Tabela (Treeview)
        colunas = list(df.columns)
        tabela = ttk.Treeview(
            frame,
            columns=colunas,
            show="headings",
            yscrollcommand=scroll_y.set,
            xscrollcommand=scroll_x.set,
        )

        # Vincula o movimento das barras de rolagem à tabela
        scroll_y.config(command=tabela.yview)
        scroll_x.config(command=tabela.xview)

        # Configuração dos cabeçalhos e largura das colunas
        for col in colunas:
            tabela.heading(col, text=str(col))
            tabela.column(col, width=130, minwidth=80, anchor=tk.CENTER)

        # Inserção das linhas do DataFrame
        for _, linha in df.iterrows():
            # Converte valores nulos/None para string legível
            valores = [
                "" if pd.isna(valor) else str(valor) for valor in linha.tolist()
            ]
            tabela.insert("", tk.END, values=valores)

        # Posicionamento via layout de grade (grid)
        tabela.grid(row=0, column=0, sticky="nsew")
        scroll_y.grid(row=0, column=1, sticky="ns")
        scroll_x.grid(row=1, column=0, sticky="ew")

        # Permite que a tabela expanda ao redimensionar a janela
        frame.grid_rowconfigure(0, weight=1)
        frame.grid_columnconfigure(0, weight=1)

        janela.mainloop()