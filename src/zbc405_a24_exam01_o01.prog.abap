*&---------------------------------------------------------------------*
*& Include          ZBC405_A24_EXAM01_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  IF pa_edit = 'X'.
    SET PF-STATUS 'S100'.
  else.
    SET PF-STATUS 'S100' EXCLUDING 'SAVE'.
  ENDIF.

 SET TITLEBAR 'T100' WITH sy-uname sy-datum.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_object OUTPUT.
    " Create container object
CREATE OBJECT go_container
  EXPORTING
    container_name              = 'CONTROL_AREA'.

    " create grid object ( when sucessfully Create Container )
IF sy-subrc EQ 0.
    CREATE OBJECT go_alv
      EXPORTING
        i_parent          = go_container.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_ALV_DISPLAY OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE alv_trensfer OUTPUT.
*     perform make_field_catalog.

       CLEAR : gs_fcat.
       gs_fcat-fieldname = 'LIGHT'.
       gs_fcat-coltext = 'Exc'.
       gs_fcat-coltext = 'Info'.
       APPEND gs_fcat TO gt_fcat.

       CLEAR : gs_fcat.
       gs_fcat-fieldname = 'ID'.
       gs_fcat-coltext = 'I&D'.
       gs_fcat-col_pos = 5.
       APPEND gs_fcat TO gt_fcat.

       CLEAR : gs_fcat.
       gs_fcat-fieldname = 'FLIGHT'.
       gs_fcat-coltext = 'Flight'.
       gs_fcat-col_pos = 6.
       APPEND gs_fcat TO gt_fcat.

       clear : gs_fcat.
       gs_fcat-fieldname = 'FROM_TZ'.
       gs_fcat-coltext = 'From TZ'.
       gs_fcat-col_pos = 30.
       gs_fcat-ref_table = 'SAIRPORT'.
       gs_fcat-ref_field = 'TIME_ZONE'.

       APPEND gs_fcat TO gt_fcat.

       clear : gs_fcat.
       gs_fcat-fieldname ='TO_TZ'.
       gs_fcat-coltext = 'To_TZ'.
       gs_fcat-col_pos = 31.
       gs_fcat-ref_table = 'SAIRPORT'.
       gs_fcat-ref_field = 'TIME_ZONE'.
       APPEND gs_fcat TO gt_fcat.

       clear : gs_fcat.
       gs_fcat-fieldname = 'FLTYPE'.
       gs_fcat-no_out = 'X'.
       APPEND gs_fcat to gt_fcat.

       clear : gs_fcat.
       gs_fcat-fieldname = 'ARRTIME'.
       gs_fcat-EMPHASIZE = 'C710'.
       APPEND gs_fcat to gt_fcat.
*       EDIT
       clear : gs_fcat.
       gs_fcat-fieldname = 'PERIOD'.
       gs_fcat-EMPHASIZE = 'C710'.
       APPEND gs_fcat to gt_fcat.

       clear : gs_fcat.
       gs_fcat-fieldname = 'FLTIME'.
       gs_fcat-edit = pa_edit.
       APPEND gs_fcat to gt_fcat.

       clear : gs_fcat.
       gs_fcat-fieldname = 'DEPTIME'.
       gs_fcat-edit = pa_edit.
       APPEND gs_fcat to gt_fcat.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module ALV_TRENSFER OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_alv_display OUTPUT.

    set HANDLER lcl_handler=>on_toolbar for go_alv.
    CALL METHOD go_alv->set_table_for_first_display
    EXPORTING
*      i_buffer_active               =
*      i_bypassing_buffer            =
*      i_consistency_check           =
      i_structure_name              = 'ZTSPFLI_A24'
      is_variant                    = gs_variant
      i_save                        = 'A'
      i_default                     = 'X'
      is_layout                     = gs_layout
*      is_print                      =
*      it_special_groups             =
*      it_toolbar_excluding          =
*      it_hyperlink                  =
*      it_alv_graphics               =
*      it_except_qinfo               =
*      ir_salv_adapter               =
    CHANGING
      it_outtab                     = gt_spfli
      it_fieldcatalog               = gt_fcat
*      it_sort                       =
*      it_filter                     =
*    EXCEPTIONS
*      invalid_parameter_combination = 1
*      program_error                 = 2
*      too_many_lines                = 3
*      others                        = 4
          .
  IF sy-subrc <> 0.
*   Implement suitable error handling here
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module ALV_LAYOUT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE alv_layout OUTPUT.
      gs_layout-sel_mode = 'D'.   "A, B, C, D
     gs_layout-excp_fname = 'LIGHT'.    "exception handling
     gs_layout-excp_led   = 'X'.        "icon 모양 변경
     gs_layout-zebra      = 'X'.
     gs_layout-cwidth_opt  = 'X'.
     gs_layout-ctab_fname = 'IT_COLOR'.
ENDMODULE.
