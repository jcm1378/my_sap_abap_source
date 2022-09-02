*&---------------------------------------------------------------------*
*& Include          ZC1R260007_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS :
      handle_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING
          er_data_changed,

      handle_change_finished FOR EVENT data_changed_finished
        OF cl_gui_alv_grid
        IMPORTING
          e_modified
          et_good_cells.


ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD handle_data_changed.

    PERFORM handle_data_changed USING er_data_changed.

  ENDMETHOD.

  METHOD handle_change_finished.

    PERFORM handle_change_finished USING e_modified et_good_cells.

  ENDMETHOD.

ENDCLASS.
