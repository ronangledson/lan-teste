#!/bin/bash
#	Este script foi desenvolvido por Ronan G. Ramos em 12/2020, e tem como objetivo avaliar
# 	o desenpenho de uma rede intranet, efetuando testes de transferência de dados entre um
#	cliente e um servidor, por meio do aplicativo IPERF3.
#	Para isso é necessário que o IPERF3 esteja instalados nas duas máquinas que irão correr
#	o teste. Se você não tiver o IPERF3 instalado, instále-o antes de iniciar o uso deste 
#	script.
#	O uso deste script será de inteira responsabilidade do usuário, não tendo seu desenvolvedor
#	qualquer responsabilidade por danos que vierem a acontecer em decorrencia de seu uso.
#	Qualquer alterações, se distribuídas, deve ser comunicadas com o autor deste script.



aviso='';
titulo='IPERF3';
server="";
arquivo_bk="";
clear;
ghp_d=$(dpkg --get-selections | grep -c dialog)
echo $ghp_d;
if [ "$ghp_d" -eq "0" ]; then
	echo "Este script depende do comando <dialog> se ele não estiver instalado será instalaldo\n
	antes do $titulo! Se não concordar, cancele a instalação com ctl+c"
	echo 'Será necessário elevar os previlégios do usuário atual se não for root.'
	echo 'Digite S se concordar.';
	read ok;
	if [ $ok == "S" ] || [ $ok == "S" ]; then
	    which dialog || sudo apt -y install dialog;
	fi;
	clear;
fi
dialog --title 'Teste de Largura de Banda da REDE usando o $titilo' \
--msgbox "\n######################################################### 
           \n     Este script irá testar a largura de banda da REDE! 
           \n#########################################################" 10 65;
clear;
dialog --yesno 'Deseja continuar com o teste?' 0 0;
if [ $? != 0 ]; then
    dialog --title "Teste usando o $titulo" --infobox '\nAbortando Teste!' 10 65;
    sleep 3;
    clear;
    exit;
fi 
clear;
while IFS= read -r linha || [[ -n "$linha" ]]; do
    server=$linha
#	echo "linha: $linha";
done < tlb.conf;
echo "server: $server";
# sleep 5;
clear;
if [ "$server" != "0" ]; then
	dialog --yesno "Existe um servidor cadastrado, deseja usá-lo?
					\n IP do servidor: $server" 0 0;
	if [ $? == 0 ]; then
	    dialog --title "Teste usando o $titulo" --infobox '
	    \nO teste usará o servidor $server!' 10 65;
	    clear;
	else
		server=$( dialog --stdout --inputbox 'Digite o IP do Servidor IPERF3:' 0 0 );
	fi 
fi
aviso="Por padão serão realizados cinco interações e o resultado, sua média.
	   \n Deseja modificar o número de intrarações?";
	dialog --yesno "$aviso" 0 0;
	if [ $? != 0 ]; then
	    aviso="Número de intererações com o servidor será 5.";
	    testes=5;
	    dialog --title "Teste de Largura de banda - $titulo" --infobox "$aviso" 10 65;
	else
		testes=$( dialog --stdout --inputbox 'Digite o número de interações com o Servidor IPERF3:' 0 0 );
	fi 
aviso="Iniciando o Teste! no Servidor: $server";
dialog --title "Teste de Largura de banda - $titulo" --infobox "$aviso" 10 65;
iperf3 -c $server -i 1 -t $testes > out &&
dialog 	--title "Teste de Largura de banda - $titulo" --tailbox out 0 0;
clear;
exit;



#	dialog --yesno 'Existe um servidor cadastrado, deseja usá-lo? \
#					\n IP do servidor: $server' 0 0;
#	if [ $? != 0 ]; then
#	    dialog --title "Teste usando o $titulo" --infobox '\nAbortando Teste!' 10 65;
#	    clear;
#	    exit;
