*&---------------------------------------------------------------------*
*& Report ZBC405_A24_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZBC405_A24_ALV_TOP                      .    " Global Data

Start-OF-SELECTION.

  select *
    FROM sflight
    into table gt_sflt
    WHERE carrid in so_car
    and   connid in so_con
    and   fldate in so_dat.

    call SCREEN 100.

 AT SELECTION-SCREEN on VALUE-REQUEST FOR pa_lv.

   gs_variant-report = sy-cprog.

   CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING

      I_SAVE_LOAD                 = 'F' "S, F, L

     CHANGING
       cs_variant                  = gs_variant


    EXCEPTIONS
      NOT_FOUND                   = 1
      WRONG_INPUT                 = 2
      FC_NOT_COMPLETE             = 3
      OTHERS                      = 4
             .
   IF sy-subrc <> 0.
* Implement suitable error handling here
     else.
       pa_lv = gs_variant-variant.
   ENDIF.

* INCLUDE ZBC405_A24_ALV_O01                      .  " PBO-Modules
* INCLUDE ZBC405_A24_ALV_I01                      .  " PAI-Modules
* INCLUDE ZBC405_A24_ALV_F01                      .  " FORM-Routines
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'S100'.
 SET TITLEBAR 'T10' with sy-datum sy-uname.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE to screen 0.
    WHEN 'EXIT'.
      leave PROGRAM.
    WHEN 'CANC'.
      LEAVE to SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_AND_TRANSFER OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_and_transfer OUTPUT.

if go_container IS INITIAL.
  CREATE OBJECT go_container
    EXPORTING
    container_name              = 'my_control_area'

     EXCEPTIONS
    others                      = 6.

    IF sy-subrc <> 0.
  MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CREATE OBJECT go_alv_grid
    EXPORTING
      i_parent          = go_container

    EXCEPTIONS
      others            = 5.

  IF sy-subrc <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  gs_variant-report = sy-cprog.
  gv_save = 'A'.

  CALL METHOD go_alv_grid->set_table_for_first_display
    EXPORTING
*      i_buffer_active               =
*      i_bypassing_buffer            =
*      i_consistency_check           =
      i_structure_name              = 'sflight'
      is_variant                    = gs_variant
      i_save                        = gv_save    "X, A, U
      i_default                     = 'X'
*      is_layout                     =
*      is_print                      =
*      it_special_groups             =
*      it_toolbar_excluding          =
*      it_hyperlink                  =
*      it_alv_graphics               =
*      it_except_qinfo               =
*      ir_salv_adapter               =
    CHANGING
      it_outtab                     = gt_sflt
*      it_fieldcatalog               =
*      it_sort                       =
*      it_filter                     =
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      others                        = 4
          .
  IF sy-subrc <> 0.
*   Implement suitable error handling here
  ENDIF.


ENDIF.

ENDMODULE.
