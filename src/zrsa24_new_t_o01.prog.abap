*&---------------------------------------------------------------------*
*& Include          ZRSA24_NEW_T_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'S100'.
 SET TITLEBAR 'T100' with sy-uname sy-datum.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_FCAT_LAYO OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_fcat_layo OUTPUT.

  PERFORM set_fcat_layo.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_object OUTPUT.

  PERFORM create_object.

ENDMODULE.