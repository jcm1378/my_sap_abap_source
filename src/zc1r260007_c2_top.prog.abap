*&---------------------------------------------------------------------*
*& Include ZC1R260007_TOP                           - Report ZC1R260007
*&---------------------------------------------------------------------*
REPORT zc1r260007 MESSAGE-ID zc226.

TABLES : ztc1260002.

DATA : BEGIN OF gs_emp,
         mark,
         pernr    TYPE ztc1260002-pernr,
         ename    TYPE ztc1260002-ename,
         entdt    TYPE ztc1260002-entdt,
         gender   TYPE ztc1260002-gender,
         depid    TYPE ztc1260002-depid,
         carrid   TYPE ztc1260002-carrid,
         carrname TYPE scarr-carrname,
         style    TYPE lvc_t_styl,
       END OF gs_emp,

       gt_emp     LIKE TABLE OF gs_emp,
       gt_emp_del LIKE TABLE OF gs_emp.

DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant,
       gs_stable     TYPE lvc_s_stbl.

DATA : gt_rows TYPE lvc_t_row,  "사용자가 선택한 행의 정보 저장할 ITAB
       gs_row  TYPE lvc_s_row.

DATA : gv_okcode TYPE sy-ucomm.
