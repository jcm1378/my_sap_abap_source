*&---------------------------------------------------------------------*
*& Report ZBC405_ALV_CL1_T03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_alvad_a24_t.


TABLES : ztsbook_a24.
*---------------------
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS : so_car FOR ztsbook_a24-carrid OBLIGATORY
                              MEMORY ID car,
                   so_con FOR ztsbook_a24-connid
                              MEMORY ID con,
                   so_fld FOR ztsbook_a24-fldate,
                   so_cus FOR ztsbook_a24-customid.


  SELECTION-SCREEN SKIP.

  PARAMETERS : p_edit AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN SKIP.

PARAMETERS : p_layout TYPE disvariant-variant.

  DATA : gt_custom TYPE TABLE OF ztscustom_t03,
         gs_custom TYPE          ztscustom_t03.

*-------------------------------
TYPES : BEGIN OF gty_sbook.
          INCLUDE TYPE ztsbook_a24.
TYPES :   light TYPE c LENGTH 1.
TYPES :   telephone TYPE ztscustom_a24-telephone.
TYPES :   email     TYPE ztscustom_a24-email.
TYPES :   row_color TYPE c LENGTH 4.
TYPES :   it_color  TYPE lvc_t_scol.
types : bt type lvc_t_styl.
types : modifie type c LENGTH 1.
TYPES : END OF gty_sbook.


DATA : gt_sbook TYPE TABLE OF gty_sbook,
       gs_sbook TYPE          Gty_sbook,
       dl_sbook type TABLE of gty_sbook.

DATA : ok_code TYPE sy-ucomm.

*-- FOR ALV 변수
DATA : go_container TYPE REF TO cl_gui_custom_container,
       go_alv       TYPE REF TO cl_gui_alv_grid.

DATA : gs_variant TYPE disvariant,
       gs_layout  TYPE lvc_s_layo,
       gt_sort    TYPE lvc_t_sort,
       gs_sort    TYPE lvc_s_sort,
       gs_color   TYPE lvc_s_scol,
       gt_exct    TYPE ui_functions,
       gt_fcat    TYPE lvc_t_fcat,
       gs_fcat    TYPE lvc_s_fcat.


INCLUDE zbc405_alvad_a24_t_class.
*INCLUDE ZBC405_ALV_CL1_T03_class.


*------------------------------------------------------
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_layout.

  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'F'       "S :save, L :load  F: F4
    CHANGING
      cs_variant  = gs_variant.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    p_layout  =  gs_variant-variant.
  ENDIF.



INITIALIZATION.
  gs_variant-report = sy-cprog.

START-OF-SELECTION.

  PERFORM get_data.

  CALL SCREEN 100.

*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .


  DATA : gt_temp TYPE TABLE OF gty_sbook.

  SELECT *  INTO CORRESPONDING FIELDS OF
            TABLE gt_sbook FROM ztsbook_a24
        WHERE carrid IN so_car AND
              connid IN so_con AND
              fldate IN so_fld AND
              customid IN so_cus.

  IF sy-subrc EQ 0.

    gt_temp = gt_sbook.
    DELETE gt_temp WHERE customid = space.

    SORT gt_temp BY customid.
    DELETE ADJACENT DUPLICATES FROM gt_temp COMPARING customid.

    SELECT  * INTO TABLE gt_custom
          FROM ztscustom_a24
           FOR ALL ENTRIES IN gt_temp
          WHERE id = gt_temp-customid.
  ENDIF.

  LOOP AT gt_sbook INTO gs_sbook.
    READ TABLE gt_custom INTO gs_custom
             WITH KEY id = gs_sbook-customid.
    IF sy-subrc EQ 0.
      gs_sbook-telephone = gs_custom-telephone.
      gs_sbook-email     = gs_custom-email.
    ENDIF.


*--/ exception handling
    IF gs_sbook-luggweight > 25.
      gs_sbook-light = 1.    "red
    ELSEIF gs_sbook-luggweight > 15.
      gs_sbook-light = 2.   "yellow
    ELSE.
      gs_sbook-light = 3.  "green.
    ENDIF.
*--/

    IF gs_sbook-class = 'F'.    "first clase
      gs_sbook-row_color = 'C710'.
    ENDIF.

    IF gs_sbook-smoker = 'X'.
      gs_color-fname = 'SMOKER'.
      gs_color-color-col = col_negative.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_sbook-it_color.
    ENDIF.


    MODIFY gt_sbook FROM gs_sbook.

  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'T100'.
  SET TITLEBAR 'T10' WITH sy-datum sy-uname.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  LEAVE TO SCREEN 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_object OUTPUT.

  IF go_container IS INITIAL.
    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'.


    IF sy-subrc EQ 0.
      CREATE OBJECT go_alv
        EXPORTING
          i_parent = go_container.

      IF sy-subrc EQ 0.
*- .
        PERFORM set_variant.
        PERFORM set_layout.
        PERFORM set_sort_table.
        PERFORM make_fieldcatalog.

*---

        CALL METHOD go_alv->register_edit_event
          EXPORTING
            i_event_id = cl_gui_alv_grid=>mc_evt_modified.    "변경되는순간반영
*---                                "mc_evt_enter   "enter 치는순간

        APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_info   TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO gt_exct.  "appendrow
        APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row TO gt_exct.


        SET HANDLER lcl_handler=>on_doubleclick FOR go_alv.
        SET HANDLER lcl_handler=>on_toolbar     FOR go_alv.
        SET HANDLER lcl_handler=>on_usercommand FOR go_alv.
        SET HANDLER lcl_handler=>on_data_changed FOR go_alv.




        CALL METHOD go_alv->set_table_for_first_display
          EXPORTING
*           i_buffer_active      =
*           i_bypassing_buffer   =
*           i_consistency_check  =
            i_structure_name     = 'ZTSBOOK_A24'
            is_variant           = gs_variant
            i_save               = 'A'              "i_save : ' '  A X U
            i_default            = 'X'
            is_layout            = gs_layout
*           is_print             =
*           it_special_groups    =
            it_toolbar_excluding = gt_exct
*           it_hyperlink         =
*           it_alv_graphics      =
*           it_except_qinfo      =
*           ir_salv_adapter      =
          CHANGING
            it_outtab            = gt_sbook
            it_fieldcatalog      = gt_fcat
            it_sort              = gt_sort
*           it_filter            =
*           EXCEPTIONS
*           invalid_parameter_combination = 1
*           program_error        = 2
*           too_many_lines       = 3
*           others               = 4
          .
        IF sy-subrc <> 0.
*          Implement suitable error handling here
        ENDIF.

      ENDIF.
    ENDIF.
  ELSE.

*-- refresh alv methodd 올자리

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form set_variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_variant .
  gs_variant-variant = p_layout .


ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .


  gs_layout-sel_mode = 'D'.   "A, B, C, D
  gs_layout-excp_fname = 'LIGHT'.    "exception handling
  gs_layout-excp_led   = 'X'.        "icon 모양 변경
  gs_layout-zebra      = 'X'.
  gs_layout-cwidth_opt  = 'X'.

  gs_layout-info_fname = 'ROW_COLOR'.      "row color 필드 설정
  gs_layout-ctab_fname = 'IT_COLOR'.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_sort_table
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_sort_table .

  CLEAR : gs_sort.
  gs_sort-fieldname = 'CARRID'.
  gs_sort-up       = 'X'.
  gs_sort-spos     = '1'.
  APPEND gs_sort TO gt_sort.

  CLEAR : gs_sort.
  gs_sort-fieldname = 'CONNID'.
  gs_sort-up       = 'X'.
  gs_sort-spos     = '2'.
  APPEND gs_sort TO gt_sort.

  CLEAR : gs_sort.
  gs_sort-fieldname = 'FLDATE'.
  gs_sort-down       = 'X'.
  gs_sort-spos     = '3'.
  APPEND gs_sort TO gt_sort.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_fieldcatalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_fieldcatalog .

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'LIGHT'.
  gs_fcat-coltext = 'Info'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'SMOKER'.
  gs_fcat-checkbox = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'INVOICE'.
  gs_fcat-checkbox = 'X'.
  APPEND gs_fcat TO gt_fcat.

  "Edit
  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'CANCELLED'.
  gs_fcat-checkbox = 'X'.
  gs_fcat-edit     = p_edit.    " 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'TELEPHONE'.
  gs_fcat-ref_table = 'ZTSCUSTOM_A24'.
  gs_fcat-ref_field = 'TELEPHONE'.
  gs_fcat-col_pos   = '30'.
  APPEND gs_fcat TO gt_fcat.


  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'EMAIL'.
  gs_fcat-ref_table = 'ZTSCUSTOM_A24'.
  gs_fcat-ref_field = 'EMAIL'.
  gs_fcat-col_pos = '31'.
  APPEND gs_fcat TO gt_fcat.

" Edit
  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'CUSTOMID'.
*  gs_fcat-emphasize = 'C400'.
  gs_fcat-edit      = p_edit.     "'X'.
  APPEND gs_fcat TO gt_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form customer_change_part
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> LS_MOD_CELLS
*&---------------------------------------------------------------------*

"cell에 내용을 바꿈
FORM customer_change_part  USING per_data_changed
                               TYPE REF TO cl_alv_changed_data_protocol
                                 ps_mod_cells TYPE lvc_s_modi.

"EDIT MODE의 DATA CHANGE

  DATA : l_customid TYPE ztsbook_a24-customid.
   DATA : l_phone    TYPE ztscustom_a24-telephone.
  data : l_email type ztscustom_a24-email.
  data : l_name type ztscustom_a24-name.

  CALL METHOD per_data_changed->get_cell_value
    EXPORTING
      i_row_id    =  ps_mod_cells-row_id
*      i_tabix     =
      i_fieldname = 'CUSTOMID'
    IMPORTING
      e_value     = l_customid
      .

  IF l_customid is not INITIAL.

    read table gt_custom into gs_custom
    with key ID = l_customid.

         if sy-subrc eq 0.
           l_phone = gs_custom-telephone.
           l_email = gs_custom-email.
           l_name = gs_custom-name.

         else.
           select single telephone email name into
             (l_phone, l_email, l_name)
             from ztscustom_a24
             where id = l_customID.
         ENDIF.

    else.
      clear : l_email, l_phone, l_name.
    ENDIF.

    " 화면에 있는 내용을 바꿈.
   CALL METHOD per_data_changed->modify_cell
      EXPORTING
        i_row_id    = ps_mod_cells-row_id
        i_fieldname = 'TELEPHONE'
        i_value     = l_phone.

    CALL METHOD per_data_changed->modify_cell
      EXPORTING
        i_row_id    = ps_mod_cells-row_id
        i_fieldname = 'EMAIL'
        i_value     = l_email.

     CALL METHOD per_data_changed->modify_cell
      EXPORTING
        i_row_id    = ps_mod_cells-row_id
        i_fieldname = 'PASSNAME'
        i_value     = l_name.


   gs_sbook-email = l_email.
  gs_sbook-telephone = l_phone.
  gs_sbook-passname = l_name.
MODIFY gt_sbook FROM gs_sbook INDEX ps_mod_cells-row_id.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form insert_parts
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> LS_INS_CELLS
*&---------------------------------------------------------------------*
FORM insert_parts  USING   rr_data_changed TYPE REF TO
                             cl_alv_changed_data_protocol
                            Rs_ins_cells TYPE lvc_s_moce.

    gs_sbook-carrid = so_car-low.
  gs_sbook-connid = so_con-low.
  gs_sbook-fldate = so_fld-low.


  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'CARRID'
      i_value     = gs_sbook-carrid.

  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'CONNID'
      i_value     = gs_sbook-connid.

  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'FLDATE'
      i_value     = gs_sbook-fldate.

  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'ORDER_DATE'
      i_value     = sy-datum.

  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'CUSTTYPE'
      i_value     = 'P'.

  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'CLASS'
      i_value     = 'C'.

  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'CONNID'.
  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'FLDATE'.
  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'CUSTTYPE'.
  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'CLASS'.
  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'DISCOUNT'.
  PERFORM modify_style USING rr_data_changed
                            Rs_ins_cells
                            'SMOKER'.
  PERFORM modify_style USING rr_data_changed
                           Rs_ins_cells
                           'LUGGWEIGHT'.
  PERFORM modify_style USING rr_data_changed
                           Rs_ins_cells
                           'WUNIT'.
  PERFORM modify_style USING rr_data_changed
                          Rs_ins_cells
                          'INVOICE'.
  PERFORM modify_style USING rr_data_changed
                          Rs_ins_cells
                          'FORCURAM'.
  PERFORM modify_style USING rr_data_changed
                         Rs_ins_cells
                         'FORCURKEY'.
  PERFORM modify_style USING rr_data_changed
                       Rs_ins_cells
                       'LOCCURAM'.
  PERFORM modify_style USING rr_data_changed
                        Rs_ins_cells
                        'LOCCURKEY'.
  PERFORM modify_style USING rr_data_changed
                        Rs_ins_cells
                        'ORDER_DATE'.
  PERFORM modify_style USING rr_data_changed
                        Rs_ins_cells
                        'AGENCYNUM'.




  MODIFY gt_sbook FROM gs_sbook INDEX Rs_ins_cells-row_id .


ENDFORM.
*&---------------------------------------------------------------------*
*& Form modify_style
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> RR_DATA_CHANGED
*&      --> RS_INS_CELLS
*&      --> P_
*&---------------------------------------------------------------------*
FORM modify_style  USING   rr_data_changed  TYPE REF TO
                             cl_alv_changed_data_protocol
                            Rs_ins_cells TYPE lvc_s_moce
                            VALUE(p_val).

  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = p_val
      i_style     = cl_gui_alv_grid=>mc_style_enabled.

ENDFORM.
