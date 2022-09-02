
*&---------------------------------------------------------------------*
*& Report ZRCA24_NEW_T_10
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa24_new_t_top                        .    " Global Data

INCLUDE zrsa24_new_t_s01                        .
INCLUDE zrsa24_new_t_o01                        .  " PBO-Modules
INCLUDE zrsa24_new_t_i01                        .  " PAI-Modules
INCLUDE zrsa24_new_t_f01                        .  " FORM-Routines

START-OF-SELECTION.

  PERFORM get_data.

  call SCREEN 100.
