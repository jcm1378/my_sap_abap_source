*&---------------------------------------------------------------------*
*& Include          ZBC405_A24_EXAM01_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE to SCREEN 0.
   ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
    CASE ok_code.
    WHEN 'CANC' or 'EXIT'.
      leave PROGRAM.
   ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  ALV_TRENSFER  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
