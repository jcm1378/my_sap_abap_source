*&---------------------------------------------------------------------*
*& Include ZRSA24_NEW_T_TOP                         - Report ZRCA24_NEW_T_10
*&---------------------------------------------------------------------*
REPORT ZRCA24_NEW_T_10 MESSAGE-ID zmcsa24.

TABLES ZTSA2401_C.

DATA : BEGIN OF gs_data,
        MANDT type ZTSA2401_C-mandt,
        PERNR type ZTSA2401_C-pernr,
        ENAME type ZTSA2401_C-ename,
        ENTDT type ZTSA2401_C-entdt,
        GENDER type ZTSA2401_C-gender,
        DEPNR  type ZTSA2401_C-depnr,
  end of gs_data,
       gt_data like table of gs_data,

       gt_data_del like table of gs_data.

       gv_okcode type sy-ucomm.

*       ALV관련
DATA : gcl_container type ref to cl_gui_docking_container,
       gcl_alv       type ref to cl_gui_alv_grid,
*       gcl_handler   type ref to lcl_event_handler,

       gs_layo    type lvc_s_layo,
       gs_fcat    type lvc_s_fcat,
       gt_fcat    type lvc_t_fcat,
       gs_variant type disvariant,
       gs_stable  type lvc_s_stbl.

DATA : gs_row type gs_data,
       gt_rows like table OF gs_row.

" MACRO
DEFINE _clear.

  clear &1.
  refresh &1.

END-OF-DEFINITION.
