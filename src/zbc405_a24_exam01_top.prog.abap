*&---------------------------------------------------------------------*
*& Include ZBC405_A24_EXAM01_TOP                    - Report ZBC405_A24_EXAM01
*&---------------------------------------------------------------------*
REPORT zbc405_a24_exam01.


"GLOVER DATA
TABLES ztspfli_a24.
DATA : ok_code TYPE sy-ucomm.

"Object
DATA : go_container TYPE REF TO cl_gui_custom_container,
       go_alv TYPE REF TO cl_gui_alv_grid.


"alv DATA
 DATA: gs_variant TYPE disvariant,
       gs_layout TYPE lvc_s_layo,
       gt_fcat type lvc_t_fcat,
       gs_fcat type lvc_s_fcat,
       gs_color   TYPE lvc_s_scol.


* Internar Table & Type
  TYPES : BEGIN OF gty_spfli.
    INCLUDE TYPE ztspfli_a24.
    types : id type c length 1,
            flight type icon-id,
            from_tz type sairport-time_zone,
            light type c LENGTH 1,
            it_color  TYPE lvc_t_scol,
            to_tz type sairport-time_zone.

    TYPES END OF gty_spfli.

    DATA : gt_spfli TYPE TABLE OF gty_spfli,
           gs_spfli LIKE LINE OF gt_spfli.


*-----Selection Screen
SELECTION-SCREEN BEGIN OF BLOCK b1_cond WITH FRAME TITLE TEXT-t01.
SELECT-OPTIONS : so_car FOR ztspfli_a24-carrid,
                 so_con FOR ztspfli_a24-connid.

SELECTION-SCREEN END OF BLOCK b1_cond.


*SELECTION-SCREEN SKIP.
SELECTION-SCREEN BEGIN OF BLOCK b2_Edit WITH FRAME TITLE TEXT-t02.
*  SELECTION-screen BEGIN OF LINE.

  PARAMETERS pa_edit AS CHECKBOX DEFAULT 'X'.
  PARAMETERS pa_lv type disvariant-variant .

*  SELECtion-screen end of line.
  SELECTION-SCREEN END OF BLOCK b2_edit.
