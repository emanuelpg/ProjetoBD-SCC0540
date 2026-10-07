import psycopg
import json

with open("config.json", "r") as config_file:
    config = json.load(config_file)

db = config["database"]
conn = psycopg.connect(
host=db["host"],
port=db["port"],
dbname=db["dbname"],
user=db["user"],
password=db["password"]
)
