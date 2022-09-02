*&---------------------------------------------------------------------*
*& Include ZC1R170004_TOP                           - Report ZC1R170004
*&---------------------------------------------------------------------*
REPORT zc1r170004 MESSAGE-ID zmcsa17.

CLASS lcl_event_handler DEFINITION DEFERRED.

TABLES mast.

DATA: BEGIN OF gs_mat,
        werks TYPE mast-werks,
        matnr TYPE mast-matnr,
        maktx TYPE makt-maktx,
        stlan TYPE mast-stlan,
        stlnr TYPE mast-stlnr,
        stlal TYPE mast-stlal,
        mtart TYPE mara-mtart,
        matkl TYPE mara-matkl,
      END OF gs_mat,

      gt_mat    LIKE TABLE OF gs_mat,

      gv_okcode TYPE sy-ucomm,

      gt_makt   TYPE TABLE OF makt,
      gs_makt   TYPE makt,

      gt_mast   TYPE TABLE OF mast,
      gs_mast   TYPE mast.

" ALV 관련
DATA: gcl_container TYPE REF TO cl_gui_docking_container,
      gcl_alv       TYPE REF TO cl_gui_alv_grid,
      gcl_handler   TYPE REF TO lcl_event_handler,

      gs_layo       TYPE lvc_s_layo,
      gs_fcat       TYPE lvc_s_fcat,
      gt_fcat       TYPE lvc_t_fcat,
      gs_variant    TYPE disvariant.

data gcl_ZCLC124_0002 TYPE REF TO ZCLC124_0002.

" MACRO
DEFINE _clear.

  CLEAR   &1.
  REFRESH &1.

end-OF-DEFINITION.
