*&---------------------------------------------------------------------*
*& Report      ZEDP_AUTO_REFRESH
*&---------------------------------------------------------------------*
* TITULO               : AUTO REFRESH                                  *
* AUTOR                : Daniel Escobar                                *
* PROVEEDOR            :                                               *
* FUNCIONAL            :                                               *
* FECHA                :                                               *
* TICKET               :                                               *
* ORDEN DE TRANSPORTE  :                                               *
*----------------------------------------------------------------------*
* LOG DE MODIFICACIONES                                                *
*----------------------------------------------------------------------*
* MOD. NO.| FECHA  | USUARIO  | TICKET          | ORDEN TRANSPORTE #   *
*----------------------------------------------------------------------*

REPORT zedp_auto_refresh.

*======================================================================*
*& SCREEN 1000                                                        &*
*======================================================================*
PARAMETERS: pa_seg TYPE I DEFAULT 60.

*======================================================================*
*& CLASS (DEFINITION DEFERRED)                                        &*
*======================================================================*
CLASS lcl_auto_refresh DEFINITION DEFERRED.

*======================================================================*
*& DATA                                                               &*
*======================================================================*
DATA:
  o_timer        TYPE REF TO cl_gui_timer,
  o_auto_refresh TYPE REF TO lcl_auto_refresh.

*======================================================================*
*& CLASS (DEFINITION)                                                 &*
*======================================================================*
CLASS lcl_auto_refresh DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_finished FOR EVENT finished OF cl_gui_timer.
ENDCLASS.

*======================================================================*
*& CLASS (IMPLEMENTATION)                                             &*
*======================================================================*
CLASS lcl_auto_refresh IMPLEMENTATION.
  METHOD on_finished.

    DATA vl_message TYPE string.

* Ejemplo de procesamiento periódico
    MESSAGE s006(1payminex) WITH sy-uzeit INTO vl_message.
    WRITE: / vl_message.

* Reinicia el temporizador para generar un ciclo continuo
    o_timer->run( ).

  ENDMETHOD.
ENDCLASS.

*======================================================================*
*& START-OF-SELECTION                                                 &*
*======================================================================*
START-OF-SELECTION.
* Crear objetos
  CREATE OBJECT o_timer.
  CREATE OBJECT o_auto_refresh.

* Registrar manejador del evento FINISHED
  SET HANDLER o_auto_refresh->on_finished FOR o_timer.

* Intervalo en segundos
  o_timer->interval = pa_seg.

* Iniciar temporizador
  o_timer->run( ).

*======================================================================*
*& END-OF-SELECTION                                                   &*
*======================================================================*
END-OF-SELECTION.
  WRITE: / 'Auto Refresh iniciado, Intervalo :', pa_seg.
