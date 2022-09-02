*&---------------------------------------------------------------------*
*& Report ZBC405_OM_A24
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_om_a24.

TABLES : spfli.

SELECT-OPTIONS : so_car FOR spfli-carrid MEMORY ID car,
                 so_con FOR spfli-connid MEMORY ID con.

DATA : gt_spfli TYPE TABLE OF spfli,
       gs_spfli TYPE spfli.

DATA  : go_alv_table TYPE REF TO cl_salv_table.
DATA :  go_alv_error TYPE REF TO cx_salv_msg.

DATA : go_salv TYPE REF TO cl_salv_table, " class salv table.
       go_func type ref to cl_salv_functions_list,
       go_disp type ref to CL_SALV_DISPLAY_SETTINGS,
       go_columns type ref to cl_salv_columns_table,
       go_column type ref to cl_salv_column_table,
       go_cols type ref to cl_salv_column,
       go_layout  TYPE REF TO cl_salv_layout,
       go_selc type REF TO cl_salv_selections.



"Get Data
START-OF-SELECTION.

  SELECT *
    FROM spfli
    INTO TABLE gt_spfli
    WHERE carrid in so_car
    AND connid in so_con.



    TRY.  "Class를 사용할때는 의도하지 않은 dump를 방지 ex)이름이 없거나, 타입이 맞지 않는다거나 할때, 주석풀어서 사용하는게 좋다.
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        list_display   = ' ' "IF_SALV_C_BOOL_SAP=>FALSE "화면의 모양 X는 List 모양, ' '처음 default모양
*        r_container    =
*        container_name =
      IMPORTING
        r_salv_table   = go_salv
      CHANGING
        t_table        = gt_spfli.
      CATCH cx_salv_msg.
    ENDTRY.



*-------------funtion
" Get Funtions list -> Fountion의 정보(현재 alv의 funtions 상태) -> Funtions type -> cl_salv_functions_list.
CALL METHOD go_salv->get_functions
     RECEIVING
       value  = go_func.


" Button Set

*CALL METHOD go_func->set_filter.
*
*CALL METHOD go_func->set_sort_asc.
*
*CALL METHOD go_func->set_sort_desc.

CALL METHOD go_func->set_all.



*--------- display

CALL METHOD go_salv->get_display_settings
  RECEIVING
    value  = go_disp
    .

CALL METHOD go_disp->set_list_header
  EXPORTING
    value  = 'SALV DEMO'
    .

CALL METHOD go_disp->set_striped_pattern
  EXPORTING
    value  =  'X'
    .


*-------------
**TRY.
*CALL METHOD xxxxxxxx->get_column
*  EXPORTING
*    columnname =
*  receiving
*    value      =
*    .
**  CATCH cx_salv_not_found.
**ENDTRY.

*CALL METHOD xxxxxxxx->get_columns
*  RECEIVING
*    value  =
*    .

*TRY.
*CALL METHOD xxxxxxxx->get_column
*  EXPORTING
*    columnname =
*  receiving
*    value      =
*    .
*  CATCH cx_salv_not_found.
*ENDTRY.





CALL METHOD go_salv->get_columns
  RECEIVING
    value  = go_columns.

CALL METHOD go_columns->set_optimize
*  EXPORTING
*    value  = IF_SALV_C_BOOL_SAP~TRUE
    .

TRY.
CALL METHOD go_columns->get_column
  EXPORTING
    columnname = 'MANDT'
  receiving
    value      = go_cols
    .
  CATCH cx_salv_not_found.
ENDTRY.


DATA : g_color type lvc_s_colo.

*TRY.
*CALL METHOD go_columns->get_column
*  EXPORTING
*    columnname = 'FLTIME'
*  receiving
*    value      = go_cols
*    .
*  CATCH cx_salv_not_found.
*ENDTRY.


go_column ?= go_cols.

g_color-col = '5'.
g_color-int = '1'.
g_color-inv = '0'.

CALL METHOD go_column->set_color
  EXPORTING
    value  = g_color
    .

  CALL METHOD go_salv->get_layout
    RECEIVING
      value = go_layout.

  DATA : g_program TYPE salv_s_layout_key.

  g_program-report = sy-cprog.

  CALL METHOD go_layout->set_key
    EXPORTING
      value = g_program.

*
* i_save = 'A'.
  CALL METHOD go_layout->set_save_restriction
    EXPORTING
      value = if_salv_c_layout=>restrict_none.

  CALL METHOD go_layout->set_default
    EXPORTING
      value = 'X'.

* --- Selection Mode
CALL METHOD go_salv->get_selections
 RECEIVING
 value = go_selc
.

CALL METHOD go_selc->set_selection_mode
  EXPORTING
    value  = IF_SALV_C_SELECTION_MODE=>row_column.
    .
    CALL METHOD go_selc->set_selection_mode
    EXPORTING
      value  = IF_SALV_C_SELECTION_MODE=>cell
      .



*go_column ?= go_cols. " Casting type이 달라도 구문오류 없이 인정해달라.
*
*CALL METHOD go_column->set_technical
**  EXPORTING
**    value  = go_cols "IF_SALV_C_BOOL_SAP=>TRUE
*    .

    CALL METHOD go_cols->set_technical
*   EXPORTING
*   value  = IF_SALV_C_BOOL_SAP=>TRUE
    .

" Display는 항상 맨 밑에 있어야 함.
CALL METHOD go_salv->display.
