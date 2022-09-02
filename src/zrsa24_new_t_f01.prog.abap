*&---------------------------------------------------------------------*
*& Include          ZRSA24_NEW_T_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_fcat_layo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layo .

  gs_layo-zebra     = 'X'.
  gs_layo-sel_mode  = 'D'.
*  gs_layo-cwidth_opt = 'X'. "처음 데이터 있을때 opt줄떄

  IF gt_fcat IS INITIAL.
    PERFORM set_fcat USING :
          'X' 'PERNR'   ' '   'ZTSA2401' 'PERNR'  'X' 10,
          ' ' 'ENAME'   ' '   'ZTSA2401' 'ENAME'  'X' 20,
          ' ' 'ENTDT'   ' '   'ZTSA2401' 'ENTDT'  'X' 10,
          ' ' 'GENDER'  ' '   'ZTSA2401' 'GENDER' 'X' 5,
          ' ' 'DEPNR'   ' '   'ZTSA2401' 'DEPNR'  'X' 8.

  ENDIF.

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
*&---------------------------------------------------------------------*
FORM set_fcat  USING pv_key
                     pv_field
                     pv_text
                     pv_ref_table
                     pv_ref_field
                     pv_edit
                     pv_length.

  gs_fcat = VALUE #( key = pv_key
                     fieldname = pv_field
                     coltext = pv_text
                     ref_table = pv_ref_table
                     ref_field = pv_ref_field
                     edit      = pv_edit
                     outputlen = pv_length ).

  APPEND gs_fcat TO gt_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_object .
  IF gcl_container IS INITIAL.

    CREATE OBJECT gcl_container
      EXPORTING
        repid     = sy-repid
        dynnr     = sy-dynnr
        side      = gcl_container->dock_at_left
        extension = 3000.

    CREATE OBJECT gcl_alv
      EXPORTING
        i_parent = gcl_container.

    CALL METHOD gcl_alv->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layo
      CHANGING
        it_outtab       = gt_data
        it_fieldcatalog = gt_fcat
*       it_sort         =
      .

  ENDIF.




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

  SELECT pernr ename entdt gender depnr
    FROM ZTSA2401_C
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    WHERE pernr IN so_per.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_row
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_row .
  CLEAR gs_data.

  APPEND gs_data TO gt_data.

  PERFORM refresh_grid.

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

  gs_stable-row = 'X'.
  gs_stable-col = 'X'.

  CALL METHOD gcl_alv->refresh_table_display
    EXPORTING
      is_stable      = gs_stable
      i_soft_refresh = space.

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

  DATA : lt_save TYPE TABLE OF ZTSA2401_C,
         lt_del type TABLE OF ztsa2401_c,
         lv_error type c LENGTH 1.

  REFRESH lt_save.

  CALL METHOD gcl_alv->check_changed_data. "ALV의 입력된 값을 ITAB로 반영시킴

  CLEAR lv_error.
  LOOP AT gt_data INTO gs_data.

    IF gs_data-pernr IS INITIAL.
      MESSAGE s000 WITH TEXT-e01 DISPLAY LIKE 'E'.
      lv_error = 'X'. "에러발생 했을 경우 저장 플로우 수행방지 위해서 값을 세팅.
      EXIT.           "현재 수행중인 루틴을 빠져나감 : 지금은 Loop를 빠져나감.
    ENDIF.

    lt_save = VALUE #( BASE lt_save "에러 없는 데이터는 저장할 ITAB에 데이터 저장.
                      (
                        pernr   = gs_data-pernr
                        ename   = gs_data-ename
                        entdt   = gs_data-entdt
                        gender  = gs_data-gender
                        depnr   = gs_data-depnr
                       )
                      ).
  ENDLOOP.
* CHECK lv_error IS INITIAL   "에러가 없었으면 아래 로직 수행
  IF lv_error IS NOT INITIAL. "에러가 있었으면 현재 루틴 빠져나감
    EXIT.
  ENDIF.

  if gt_data_del is not INITIAL.
    LOOP AT gt_data_del into data(ls_del).
      lt_del = value #( base lt_del
                        ( pernr = ls_del-pernr )
                        ).
      delete ztsa2401_c FROM table lt_del.

      IF sy-dbcunt > 0.
         commit work and wait.
      ENDIF.

    ENDLOOP.


  IF lt_save IS NOT INITIAL.

    MODIFY ZTSA2401_C FROM TABLE lt_save.

    IF sy-dbcnt > 0.
      COMMIT WORK AND WAIT.
      MESSAGE s001. "Data 저장 성공 매사지
    ENDIF.

  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form delete_row
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM delete_row .

  refresh gt_rows.

  CALL METHOD gcl_alv->get_selected_rows
    IMPORTING
      et_index_rows = gt_rows.

      IF gt_rows is initial.
      MESSAGE s000 WITH TEXT-e02 DISPLAY LIKE 'E'.
      EXIT.
      ENDIF.

      sort gt_rows by index DESCENDING.

      loop at gt_rows into gs_row.

      read table gt_data into gs_data index gs_row-index.

      IF sy-subrc eq 0.

      ENDIF.
*      ITAB에서 삭제 하기전에 DB Table에서도 삭제 해야 하므로
*      삭제 대상을 따로 보관

        delete gt_data index gs_row-index.

     ENDLOOP.

     PERFORM refresh_grid.



ENDFORM.
