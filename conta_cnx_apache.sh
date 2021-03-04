#!/bin/bash

# Versão: v0.2

# Requerimento: 
# Programas: ss ou netstat; fail2ban

# Conta quantas conexões feitas ao apache (porta 80 e 443).
# Quando acima do limite, 
# - Envia para log
# - Envia para ser banido no fail2ban

# Bugs/melhoramentos:
# identificar linguagem do s.o. para filtrar LISTEN ou ESTAB
# identificar se S.O. tem ss ou netstat


# variaveis
limite=20
limitelinhaarquivo=2000
arquivotmp='saidanetstat.tmp'
arquivolog='conexao_apache.log'
arquivoliberados='ipsliberados.txt'
controle=0
diretorio=/root/scripts/

cd $diretorio

echo "var:arquivoliberados:.. "$arquivoliberados
echo "var:arquivotmp:.. "$arquivotmp
echo "var:arquivolog:.. "$arquivolog
echo "var:limite:.. "$limite
echo ""
echo ""

# Lista conexões atuais para arquivo temporário
# Descomentar abaixo para netstat
netstat -an | egrep ':443|:80' | egrep '^tcp' | grep -v LISTEN | awk '{print $5}' | egrep '([0-9]{1,3}\.){3}[0-9]{1,3}' | sed 's/^\(.*:\)\?\(\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}\).*$/\2/' | sort | uniq -c | sort -nr | sed 's/::ffff://' > $arquivotmp

# Descomentar abaixo para ss
##ss -an | egrep ':443|:80' | egrep '^tcp' | grep -v ESTAB | awk '{print $6}' | egrep '([0-9]{1,3}\.){3}[0-9]{1,3}' | sed 's/^\(.*:\)\?\(\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}\).*$/\2/' | sort | uniq -c | sort -nr  > $arquivotmp

while read line; do
# lendo linha por linha
coluna1=$(echo "$line"|awk '{print $1}')
coluna2=$(echo "$line"|awk '{print $2}')

if [ $coluna1 -ge $limite ]
	then
	while read linha2; do
		# echo 'arquivo whitelist:.. '$linha2
		if [ $coluna2 = $linha2 ]
		then
		data=$(date +"%d-%m-%Y"_"%T")
		echo "NAO ADD - IP no Whitelist:.. $data - Qtd Acessos:.. $coluna1 IP:.. $coluna2" 
		echo "NAO ADD - IP no Whitelist:.. $data - Qtd Acessos:.. $coluna1 IP:.. $coluna2" >> $arquivolog
		controle=1
		break
		fi
	done < $arquivoliberados
	
	if [ $controle -eq 0 ] 
	then
		data=$(date +"%d-%m-%Y"_"%T")
		echo "Add $data - Qtd Acessos:.. $coluna1 IP:.. $coluna2"
		echo "Add $data - Qtd Acessos:.. $coluna1 IP:.. $coluna2" >> $arquivolog
		fail2ban-client set banmanual banip $coluna2 &>> $arquivolog
	fi	

else
	echo "QTD Inferior ao limite ... IP.. $coluna2 qtd:.. $coluna1"
fi

controle=0
done < $arquivotmp

# Mantem arquivo de log dentro do limite de linhas

tail -n $limitelinhaarquivo $arquivolog > 'ultimas_'$limitelinhaarquivo'_'$arquivolog
cat 'ultimas_'$limitelinhaarquivo'_'$arquivolog > $arquivolog


