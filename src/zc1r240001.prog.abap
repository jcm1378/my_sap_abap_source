*&---------------------------------------------------------------------*
*& Report ZC1R240001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZC1R240001_TOP                          .    " Global Data

 INCLUDE ZC1R240001_S01                          .  " Selection Screen
 INCLUDE ZC1R240001_O01                          .  " PBO-Modules
 INCLUDE ZC1R240001_I01                          .  " PAI-Modules
 INCLUDE ZC1R240001_F01                          .  " FORM-Routines

 INITIALIZATION.
  PERFORM init_param.

  start-of-SELECTION.
  PERFORM get_data.

  call screen '0100'.
