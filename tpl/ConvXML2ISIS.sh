#!/bin/bash
# ------------------------------------------------------------------------- #
# ConvXML2ISIS.sh - Extrai elementos de XML 
# ------------------------------------------------------------------------- #
#      Entrada: PARM1 nome do arquivo XML sem a extensao
#        Saida: masteres de inversao e browser
#     Corrente: 
#      Chamada: ../tpl/ConvXML2ISIS.sh <arquivo XML sem extensao>  <nome do diretorio de saida>
#      Exemplo: nohup ../tpl/ConvXML2ISIS.sh 18 dezoito &> ../outs/proc.YYYYMMDD.out &
#  Objetivo(s): Criar bases CISIS com elementos de XML
#  Comentarios:
#  Observacoes: A estrutura de diretorios esperada eh:
#
# Dependencias:
#
#
# ------------------------------------------------------------------------- #
#   DATA    Responsaveis      Comentarios
# 20110325  Fabio Brito       Edicao original
# 20140217  Fabio Brito       Adaptacao para trabalho em SERVEROFI5
#



#echo "---------------------------------------------------------------------------------------------"
echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Processa $0 $1 $2 $3 $4 $5"
echo "---------------------------------------------------------------------------------------------"

# Verifica a passagem dos parametros
if [ "$#" -ne 1 ]
then
   echo "use: ConvXML2ISIS.sh <arquivo XML sem extensao>
                        Ex. ./ConvXML2ISIS.sh 18"
   exit 0
fi

# Variaveis
# DIR_XML=${2}
DIR_XML=`echo ${1} | cut -d/ -f3-3`
OUTDB=`echo ${1} | cut -d/ -f4-4`
CISIS="/usr/local/bireme/cisis/5.7c/linux64/ffiG4"

# Apagando processamento anterior
[ -f ${OUTDB}.xrf ] && rm ${OUTDB}.[mx][sr][tf]

echo "mstxl=32G">gbase.cip
export CIPAR=gbase.cip

# ------------------------------------------------------------------------- #
echo "[$0] 1 - Criando Master de ${OUTDB}..."
# ------------------------------------------------------------------------- #
echo "Extraindo elementos"

#echo "../tpl/Xml2Isis.sh fileDir=../xml/${DIR_XML}/ xmlRegExp=${OUTDB}.xml convTable=../tabs/base.tab outDb=${OUTDB} --createMissingFields --createFileNameField fileEncoding=utf-8 dbEncoding=utf-8"
../tpl/Xml2Isis.sh fileDir=../xml/${DIR_XML}/ xmlRegExp=${OUTDB}.xml convTable=../tabs/base.tab outDb=${OUTDB} --createMissingFields --createFileNameField fileEncoding=utf-8 dbEncoding=utf-8

echo "Limpa base (mxcp)"
# $CISIS/mxcp ${OUTDB} create=wrk1_${OUTDB} clean 
$CISIS/mxcp ${OUTDB} create=wrk1_${OUTDB} clean log=/dev/null

echo
echo "Preparando base Isis - formato, gizmos"
echo "   + Monta campos de acordo com processamento"
#echo "$CISIS/mx wrk1_${OUTDB} \"proc=@../tabs/base.pft\" \"gizmo=../tabs/ghtmlansFFIG4\" \"gizmo=../tabs/gfFFIG4\" create=wrk2_${OUTDB} -all now tell=1000"
$CISIS/mx wrk1_${OUTDB} "proc=@../tabs/base.pft" "gizmo=../tabs/ghtmlansFFIG4" "gizmo=../tabs/gfFFIG4" "gizmo=../tabs/gsubcampos" "gizmo=../tabs/gespaco" create=wrk2_${OUTDB} -all now tell=1000

# Aplica gizmo gutf8ans
# Copia gizmo de tabs
cp ../tabs/gutf8ans.id .
$CISIS/id2i gutf8ans.id create=gutf8ansFFIG4
$CISIS/mx wrk2_${OUTDB} "gizmo=gutf8ansFFIG4" create=wrk3_${OUTDB} -all now

# Coloca em ordem
$CISIS/mx wrk3_${OUTDB} "proc='S'" create=final_${OUTDB} -all now



# Atualiza arquivo de conversoes realizadas
echo ${1}.xml >> conversoes.lst

# DEBUG
LIMPA_TEMPORARIOS=TRUE
if [ $LIMPA_TEMPORARIOS ]
then
    [ -f ${OUTDB}.xrf ] && rm ${OUTDB}.[mx][sr][tf]
    [ -f wrk1_${OUTDB}.xrf ] && rm wrk*${OUTDB}.[mx][sr][tf]
    [ -f gutf8ansFFIG4.xrf ] && rm gutf8ansFFIG4.{xrf,mst}
    [ -f gutf8ans.id ] && rm gutf8ans.id
fi

# Limpando variavel CIPAR
unset CIPAR

# ------------------------------------------------------------------------- #
echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Processa $0 $1 $2 $3 $4 $5"
echo
# ------------------------------------------------------------------------- #

