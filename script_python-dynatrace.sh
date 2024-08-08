import cx_Oracle
import requests
import json
import time
import pandas as pd
import logging

# Configurações de logging.
logging.basicConfig(filename='app.log', level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')

# Configurações
DT_TENANT = "seu_tenant_id"
DT_API_TOKEN = "seu_api_token"
DB_HOST = "host_do_banco_de_dados"
DB_PORT = "porta_do_banco_de_dados"
DB_USER = "usuario_do_banco_de_dados"
DB_PASSWORD = "senha_do_usuario_do_banco_de_dados"

# Conexão com o banco de dados Oracle
connection = cx_Oracle.connect(DB_USER, DB_PASSWORD, f"{DB_HOST}:{DB_PORT}/SID")
cursor = connection.cursor()

# Consulta para monitoramento (exemplo: número de sessões ativas)
query = "SELECT COUNT(*) FROM V$SESSION WHERE STATUS = 'ACTIVE'"
cursor.execute(query)
session_count = cursor.fetchone()[0]

# Enviando métrica para o Dynatrace
url = f"https://{DT_TENANT}.live.dynatrace.com/api/v2/metrics/ingest"
headers = {
    "Authorization": f"Api-Token {DT_API_TOKEN}",
    "Content-Type": "application/json"
}
payload = {
    "series": [
        {
            "metricKey": "custom.oracle.active_sessions",
            "dimensions": {
                "host": DB_HOST,
                "port": DB_PORT
            },
            "points": [
                {
                    "timestamp": int(time.time()) * 1000,
                    "value": session_count
                }
            ]
        }
    ]
}

response = requests.post(url, headers=headers, data=json.dumps(payload))

# Verificando se a métrica foi enviada com sucesso
if response.status_code == 202:
    print("Métrica enviada com sucesso para o Dynatrace!")
else:
    error_message = f"Falha ao enviar métrica para o Dynatrace. Código de status: {response.status_code}"
    print(error_message)

# Salvar os dados em um arquivo CSV
data = {
    "timestamp": int(time.time()),
    "session_count": session_count
}
df = pd.DataFrame([data])
df.to_csv("metricas.csv", index=False)

# Convertendo o arquivo CSV para XLS e salvando a planilha no mesmo diretório
# df.to_excel("metricas.xls", index=False)  # A planilha será salva no mesmo diretório onde o script está sendo executado