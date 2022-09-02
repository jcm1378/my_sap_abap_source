*&---------------------------------------------------------------------*
*& Include ZBC405_A24_FS_TEST_TOP                   - Report ZBC405_A24_FS_TEST
*&---------------------------------------------------------------------*
REPORT ZBC405_A24_FS_TEST.


DATA : d_tab   TYPE REF   TO data,
       d_line  TYPE REF   TO data,
       lt_fcat TYPE TABLE OF lvc_s_fcat,
       ls_fcat LIKE LINE  OF lt_fcat,
       nametab LIKE dntab OCCURS 0 WITH HEADER LINE.

FIELD-SYMBOLS : <table> TYPE any,
                <struc> TYPE any,
                <field> TYPE any.
FIELD-SYMBOLS : <new_tab>  TYPE table,
                <new_line> TYPE any.

PARAMETERS : pa_table like dd031-tabname OBLIGATORY.


DATA : go_container type ref to cl_gui_custom_container,
      go_alv_grid type ref to cl_gui_alv_grid.
