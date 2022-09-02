*&---------------------------------------------------------------------*
*& Report ZC1R260007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZC1R260007_C2_TOP.
*INCLUDE zc1r260007_top                          .    " Global Data

INCLUDE ZC1R260007_C2_S01.
*INCLUDE zc1r260007_s01                          .  " Selection Screen
INCLUDE ZC1R260007_C2_C01.
*INCLUDE zc1r260007_c01                          .  " Local Class
INCLUDE ZC1R260007_C2_O01.
*INCLUDE zc1r260007_o01                          .  " PBO-Modules
INCLUDE ZC1R260007_C2_I01.
*INCLUDE zc1r260007_i01                          .  " PAI-Modules
INCLUDE ZC1R260007_C2_F01.
*INCLUDE zc1r260007_f01                          .  " FORM-Routines

START-OF-SELECTION.
  PERFORM get_emp_data.
  PERFORM set_style.

  CALL SCREEN '0100'.
