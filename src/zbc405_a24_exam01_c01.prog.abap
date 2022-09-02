*----------------------------------------------------------------------*
***INCLUDE ZBC405_A24_EXAM01_C01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_handler DEFINITION FINAL.
  PUBLIC SECTION.
    class-METHODS :
    on_toolbar FOR EVENT toolbar
                               OF cl_gui_alv_grid
                               IMPORTING e_object,

    on_usercommand FOR EVENT user_Command
                              OF cl_gui_alv_grid
                              IMPORTING e_ucomm.

ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.
   METHOD on_toolbar.
    DATA : wa_button TYPE stb_button.

    CLEAR : wa_button.
    wa_button-butn_type = '0'.    "normal button
    wa_button-function = 'FLIGHT'.   "flight connection.
    wa_button-icon     = ICON_Flight.
    wa_button-quickinfo = 'Go to flight connection!'.
    wa_button-text = 'Flight'.
    INSERT wa_button INTO TABLE e_object->mt_toolbar.

    CLEAR : wa_button.
    wa_button-butn_type = '0'.    "normal button
    wa_button-function = 'FLIGHT_INFO'.   "flight connection.

    wa_button-quickinfo = 'Go to flight connection!'.
    wa_button-text = 'Flight Info'.
    INSERT wa_button INTO TABLE e_object->mt_toolbar.

        CLEAR : wa_button.
    wa_button-butn_type = '0'.    "normal button
    wa_button-function = 'FLIGHT_DATA'.   "flight connection.
    wa_button-quickinfo = ''.
    wa_button-text = 'Flight Data'.
    INSERT wa_button INTO TABLE e_object->mt_toolbar.

  ENDMETHOD.

    METHOD on_usercommand.


  ENDMETHOD.
  ENDCLASS.
