// Programa   : GRUVTAVSGRUVTA
// Fecha/Hora : 23/10/2023 03:47:10
// Propósito  :
// cCual  > Mayores
//        < Menores
//        = Iguales
//        0 No existe En P1 si en P2=no
//        1 Si Existe En P2 si en P1=No // LEFT JOIN 
// Query      :=https://github.com/AdaptaProERP/dpxbase_diccionario_de_datos/blob/main/VTAGRUVSVTAGRU.SQL
// Vista      :=https://github.com/AdaptaProERP/DPVISTAS/blob/main/DPGRUPO_VTA.SQL
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(dDesde1,dHasta1,dDesde2,dHasta2,cCual,cTable,cKey,cName,cField,cFieldF)
  LOCAL cSql,cWhere1,cWhere2,cSub,cIf:="",oTable

  DEFAULT dDesde1:=FchIniMes(oDp:dFecha-120),;
          dHasta1:=FchFinMes(dDesde1)   ,;
          dHasta2:=dDesde1-1            ,;
          dDesde2:=FchIniMes(dHasta2)   ,;
          cCual  :=">"                  ,;
          cTable :="view_dpgrupo_vta"   ,;
          cKey   :="GRU_CODIGO"         ,;
          cName  :="GRU_DESCRI"         ,;
          cField :="GRU_CANTID"         ,;
          cFieldF:="GRU_FECHA"

  cWhere1:=GetWhereAnd("T1."+cFieldF,dDesde1,dHasta1)
  cWhere2:=GetWhereAnd("T2."+cFieldF,dDesde2,dHasta2)

  cSub:=[( SELECT SUM(]+cField+[) FROM ]+cTable+[ AS T2 ]+CRLF+;
        [  WHERE  T1.GRU_CODIGO=T2.]+cKey+[ AND ]+cWhere2+;
        [ ) AS VALHASTA, ]

  cIf :=[ IF (( SELECT SUM(]+cField+[) FROM ]+cTable+[ AS T2 ]+CRLF+;
        [  WHERE  T1.]+cField+[=T2.]+cKey+[ AND ]+cWhere2+[) IS NULL,SUM(]+cField+[), ]+CRLF+;
        [ ( SELECT SUM(]+cField+[) FROM ]+cTable+[ AS T2 ]+CRLF+;
        [  WHERE  T1.]+cKey+[=T2.]+cKey+[ AND ]+cWhere2+[)) AS DIF ]

  cSql:=[ SELECT  ]+cKey+[,]+cName+[,SUM(]+cField+[) AS VALDESDE, ]+CRLF+;
        [ ]+cSub+CRLF+;
        [ ]+cIf+CRLF+;
        [ FROM ]+cTable+[ AS T1 ]+CRLF+;
        [ WHERE ]+cWhere1  +CRLF+;
        [ GROUP BY ]+cKey  +CRLF+;
        [ ORDER BY ]+cField+[ DESC ]

? CLPCOPY(cSql)

  oTable:=OpenTable(cSql,.T.)
  oTable:Browse()
  oTable:End()
  
RETURN .T.
// EOF
