*&---------------------------------------------------------------------*
*& Report ZBC405_A24_EXAM01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a24_exam012.


*-----Selection Screen // TOP
TABLES ztspfli_a24.
data : ok_code type sy-ucomm.

SELECTION-SCREEN BEGIN OF BLOCK b1_cond WITH FRAME TITLE TEXT-t01.
SELECT-OPTIONS : so_car FOR ztspfli_a24-carrid,
                 so_con FOR ztspfli_a24-connid.



SELECTION-SCREEN END OF BLOCK b1_cond.

selection-screen skip.

SELECtion-SCreen Begin of block b2_Edit WITH FRAME Title Text-t02.

  PARAMETERS pa_edit as CHECKBOX DEFAULT 'X'.
  selection-screen end of block b2_edit.

*// ---include -------------------------------------------
INCLUDE ZBC405_A24_EXAM2_STATUS_01O01.
*INCLUDE zbc405_a24_exam01_status_01o01.
INCLUDE ZBC405_A24_EXAM2_USER_COMMI01.
*INCLUDE zbc405_a24_exam01_user_commi01.


* Internar Table Type
  types BEGIN OF gty_spfli.
    INCLUDE TYPE ztspfli_a24.

    TYPES END OF gty_spfli.

* DATA
