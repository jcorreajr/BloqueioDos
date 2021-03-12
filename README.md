# Análise de conexões DOS
## Simples analista de conexões não relatadas. Bane ips utilizando fail2ban

Tabela de conteúdos
=================
<!--ts-->
 * [Sobre](#Sobre)
 * [Pré-requisitos](#Pré-Requisitos)
 * [Comandos úteis](#Comandos-Úteis)
<!--te-->

## Sobre
Script que monitora através da resposta do comando netstat/ss, quais IPs estão acessando
o servidor, na porta pré-configurada 80;443 bloqueando ips com conexões *não estabelecidas* acima do limite estabelecido.

### Pré-requisitos
* Instalar e configurar fail2ban:
```bash
# apt install fail2ban
```
* Criar jail.local:
```bash
# cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
```

* Configurar novo jail:
```bash
# vim /etc/fail2ban/jail.d/banmanual.conf
Conteúdo de exemplo:
---
[banmanual]
enabled = true
filter = banmanual
logpath = /var/log/banmanual.log
maxretry = 1
port = 80,443
bantime = 5m
action = %(action_mwl)s
---
```

* Associar novo filtro ao jail:
```bash
# vim /etc/fail2ban/filter.d/banmanual.conf
Conteúdo de exemplo:
---
[Definition]
failregex = ^\[\w{1,3}.\w{1,3}.\d{1,2}.\d{1,2}:\d{1,2}:\d{1,2} \d{1,4}. \[error] \[client.<HOST>].File does not exist:.{1,40}roundcube.{1,200}
ignoreregex =
---
. Adicionar arquivo de log vazio
# touch /var/log/banmanual.log
```

* Configurar envio de email:
```bash
# vim /etc/fail2ban/fail2ban.local

```

* Analisar se outros jails ficaram ativos e reiniciar serviço:
```bash
# systemctl enable fail2ban #Para CentOs 
# systemctl restart fail2ban
# systemctl status fail2ban 
# fail2ban-client status
```


### Comandos Úteis
#### Arquivos de configuração:
```bash
* /root/scripts/conta_cnx_apache.sh

 → Variáveis de limite de conexão [limite]
```

```bash
* /root/scripts/ipsliberados.txt

→ Lista de IPs que não serão bloqueados
→ Adicionar o próprio IP do servidor neste arquivo
```

#### logs
* /root/scripts/conexao_apache.log → Mostra todas as operações do dia
* /var/log/fail2ban.log → Mostra IPs que foram banidos e que foram liberados

#### comandos monitoramento fail2ban
```bash
# fail2ban-client status banmanual → Mostra o status e quais IPs bloqueados
# fail2ban-client get banmanual banip --with-time → Quais IPs bloqueados e por quanto tempo
```
#### adição/retirada de bloqueio
```bash
# fail2ban-client set banmanual banip 192.168.100.201 → Banir manualmente
# fail2ban-client set banmanual unbanip 192.168.100.222 → Retirar do bloqueio
```
