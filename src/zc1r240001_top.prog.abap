*&---------------------------------------------------------------------*
*& Include ZC1R240001_TOP                           - Report ZC1R240001
*&---------------------------------------------------------------------*
REPORT ZC1R240001 MESSAGE-ID ZMCSA24.

tables sflight.

DATA : BEGIN OF gs_data,
      carrid    type sflight-carrid,
      connid    type sflight-connid,
      fldate    type sflight-fldate,
      price     type sflight-price,
      currency  type sflight-currency,
      planetype type sflight-planetype,
  END OF gs_data,

        gt_data like TABLE OF gs_data.


*        ALV

data : gcl_container type ref to cl_gui_docking_container, "Docking container는 화면 맞춤형으로 (비율로 먹음)
       gcl_grid      type ref to cl_gui_alv_grid,
       gs_fcat       type lvc_s_fcat,
       gt_fcat       type lvc_t_fcat,
       gs_layout     type lvc_s_layo,
       gs_variant    type disvariant.

data : gv_okcode type sy-ucomm.
