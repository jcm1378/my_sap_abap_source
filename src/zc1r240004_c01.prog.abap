**&---------------------------------------------------------------------*
**& Include          ZC1R170004_C01
**&---------------------------------------------------------------------*
*
*CLASS lcl_handler DEFINITION.
*  PUBLIC SECTION.
*    CLASS-METHODS:
*      on_double_click FOR EVENT double_click  OF cl_gui_alv_grid IMPORTING es_row_no e_column,
*      on_hotspot      FOR EVENT hotspot_click OF cl_gui_alv_grid IMPORTING e_column_id es_row_no.
*ENDCLASS.
*
*CLASS lcl_handler IMPLEMENTATION.
*
*  METHOD on_double_click.
*
*    PERFORM set_db_click USING e_column-fieldname
*                               es_row_no-row_id.
*
*  ENDMETHOD.
*
*  METHOD on_hotspot.
*
*    PERFORM set_hotspot USING e_column_id-fieldname
*                              es_row_no-row_id.
*
*  ENDMETHOD.
*
*ENDCLASS.

* -------------------------------강사님-----------------------------------------------

*&---------------------------------------------------------------------*
*& Class lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL. " FINAL 이 붙으면 더 이상 상속하지 않음.
*  Inheritance    : 상속성 ( 부모 클래스로부터 받은 것을 이용할 수 있음 )
*  Encapsulation  : 캡슐화
*  Polymorphism   : 다형성 ( 같은 이름으로 여러 기능을 가질 수 있음 - parameter, returning value 등에 따라서 구분이 가능함 Overloading)

  PUBLIC SECTION.
    METHODS :
      handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING
          e_row
          e_column,

      handle_hotspot FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING
          e_row_id
          e_column_id.

ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD handle_double_click.

    PERFORM handle_double_click USING e_row e_column.

  ENDMETHOD.

  METHOD handle_hotspot.

    PERFORM handle_hotspot USING e_row_id e_column_id.

  ENDMETHOD.
ENDCLASS.
