#!/bin/bash
# ------------------------------------------------------------------------- #
# Xml2Isis.sh - Programa para extracao de meta-dados do XML
# ------------------------------------------------------------------------- #
#      Entrada: sem parametros
#        Saida: masteres
#     Corrente: 
#      Chamada: ../tpl.xml2isis/Xml2Isis.sh fileDir=../xmls xmlRegExp=${OUTDB}.xml convTable=../tabs/mdl.tab outDb=${OUTDB} --createMissingFields --createFileNameField fileEncoding=utf-8 dbEncoding=utf-8
#
#  Observacoes: 
#               /bases/???/
#                         |
#                         +--- outs
#                         +--- tabs
#                         +--- tpl
#                         +--- bases
#
# Dependencias:
#
#
# ------------------------------------------------------------------------- #
#   DATA    Responsaveis           Comentarios
# 20101105  Heitor Barbieri        Edicao original
#


java -Xms512m -Xmx2g -cp /usr/local/bireme/java/Xml2Isis/dist/Xml2Isis.jar:/usr/local/bireme/java/Xml2Isis/dist/lib/zeusIII.jar:/usr/local/bireme/java/Xml2Isis/dist/lib/Utils.jar br.bireme.xml2isis.Xml2Isis $1 $2 $3 $4 $5 $6 $7 $8 $9
