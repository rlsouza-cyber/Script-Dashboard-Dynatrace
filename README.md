# Script-Dashboard-Dynatrace
Passo a Passo
1. Configurações Iniciais
Primeiro, você precisa configurar algumas variáveis no seu script. Abra o arquivo e substitua os valores:
python:
DT_TENANT = "seu_tenant_id"
DT_API_TOKEN = "seu_api_token"
DB_HOST = "host_do_banco_de_dados"
DB_PORT = "porta_do_banco_de_dados"
DB_USER = "usuario_do_banco_de_dados"
DB_PASSWORD = "senha_do_usuario_do_banco_de_dados"

2. Conexão com o Banco de Dados
O script se conecta ao banco de dados Oracle. Certifique-se de que as credenciais estão corretas. Se tudo estiver certo, você estará pronto para consultar as sessões ativas!

3. Consultando Sessões Ativas
O script executa uma consulta SQL para contar o número de sessões ativas no banco de dados:
python:
query = "SELECT COUNT(*) FROM V$SESSION WHERE STATUS = 'ACTIVE'"
4. Enviando Métricas para o Dynatrace
Com as métricas em mãos, o próximo passo é enviá-las para o Dynatrace. O script faz isso através de uma requisição POST. Verifique se o seu tenant e o token de API estão corretos!

5. Verificando o Status da Requisição
Após enviar as métricas, o script verifica se a requisição foi bem-sucedida:
python:
if response.status_code == 202:
    print("Métrica enviada com sucesso para o Dynatrace!")
else:
    print(f"Falha ao enviar métrica para o Dynatrace. Código de status: {response.status_code}")

6. Salvando os Dados em CSV
Por fim, o script salva os dados em um arquivo CSV. Você pode usar esses dados para análises futuras ou relatórios.
python:
df.to_csv("metricas.csv", index=False)

7. Executando o Script
Para executar o script, simplesmente rode o seguinte comando no terminal:
python seu_script.py

Conclusão
E aí está! Agora você tem um script funcional que monitora sessões ativas no Oracle e envia essas informações para o Dynatrace. Sinta-se à vontade para modificar e expandir o código conforme suas necessidades. Boa sorte com sua PoC!





