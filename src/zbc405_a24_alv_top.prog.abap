*&---------------------------------------------------------------------*
*& Include ZBC405_A24_ALV_TOP                       - Report ZBC405_A24_ALV
*&---------------------------------------------------------------------*
REPORT zbc405_a24_alv.

DATA: gt_sflt TYPE TABLE OF sflight,
      gs_sflt TYPE sflight,
      ok_code like sy-ucomm.
*---------alv data 선언
DATA : go_container TYPE ref to cl_gui_custom_container ,
       go_alv_grid type ref to cl_gui_alv_grid,
       gs_variant type disvariant,
       gv_save type c LENGTH 1.

*--------selection-screen

SELECT-OPTIONS: so_car FOR gs_sflt-carrid memory id car,
                so_con FOR gs_sflt-connid memory id con,
                so_dat FOR gs_sflt-fldate memory id dat.

PARAMETERS: pa_lv type disvariant-variant.
