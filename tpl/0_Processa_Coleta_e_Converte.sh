#!/bin/bash
# export DEBUG=true
# ------------------------------------------------------------------------- #
# 0_Processa_Coleta_e_Converte.sh - Processa Coleta e Conversao
# ------------------------------------------------------------------------- #
#      Entrada: PARM1 com o identificador de   'COLECAO'
#               VER OUTROS PARAMETROS
#        Saida: 
#     Corrente: 
#      Chamada: ./0_Processa_Coleta_e_Converte.sh [<COLECAO>]
#      Exemplo: ./0_Processa_Coleta_e_Converte.sh CUMED17
#     Objetivo: Coordenar o processamento de Harvest de XML e posterior conversao
#               para base ISIS
#  Comentarios: 
#  Observacoes: 
#
# ------------------------------------------------------------------------- #
#   DATA    RESPONSAVEL                  COMENTARIO
# 20140217  Fabio Brito                  edicao original
# ------------------------------------------------------------------------- #

# Anota hora de inicio de processamento
export HORA_INICIO=`date '+ %s'`
export HI="`date '+%Y.%m.%d %H:%M:%S'`"

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Processa ${0} ${1} ${3} ${4} ${5}"
echo ""
# ------------------------------------------------------------------------- #

#Variaveis
COLECAO="${1}"

# Posicionando processamento
cd /bases/xml2isis/iop/isis

# Inicio da coordenacao das chamadas dos módulos
# 1) Harvester
../tpl/1_Coleta.sh ${COLECAO}

# 2) Conversão de XML para ISIS
../tpl/2_Converte.sh ${COLECAO}

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
