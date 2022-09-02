*&---------------------------------------------------------------------*
*& Include SAPMZC1240001_TOP                        - Module Pool      SAPMZC1240001
*&---------------------------------------------------------------------*
PROGRAM SAPMZC1240001 MESSAGE-ID zmcsa24.

DATA : BEGIN OF gs_data,
  matnr type ZSSA240001-matnr, " Material
  werks type ZSSA240001-werks, " plant
  mtart type ZSSA240001-mtart, " mat. type
  matkl type ZSSA240001-matkl, " mat.groiup
  menge type ZSSA240001-menge, " Quantity
  meins type ZSSA240001-meins, " Unit
  dmbtr type ZSSA240001-dmbtr, " Price
  waers type ZSSA240001-waers, " Currency
  end of gs_data,

  gt_data like table of gs_data,
  gv_okcode type sy-ucomm.


*  ALV 관련
  DATA : gcl_container type REF TO cl_gui_custom_container,
         gcl_grid      type REF TO cl_gui_alv_grid,
         gs_fcat       TYPE        lvc_s_fcat,
         gt_fcat       type        lvc_t_fcat,
         gs_layout     type        lvc_s_layo,
         gs_variant    type        disvariant.
