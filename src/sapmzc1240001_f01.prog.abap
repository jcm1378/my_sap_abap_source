*&---------------------------------------------------------------------*
*& Include          SAPMZC1240001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form f4_werks
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f4_werks .

*  select werks, name1, ekorg, land1
*    into TABLE @data(lt_werks)
*    FROM t001w.
*
*    IF sy-subrc ne 0.
*      message s001.
*      exit.
*    ENDIF.
*
**    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
**      EXPORTING
**       retfield               = 'WERKS'
**       DYNPPROG               = sy-repid
**       DYNPNR                 = sy-dynnr
**       DYNPROFIELD            = 'GS_DATA-WEARKS'
**       WINDOW_TITLE           =
**       VALUE_ORG              = 'C'
**      tables
**        value_tab              =
***       FIELD_TAB              =
***       RETURN_TAB             =
***       DYNPFLD_MAPPING        =
***     EXCEPTIONS
***       PARAMETER_ERROR        = 1
***       NO_VALUES_FOUND        = 2
***       OTHERS                 = 3
**              .
**    IF sy-subrc <> 0.
*** Implement suitable error handling here
**    ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

*  clear gs_data.
  refresh gt_data.

  select matnr werks mtart matkl menge meins
         dmbtr waers
    into CORRESPONDING FIELDS OF TABLE gt_data
    FROM zssa240001.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat  USING    pv_key
                        pv_field
                        pv_text
                        pv_ref_table
                        pv_ref_field
                        pv_qfield
                        pv_cfield.

  gt_fcat = VALUE #( BASE gt_fcat
                     ( key        = pv_field
                       fieldname  = pv_field
                       coltext    = pv_text
                       ref_table  = pv_ref_table
                       ref_field  = pv_ref_field
                       qfieldname = pv_qfield
                       cfieldname = pv_cfield
                       )
                      ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form diaplay_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM diaplay_alv .
  if gcl_container is not bound.

    CREATE OBJECT gcl_container
      EXPORTING

        container_name              = 'GCL_CONTAINER'.

    CREATE OBJECT gcl_grid
       EXPORTING
         i_parent          = gcl_container.

        CALL METHOD gcl_grid->set_table_for_first_display
          EXPORTING
            is_variant                    = gs_variant
            i_save                        = 'A'
            i_default                     = 'X'
            is_layout                     = gs_layout
          CHANGING
            it_outtab                     = gt_data
            it_fieldcatalog               = gt_fcat.

    else.
*       PERFORM refresh_grid.
    endif.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_data .

  DATA : ls_save type zssa240001.

  clear   ls_save.

  IF gs_data-matnr is INITIAL or
     gs_data-werks is initial.
    message s000 with text-e01 DISPLAY LIKE 'E'.
    EXIT.
   ENDIF.

  ls_save = CORRESPONDING #( gs_data ). "field가 똑같을 때 가능 mandt는 안들어갓다가 저장될때 시스템이 넣어줌

  modify zssa240001 from ls_save. "table에 올려줄 data가 1개라서 그냥 이렇게 넣어줌

  IF sy-dbcnt > 0. "이건 db에 update에 접근해서 변경된 사항이 있으면 count가 올라감
    commit work and wait.
    message s000 with text-001.

    else.
    ROLLBACK WORK.
    message s000 with text-002 DISPLAY LIKE 'W'.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_grid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_grid .
  DATA : ls_stable type lvc_s_stbl.

   ls_stable-row = 'X'.
   ls_stable-col = 'X'.

*function 을 넣어줘야함.

ENDFORM.
