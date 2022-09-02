*----------------------------------------------------------------------*
***INCLUDE ZBC405_A24_EXAM01_STATUS_01O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'S100'.
 SET TITLEBAR 'T100' with sy-uname sy-datum.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&-----------------------------------

" Create Object
MODULE create_alv_object OUTPUT.
  " Create container object
  DATA : go_container type ref to cl_gui_custom_container,
       go_alv type ref to cl_gui_alv_grid.

CREATE OBJECT go_container
  EXPORTING
    container_name              = 'CONTROL_AREA'.

"  create grid object ( when sucessfully Create Container )
IF sy-subrc eq 0.
    CREATE OBJECT go_alv
      EXPORTING
        i_parent          = go_container.


  ENDIF.

ENDMODULE.
