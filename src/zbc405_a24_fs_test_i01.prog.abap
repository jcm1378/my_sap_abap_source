*&---------------------------------------------------------------------*
*& Include          ZBC405_A24_FS_TEST_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
CASE sy-ucomm.
  WHEN 'BACK'.
    leave to SCREEN 0.
  WHEN 'CANC' OR 'EXIT'.
    LEAVE PROGRAM.
ENDCASE.
ENDMODULE.