*&---------------------------------------------------------------------*
*& Include          ZRSA24_NEW_T_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE gv_okcode.
    WHEN 'BACK' OR 'CANC' OR 'EXIT'.
        leave to screen 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
CASE gv_okcode.
  WHEN 'CREATE'.
    clear gv_okcode.
    PERFORM create_row.

  when 'SAVE'.
    clear gv_okcode.
    PERFORM save_data.

  when 'delete'.
    clear gv_okcode.
    PERFORM delete_row.
ENDCASE.


ENDMODULE.
