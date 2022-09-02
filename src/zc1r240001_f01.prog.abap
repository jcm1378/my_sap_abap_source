*&---------------------------------------------------------------------*
*& Include          ZC1R240001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form init_param
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_param .

  pa_carr = 'KA'.

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

  clear   gs_data.
  refresh gt_data.

  select carrid connid fldate price currency planetype
    into CORRESPONDING FIELDS OF TABLE gt_data
    FROM sflight
    WHERE carrid = pa_carr
     and connid in so_conn.

    IF sy-subrc ne 0.
      MESSAGE s001.
      leave list-PROCESSING. "STOP
    ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layout .
  gs_layout-zebra       = 'X'.
  gs_layout-sel_mode    = 'D'. "A, B, C, D 있음
  gs_layout-cwidth_opt  = 'X'. "필드에 맞게 조정해 달라 칸을

  IF gt_fcat is INITIAL.
    PERFORM set_fcat USING :
          'X'  'CARRID'     ''  'SFLIGHT' 'CARRID',
          'X'  'CONNID'     ''  'SFLIGHT' 'CONNID',
          'X'  'FLDATE'     ''  'SFLIGHT' 'FLDATE',
          ''   'PRICE'      ''  'SFLIGHT' 'PRICE',
          ''   'CURRENCY'   ''  'SFLIGHT' 'CURRENCY',
          ''   'PLANETYPE'  ''  'SFLIGHT' 'PLANETYPE'.
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
FORM set_fcat  USING    p_key pv_field pv_text pv_table pv_ref_field.

  gs_fcat = VALUE #(
                    (
                    key     = pv_key
                    fieldname = pv_field
                    coltext   = pv_text
                    ref_table = pv_ref_table
                    ref_field = pv_ref_field
                    )
                   ).

*  gs_fcat-key       = pv_key.
*  gs_fcat-fieldname = pv_field.
*  gs_fcat-text      =

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

IF gcl_container is not bound. "객체가 생성이 된걸 bound라고함

  CREATE OBJECT gcl_container
    EXPORTING
      repid                       = sy-repid " 현재 Report Program 이름을 가지고 있는 시스템 변수
      dynnr                       = sy-dynnr " system variable witch hold corrent Screen number
*      side                        = cl_gui_docking_container=>DOCK_AT_LEFT
      side                        = gcl_container->doc_at_left
      extension                   = 3000.



CREATE OBJECT gcl_grid
  EXPORTING

    i_parent          = gcl_container.

  CALL METHOD gcl_grid->set_table_for_first_display
    EXPORTING

      is_variant                    = gs_variant
      i_save                        = 'A'
      i_default                     = 'X'
      is_layout                     = gs_layout.

    CHANGING
      it_outtab                     = gt_data
      it_fieldcatalog               = gt_fcat.


ENDIF.

ENDFORM.
