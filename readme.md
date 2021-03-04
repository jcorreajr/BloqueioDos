# Analise de conexões DOS
## Analisa conexões não relatadas e bane ips utilizando fail2ban

Tabela de conteúdos
=================
<!--ts-->
 * [Sobre](#Sobre)
 * [Pré-requisitos](#Pre_Requisitos)
 * [Comandos úteis](#Comandos_Uteis)
<!--te-->

### Sobre [#Sobre]
Script que monitora através da resposta do comando netstat/ss, quais IPs estão acessando
o servidor, na porta pré-configurada 80;443 bloqueando ips com conexões *não estabelecidas* acima do limite estabelecido.

### Pré-requisitos [#Pre_Requisitos]
Instalar e configurar fail2ban
```bash
# apt install fail2ban
```
. Criar jail.local
. Configurar novo jail
. Associar novo filtro ao jail
. Configurar envio de email

### Comandos úteis [#Comandos_Uteis]
#### Arquivos de configuração:
 /root/scripts/conta_cnx_apache.sh → Variáveis de limite de conexão [limite]
 /root/scripts/ipsliberados.txt → Lista de IPs que não serão bloqueados

#### logs
/root/scripts/conexao_apache.log → Mostra todas as operações do dia
/var/log/fail2ban.log → Mostra IPs que foram banidos e que foram liberados

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
