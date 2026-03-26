*&---------------------------------------------------------------------*
*& Report      ZEDP_CONTROL_EXECUTION_MODE
*&---------------------------------------------------------------------*
* TITULO      : CHANGE EJECUTION MODE                                  *
* AUTOR       : Escobar Daniel Pascal                                  *
* DESCRIPCION : Template reutilizable para control sobre el modo de    *
* ejecucion de un reporte.                                             *
*----------------------------------------------------------------------*
* LOG DE MODIFICACIONES                                                *
*----------------------------------------------------------------------*
* MOD. NO.  | FECHA   | USUARIO                                        *
*----------------------------------------------------------------------*
*           |         |                                                *
*----------------------------------------------------------------------*
REPORT ZEDP_CONTROL_EXECUTION_MODE.
*======================================================================*
*& INCLUDE                                                            &*
*======================================================================*
INCLUDE rsdbc1xx.      "Control de screen

PARAMETER pa_test TYPE text50.

*======================================================================*
*& CLASS (DEFINITION DEFERRED)                                       &*
*======================================================================*
CLASS lcl_screen  DEFINITION DEFERRED.

*======================================================================*
*& DATA                                                               &*
*======================================================================*
*& C L A S E
DATA: o_screen  TYPE REF TO lcl_screen.

*======================================================================*
*& CLASS lcl_screen_constants                                        &*
*======================================================================*
CLASS lcl_screen_constants DEFINITION.
  PUBLIC SECTION.
    CONSTANTS:
      cm_excl_sjob TYPE rsexfcode_ VALUE 'SJOB',   "Código de función para excluir JOB
      cm_excl_onli TYPE rsexfcode_ VALUE 'ONLI'.   "Código de función para excluir Online
ENDCLASS.

*======================================================================*
*& CLASS lcl_screen                                                  &*
*======================================================================*
CLASS lcl_screen DEFINITION.
  PUBLIC SECTION.
    DATA:
      vm_online TYPE abap_bool,   "Indicador: Modo Online activo
      vm_job    TYPE abap_bool.   "Indicador: Modo Background Job activo

    METHODS:
      "Constructor de la clase
      constructor,

      "Establece el modo de ejecución deseado
      set_execution_mode IMPORTING im_v_online TYPE abap_bool   "Modo Online deseado
                               im_v_job    TYPE abap_bool,  "Modo Job deseado

      "Método principal llamado desde AT SELECTION-SCREEN OUTPUT
      check CHANGING ch_current_screen TYPE sydb0_scr_stack_line,

      "Verifica y excluye modos de ejecución no deseados
      check_execution_mode CHANGING ch_current_screen TYPE sydb0_scr_stack_line.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

*======================================================================*
*& LOAD-OF-PROGRAM                                                    &*
*======================================================================*
LOAD-OF-PROGRAM.
  CREATE OBJECT o_screen.

  "Configuración inicial del modo de ejecución (Online = TRUE, Job = FALSE)
  o_screen->set_execution_mode( EXPORTING im_v_online = abap_true
                                      im_v_job    = abap_false ).

*======================================================================*
*& AT SELECTION-SCREEN...                                             &*
*======================================================================*
AT SELECTION-SCREEN OUTPUT.
  "Llamada al método que controla la pantalla según modo de ejecución
  o_screen->check( CHANGING  ch_current_screen = current_scr ).

*======================================================================*
*& START-OF-SELECTION                                                 &*
*======================================================================*
START-OF-SELECTION.
 "Busqueda de datos

*======================================================================*
*& END-OF-SELECTION                                                   &*
*======================================================================*
END-OF-SELECTION.
* Procesamiento y muestreo de datos
  WRITE pa_test.

*======================================================================*
*& CLASS lcl_screen IMPLEMENTATION                                    &*
*======================================================================*
CLASS lcl_screen IMPLEMENTATION.
  METHOD constructor.  "<------------------------------------------------
    "Inicialización de la clase - Actualmente vacío (puede usarse para setup futuro)
  ENDMETHOD. "<---------------------------------------------------------

  METHOD set_execution_mode.  "<-----------------------------------------
    "Asigna los indicadores de modo de ejecución a los atributos de clase
    vm_online = im_v_online.
    vm_job    = im_v_job.
  ENDMETHOD. "<---------------------------------------------------------

  METHOD check.  "<------------------------------------------------------
    "Método público que delega la verificación del modo de ejecución

    "Llamada al método privado que realiza la lógica de exclusión
    me->check_execution_mode( CHANGING ch_current_screen = ch_current_screen ).
  ENDMETHOD. "<---------------------------------------------------------

*----------------------------------------------------------------------*
  METHOD check_execution_mode.  "<--------------------------------------
    "Verifica los atributos de modo y excluye las opciones no deseadas en la pantalla

    "--------------------------------------------------------------------
    "Si el modo Online NO está permitido → Excluir opción Online
    "--------------------------------------------------------------------
    IF vm_online EQ abap_false.
      READ TABLE ch_current_screen-excl TRANSPORTING NO FIELDS
        WITH KEY fcode = lcl_screen_constants=>cm_excl_onli.

      IF sy-subrc IS NOT INITIAL.
        APPEND lcl_screen_constants=>cm_excl_onli TO ch_current_screen-excl. "Excluir Online
      ENDIF.
    ENDIF.

    "--------------------------------------------------------------------
    "Si el modo Job NO está permitido → Excluir opción JOB
    "--------------------------------------------------------------------
    IF vm_job EQ abap_false.
      READ TABLE ch_current_screen-excl TRANSPORTING NO FIELDS
        WITH KEY fcode = lcl_screen_constants=>cm_excl_sjob.

      IF sy-subrc IS NOT INITIAL.
        APPEND lcl_screen_constants=>cm_excl_sjob TO ch_current_screen-excl. "Excluir JOB
      ENDIF.
    ENDIF.

    SORT ch_current_screen-excl.
    DELETE ADJACENT DUPLICATES FROM ch_current_screen-excl .
  ENDMETHOD. "<---------------------------------------------------------
ENDCLASS.
