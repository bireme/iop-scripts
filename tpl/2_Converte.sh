#!/bin/bash
# export DEBUG=true
# ------------------------------------------------------------------------- #
# 2_Converte.sh - Processo de conversao de XML para base ISIS
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
# 20110823  Fabio Brito/Rafael Novello   edicao original
# ------------------------------------------------------------------------- #

echo "############################################################################"
echo "Processo de Conversao de XML para base ISIS"
echo "############################################################################"

# Variaveis
COLECAO=${1}
DIR_SAIDA=`echo ${1} | tr [:upper:] [:lower:]`


echo "+ Iniciando xml2isis"
cd /bases/xml2isis/iop/isis
../tpl/GenBasesCISIS.sh ${COLECAO} ${DIR_SAIDA}

if [ -f final.xrf ]
then
    # Se existir o diretorio da colecao apaga e depois cria
    [ -d ${DIR_SAIDA} ] && rm -fr ${DIR_SAIDA}
    [ ! -d ${DIR_SAIDA} ] && mkdir ${DIR_SAIDA}
    mv final.mst ${DIR_SAIDA}/${DIR_SAIDA}.mst
    mv final.xrf ${DIR_SAIDA}/${DIR_SAIDA}.xrf
    echo "Resultado ISIS disponivel em:"
    echo "`pwd`/${DIR_SAIDA}/"
fi

echo "############################################################################"
echo

