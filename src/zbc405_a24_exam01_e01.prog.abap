*&---------------------------------------------------------------------*
*& Include          ZBC405_A24_EXAM01_E01
*&---------------------------------------------------------------------*

INITIALIZATION.
   gs_variant-report = sy-cprog.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_lv.
PERFORM save_variant.

START-OF-SELECTION.

 "get DATA
PERFORM get_data.



"Call Screen
call SCREEN 100.
