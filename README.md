# Projeto Integrado: Banco de Dados PostgreSQL & Assistente LLM (Ollama)

Este repositório contém a infraestrutura de banco de dados relacional (PostgreSQL), scripts em PL/pgSQL com regras de negócio e gatilhos, e uma interface em Python para integração com modelos locais via Ollama e execução de consultas via `psycopg`.

---

## 📌 Visão Geral do Projeto

O projeto combina modelagem de dados relacional avançada com processamento de linguagem natural:
1. **Modelagem & DDL:** Criação e estruturação de esquemas relacionais no PostgreSQL com uso de chaves primárias (`GENERATED ALWAYS AS IDENTITY`), chaves estrangeiras, tipos customizados, domínios e restrições de integridade complexas (`CHECK`).
2. **Lógica Procedural (PL/pgSQL):** Gatilhos (*triggers*) e funções armazenadas para manutenção da consistência de dados, prevenção de inconsistências lógicas em ciclos relacionais, restrições entre relações disjuntas e auditoria automática.
3. **Integração Python & LLM:** Script em Python (`chat.py`) que utiliza a biblioteca oficial do Ollama para processar prompts e gerar scripts SQL dinâmicos, conectando-se ao PostgreSQL via biblioteca `psycopg` (versão 3).

---

## 🛠️ Tecnologias Utilizadas

- **SGBD:** [PostgreSQL](https://www.postgresql.org/) (versão 15+)
- **Linguagem Procedural:** PL/pgSQL
- **Linguagem da Aplicação:** Python 3.13+
- **Driver de Banco:** `psycopg` (psycopg3)
- **Servidor de Modelos Locais:** [Ollama](https://ollama.com/)

---

## ⚙️ Configuração do Ambiente

### Clonar e preparar o ambiente Python
```bash
# Criar ambiente virtual
python -m venv .venv

# Ativar ambiente virtual
# Windows:
.venv\Scripts\activate
# Linux/macOS:
source .venv/bin/activate

# Instalar dependências
pip install ollama psycopg[binary]
```

## 🚀 Executando o Serviço do Ollama
### 1. Inicie o servidor Ollama:

No Windows/macOS: abra a aplicação desktop do Ollama.
No Linux ou via terminal:

```bash
ollama serve
```

### 2. Baixe o modelo configurado:
```bash
ollama pull qwen3:8b
```


