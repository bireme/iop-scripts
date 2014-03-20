#!/bin/bash
# ------------------------------------------------------------------------- #
# GenBasesCISIS.sh - Extrai elementos de XML para base CISIS
# ------------------------------------------------------------------------- #
#      Entrada: sem parametros
#        Saida: arquivo mst e xrf
#     Corrente: /processo/bases/
#      Chamada: ../tpl/GenBasesCISIS.sh
#      Exemplo: nohup ../tpl/GenBasesCISIS.sh &> ../outs/proc.YYYYMMDD.out &
#  Objetivo(s): Criar bases CISIS com elementos de XML
#
#  Comentarios: E NECESSARIO A EXISTENCIA DA VERSAO FFIG4 DE CISIS NA MAQUINA
#
#  Observacoes: A estrutura de diretorios esperada eh:
#               /processo/
#                        |
#                        +--- outs
#                        +--- tabs
#                        +--- tpl
#                        +--- bases
#                        +--- xmls
#
# Dependencias:
#
# ==> tpl/GenBasesCISIS.sh
#    - bases/XMLs.lst
#    ==> tpl/ConvXML2ISIS.sh
#       ==> tpl/Xml2Isis.sh
#              - xmls (diretorio) 
#              - tabs/base.tab
#       - $TABS/ghtmlansFFIG4
#       - tabs/base.pft
#
# ------------------------------------------------------------------------- #
#   DATA    Responsaveis      Comentarios
# 20110808  Fabio Brito       Edicao original
#


# ------------------------------------------------------------------------- #
echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Processa $0 $1 $2 $3 $4 $5"
echo ""
# ------------------------------------------------------------------------- #

# Apaga arquivo que mostra os arquivos convertidos do processamento anterior
[ -f conversoes.lst ] && rm conversoes.lst

# Variaveis
COLECAO=${1}
DIR_SAIDA=${2}
CISIS="/usr/local/bireme/cisis/5.7c/linux64/ffiG4"

# Verificando a existencia de arquivos XML para processamento
EXISTE=`ls ../xml/${DIR_SAIDA}/*.xml | wc -l`

if [ $EXISTE -eq 0 ]
then
	echo "ERRO.: Sem arquivos XML para processamento!"
	exit 0
fi

echo "--> Montando lista de arquivos XML para processamento..."
ls ../xml/${DIR_SAIDA}/*.xml | sed s/"\.xml"//g > XMLs.lst

QTD_arqs_XML_processar=`cat XMLs.lst | wc -l`

for i in `cat XMLs.lst`
do
        COUNT=`expr $COUNT + 1`
	echo "---------------------------------------------------------------------------------------------"
	echo "*** Arquivo de trabalho ( $COUNT / $QTD_arqs_XML_processar ): ${i}.xml ***"
	../tpl/ConvXML2ISIS.sh $i
done

[ -f final.xrf ] && rm final.*


ls *.mst | sed s/"\.mst"//g > MSTs.lst
QTD_arqs_processar=`cat MSTs.lst | wc -l`

echo "Juntando arquivos Masteres"

if [ $QTD_arqs_processar -gt 1 ]
then
	# Se existir mais de 1 arquivo concatena
	for i in `cat MSTs.lst`
	do
		echo "  +++ Juntando ${i}"
		$CISIS/mx ${i} append=final -all now tell=10000
	done
else
	for i in `cat MSTs.lst`
	do
		mv ${i}.mst final.mst
		mv ${i}.xrf final.xrf
	done
fi

# Apagando arquivos MST temporario
for i in `cat MSTs.lst`
do
	[ -f ${i}.xrf ] && rm ${i}.*
done

unset CIPAR
[ -f MSTs.lst ] && rm MSTs.lst
#[ -f final.xrf ] && rm final.*
[ -f gbase.cip ] && rm gbase.cip
# ------------------------------------------------------------------------- #
echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Processa $0 $1 $2 $3 $4 $5"
# ------------------------------------------------------------------------- #

echo ""
echo "RELATORIO DE PROCESSAMENTO"
echo "-------------------------------------------------------------------------"
QTD_arqs_processados=`cat conversoes.lst | wc -l`
echo " Arquivos para processamento: $QTD_arqs_XML_processar"
echo " Arquivos processados:        $QTD_arqs_processados"
echo "-------------------------------------------------------------------------"


if [ "$QTD_arqs_processar" -eq "$QTD_arqs_processados" ]
then

	unset CIPAR
	[ -f MSTs.lst ] && rm MSTs.lst
	#[ -f final.xrf ] && rm final.*
	[ -f gbase.cip ] && rm gbase.cip
	[ -f conversoes.lst ] && rm conversoes.lst
	[ -f XMLs.lst ] && rm XMLs.lst
else
	echo "ALERTA!!!!"
	exit
fi

echo
unset HINIC
unset HRFIM
unset TPROC
unset QTD_arqs_processar
unset QTD_arqs_processados
