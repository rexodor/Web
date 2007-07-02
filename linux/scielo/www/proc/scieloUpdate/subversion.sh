#!/bin/bash
# SHELL SCRIPT que atualiza com diretorio o scielo metodologia
# @author: Deivid Martins

# Arquivo com as variaveis de configuração
. conf.sh

echo "************************************"
echo "** Atualiza com Repositorio 0.2	**"
echo "************************************"
sleep 3
echo "Acessando o Repositorio."
sleep 1
echo $clear
echo "Acessando o Repositorio.."
sleep 1
echo $clear
echo "Acessando o Repositorio..."
sleep 1

# Cria a pasta Temporaria
mkdir -p $caminhoTemp

# Acessa o repositorio e baixa todo o conteudo do scielo.br para a pasta temporaria
svn co $svnLocal --username $login --password $senha -q $caminhoTemp

# Acha todos os arquivos .def e remove eles 
echo "REMOVENDO ARQUIVOS DE CONFIGURAÇÃO" 
find $caminhoTemp -name *.def>def.txt
rm -f `cat def.txt`

# Acha todos os arquivos .ini e remove eles
find $caminhoTemp -name *.ini>ini.txt
rm -f `cat ini.txt`

echo "REMOVENDO DIRETÓRIOS .SVN" 
# Acha todas as pastas .svn e remove-as
find $caminhoTemp -name .svn>svn.txt
rm -rf `cat svn.txt`

# Remove todos os arquivos opcionais que estão no arquivo cantUpdate.txt
echo "REMOVENDO ARQUIVOS OPCIONAIS"
rm -rf `cat cantUpdate.txt`
rm -f `cat cantUpdate.txt`

# Zipando as pastas
echo "ZIPANDO DIRETÓRIOS COMMON (SEM BASES E BASES-WORK) e LINUX" 
cd $caminhoTemp/common/scielo/www/
tar cfpz common.tgz *
mv $caminhoTemp/common/scielo/www/common.tgz $caminhoTemp/common.tgz
cd $caminhoTemp/linux/scielo/www/
tar cfpz linux.tgz cgi-bin/ proc/
mv $caminhoTemp/linux/scielo/www/linux.tgz $caminhoTemp/linux.tgz

# Atualizando aplicação
echo "ATUALIZANDO APLICACAO"
cd $caminhoAPL/www
tar xfpz $caminhoTemp/common.tgz 
tar xfpz $caminhoTemp/linux.tgz 

# Apagando repositório temporario
echo "APAGANDO ARQUIVOS TEMPORARIOS"
rm -rf $caminhoTemp

# Altera permisao do wxis.exe para 775
echo "ALTERANDO PERMISSAO DO WXIS E DO DIRETORIO PROC"
cd $caminhoAPL/www/cgi-bin/
chmod 775 wxis.exe
chmod -R 774 $caminhoAPL/www/proc/*
# funcionalidade de reiniciar o chama automatico
if [ "$reiniciaChama" == "true" ] 
then
	echo "MATANDO O JAVA"
	killall java
	echo "REINICIANDO O CHAMA"
	cd $CHAMA_HOME
	nohup chama.sh &
	echo "CHAMA REINICIADO"
fi
echo "FINISH"