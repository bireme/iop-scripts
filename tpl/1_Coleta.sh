#!/bin/bash
# export DEBUG=true
# ------------------------------------------------------------------------- #
# Harvester_IOP.sh - Processo de Harvest de XML a partir de isis-oai-provider
# ------------------------------------------------------------------------- #
#      Entrada: PARM1 com o identificador de   'COLECAO'
#               VER OUTROS PARAMETROS
#        Saida: 
#     Corrente: /home/fabio.brito/interoperabilidade/
#      Chamada: ./Converte.sh [<COLECAO>] + OUTROS PARAMETROS
#      Exemplo: ./Converte.sh
#     Objetivo: Coordenar o processamento de Harvest de XML e posterior conversao
#               para base ISIS
#  Comentarios: 
#  Observacoes: 
#        Notas: A estrutura de diretorios esperada eh:
#                 /xxx/xxx
#                           |
#                           +---- /harvesting
#                           +---- /xml2isis_dspace
#
# ------------------------------------------------------------------------- #
#   DATA    RESPONSAVEL                  COMENTARIO
# 20131106  Fabio Brito                  edicao original
# ------------------------------------------------------------------------- #

# Anota hora de inicio de processamento
export HORA_INICIO=`date '+ %s'`
export HI="`date '+%Y.%m.%d %H:%M:%S'`"

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Processa ${0} ${1} ${3} ${4} ${5}"
echo ""
# ------------------------------------------------------------------------- #

ARQCOLECAO="/bases/xml2isis/iop/tabs/colecoes.tab"

COLECAO=`echo ${1} | tr [:lower:] [:upper:]`
URL=`mx seq=${ARQCOLECAO} "pft=if s(mpu,v1,mpl)='${COLECAO}' then v2 fi" -all now`
DIR_SAIDA=`mx seq=${ARQCOLECAO} "pft=if s(mpu,v1,mpl)='${COLECAO}' then v3 fi" -all now`
METADATAPREFIX=`mx seq=${ARQCOLECAO} "pft=if s(mpu,v1,mpl)='${COLECAO}' then v4 fi" -all now`
STATUS=`mx seq=${ARQCOLECAO} "pft=if s(mpu,v1,mpl)='${COLECAO}' then v5 fi" -all now`

# Verificando se variaveis para chamado foram recuperadas
if [ ! ${URL} -o ! ${DIR_SAIDA} ]
then
   echo "ERRO: ${0}"
   echo "   Nao foi possivel coletar informacoes de ${ARQCOLECAO}"
   exit 0
fi

echo "+ Realizando processo para:"
echo " - Colecao: $COLECAO"
echo " - URL: ${URL}"
echo " - Diretorio de saida: ${DIR_SAIDA}"
if [ ${STATUS} ]
then
   echo " - ATENCAO! Status: DESABILITADO!!!"
   echo "           verificar arquivo ${ARQCOLECAO}"
   exit 0
fi
echo

echo "############################################################################"
echo "Processo de Harvest de XML oriundo de ISIS-OAI-PROVIDER"
echo "############################################################################"

# Inicio
# Entrando no diretorio harvesting
cd /home/apps/harvester/coleta_isis_oai_provider/harvester
# Ativando VirtualEnv
source bin/activate
# Posicionando processamento
cd harvester
echo "+ Aplicando chamada"
echo "./harvester.py -u ${URL} -m ${METADATAPREFIX} -s ${COLECAO} -o ${DIR_SAIDA} -v"
./harvester.py -u ${URL} -m ${METADATAPREFIX} -s ${COLECAO} -o ${DIR_SAIDA} -v

# Criando diretorio para colecao
pwd
[ -d /bases/xml2isis/iop/xml/${DIR_SAIDA}/ ] && rm -fr /bases/xml2isis/iop/xml/${DIR_SAIDA}/
[ ! -d /bases/xml2isis/iop/xml/${DIR_SAIDA}/ ] && mkdir /bases/xml2isis/iop/xml/${DIR_SAIDA}/

# Movendo arquivo XML para diretorio da colecao
mv xml/${DIR_SAIDA}/*.xml /bases/xml2isis/iop/xml/${DIR_SAIDA}/

# Apagando diretorio de processamento
[ -d xml/${COLECAO} ] && rm -rf xml/${COLECAO}

cd /bases/xml2isis/iop/isis/


HORA_FIM=`date '+ %s'`
DURACAO=`expr ${HORA_FIM} - ${HORA_INICIO}`
HORAS=`expr ${DURACAO} / 60 / 60`
MINUTOS=`expr ${DURACAO} / 60 % 60`
SEGUNDOS=`expr ${DURACAO} % 60`

echo
echo "DURACAO DE PROCESSAMENTO"
echo "-------------------------------------------------------------------------"
echo " - Inicio:  ${HI}"
echo " - Termino: `date '+%Y.%m.%d %H:%M:%S'`"
echo
echo " Tempo de execucao: ${DURACAO} [s]"
echo " Ou ${HORAS}h ${MINUTOS}m ${SEGUNDOS}s"
echo

# ------------------------------------------------------------------------- #
echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Processa  ${0} ${1} ${3} ${4} ${5}"
# ------------------------------------------------------------------------- #
echo
echo


# Limpando area de trabalho
unset HI
unset HORA_INICIO
unset HORA_FIM
unset DURACAO
unset HORAS
unset MINUTOS
unset SEGUNDOS
unset COLECAO
unset URL
unset DIR_SAIDA
unset STATUS
unset CISIS
