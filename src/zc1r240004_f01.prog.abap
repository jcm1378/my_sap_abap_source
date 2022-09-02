
*&---------------------------------------------------------------------*
*& Form init_get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_get_data .

  SELECT matnr maktx
    FROM makt
    INTO CORRESPONDING FIELDS OF TABLE gt_makt
    WHERE spras = sy-langu.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layo .

  gs_layo-zebra       = 'X'.
  gs_layo-sel_mode    = 'D'.
  gs_layo-cwidth_opt  = 'X'.

  IF gt_fcat IS INITIAL.

    PERFORM set_fcat USING :
          'X' 'MATNR' ' ' 'MAST' 'MATNR',
          ' ' 'MAKTX' ' ' 'MAKT' 'MAKTX',
          ' ' 'STLAN' ' ' 'MAST' 'STLAN',
          ' ' 'STLNR' ' ' 'MAST' 'STLNR',
          ' ' 'STLAL' ' ' 'MAST' 'STLAL',
          ' ' 'MTART' ' ' 'MARA' 'MTART',
          ' ' 'MATKL' ' ' 'MARA' 'MATKL'.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat USING pv_key pv_field pv_text pv_ref_table pv_ref_field.

  gs_fcat = VALUE #( key       = pv_key
                     fieldname = pv_field
                     coltext   = pv_text
                     ref_table = pv_ref_table
                     ref_field = pv_ref_field ).

  CASE pv_field.
    WHEN 'STLNR'.
      gs_fcat-hotspot = 'X'.
  ENDCASE.

  APPEND gs_fcat TO gt_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_db_click
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_COLUMN_FIELDNAME
*&---------------------------------------------------------------------*
FORM set_db_click  USING VALUE(p_fieldname)
                         VALUE(p_row_id).
  CASE p_fieldname.
    WHEN 'MATNR'.
      CLEAR gs_mat.
      READ TABLE gt_mat INTO gs_mat INDEX p_row_id.

      SET PARAMETER ID 'MAT' FIELD gs_mat-matnr.

      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
      CLEAR gs_mat.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_hotspot
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_COLUMN_ID_FIELDNAME
*&      --> ES_ROW_NO_ROW_ID
*&---------------------------------------------------------------------*
FORM set_hotspot  USING VALUE(p_fieldname)
                        VALUE(p_row_id).

  CASE p_fieldname.
    WHEN 'STLNR'.
      CLEAR gs_mat.
      READ TABLE gt_mat INTO gs_mat INDEX p_row_id.

      SET PARAMETER ID 'MAT' FIELD gs_mat-matnr.
      SET PARAMETER ID 'WRK' FIELD gs_mat-werks.
      SET PARAMETER ID 'CSV' FIELD gs_mat-stlan.

      CALL TRANSACTION 'CS03'.
      CLEAR gs_mat.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_screen .

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

    IF gcl_handler IS NOT BOUND. " 로컬 클래스에 대한 인스턴스는 꼭 CREATE OBJECT 의 시점을 모르기 때문에 하나만 선언될 수 있도록 방책을 세워두는 것이 좋다.
      CREATE OBJECT gcl_handler.
    ENDIF.

    SET HANDLER: gcl_handler->handle_double_click FOR gcl_alv,
                 gcl_handler->handle_hotspot      FOR gcl_alv.
*    SET HANDLER lcl_handler=>on_hotspot      FOR gcl_alv.

    gs_variant-report = sy-repid.

    CALL METHOD gcl_alv->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layo
      CHANGING
        it_outtab       = gt_mat
        it_fieldcatalog = gt_fcat.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_bom_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_bom_data .

  CLEAR   gs_mat.
  _clear  gt_mat.

  DATA lv_tabix LIKE sy-tabix.

  SELECT a~matnr a~stlan a~stlnr a~stlal
         a~werks b~mtart b~matkl
  FROM   mast AS a INNER JOIN mara AS b
    ON   a~matnr = b~matnr
  INTO CORRESPONDING FIELDS OF TABLE gt_mat
  WHERE  a~werks  = pa_werks
    AND  a~matnr IN so_matnr.

  IF sy-subrc <> 0.
    MESSAGE s001.
    LEAVE LIST-PROCESSING.
  ENDIF.

*------------ JOIN 3회 ------------------------
*  SELECT a~matnr a~stlan a~stlnr a~stlal
*        b~mtart b~matkl
*        c~maktx
*    INTO CORRESPONDING FIELDS OF TABLE gt_mat
*    FROM       mast AS a
*    INNER JOIN mara AS b
*    ON a~matnr = b~matnr
*    LEFT OUTER JOIN makt AS c
*    ON a~matnr  = c~matnr
*    AND c~spras = sy-langu
*    WHERE a~werks  = pa_werks
*    and   a~matnr in so_matnr.


IF gcl_ZCLC124_0002 is not BOUND.

*create object ZCLC124_0002.

CREATE OBJECT gcl_zclc124_0002.


ENDIF.

data : lv_maktx type makt-maktx,
       lv_scode type c LENGTH 1.

  LOOP AT gt_mat INTO gs_mat.
    lv_tabix = sy-tabix.

*    READ TABLE gt_makt INTO gs_makt WITH KEY matnr = gs_mat-matnr.

CALL METHOD gcl_zclc124_0002->get_mat
  EXPORTING
    pi_matnr = gs_mat-matnr
  IMPORTING
    pe_maktx = lv_maktx
    pe_code  = lv_scode.

    IF lv_scode = 'S'.
      gs_mat-maktx = lv_maktx.
      MODIFY gt_mat FROM gs_mat INDEX lv_tabix TRANSPORTING maktx.
    ENDIF.

    CLEAR  gs_makt.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_double_click
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW
*&      --> E_COLUMN
*&---------------------------------------------------------------------*
FORM handle_double_click  USING ps_row    TYPE lvc_s_row
                                ps_column TYPE lvc_s_col.

  READ TABLE gt_mat INTO gs_mat INDEX ps_row-index.

  IF sy-subrc NE 0.
    EXIT.
  ENDIF.

  CASE ps_column-fieldname.
    WHEN 'MATNR'.
      IF gs_mat-matnr IS INITIAL.
        EXIT.
      ENDIF.

      SET PARAMETER ID : 'MAT' FIELD gs_mat-matnr.

      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_hotspot
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW_ID
*&      --> E_COLUMN_ID
*&---------------------------------------------------------------------*
FORM handle_hotspot  USING ps_row_id    TYPE lvc_s_row
                           ps_column_id TYPE lvc_s_col.

  READ TABLE gt_mat INTO gs_mat INDEX ps_row_id-index.

  IF sy-subrc <> 0.
    EXIT.
  ENDIF.

  CASE ps_column_id-fieldname.
    WHEN 'STLNR'.
      IF gs_mat-stlnr IS INITIAL.
        EXIT.
      ENDIF.

      SET PARAMETER ID : 'MAT' FIELD gs_mat-matnr,
                         'WRK' FIELD pa_werks,
                         'CSV' FIELD gs_mat-stlan.

      CALL TRANSACTION 'CS03' AND SKIP FIRST SCREEN.
  ENDCASE.
ENDFORM.
