*&---------------------------------------------------------------------*
*& Report ZC1R170004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZC1R240004_TOP.
*INCLUDE zc1r170004_top.  " Global Data
INCLUDE ZC1R240004_S01.
*INCLUDE zc1r170004_s01.  " Selection Screen
INCLUDE ZC1R240004_C01.
*INCLUDE zc1r170004_c01.  " Event Class
INCLUDE ZC1R240004_O01.
*INCLUDE zc1r170004_o01.  " PBO-Modules
INCLUDE ZC1R240004_I01.
*INCLUDE zc1r170004_i01.  " PAI-Modules
INCLUDE ZC1R240004_F01.
*INCLUDE zc1r170004_f01.  " FORM-Routines

INITIALIZATION.

  PERFORM init_get_data.

START-OF-SELECTION.

  PERFORM get_bom_data.

  CALL SCREEN 0100.
