# Use a imagem base oficial do Jupyter Notebook
FROM jupyter/base-notebook

# Exponha a porta 8888
EXPOSE 8888

# Defina o diretório de trabalho como /app
WORKDIR /app

# Copie o arquivo de notebook de exemplo para o diretório /app dentro do contêiner
COPY notebook.ipynb /app/

# Inicie o servidor Jupyter Notebook quando o contêiner for iniciado
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
