*&---------------------------------------------------------------------*
*& Report ZBC401_24_CREATE_CLASS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_24_create_class.

TYPE-POOLS : icon.


CLASS lcl_airplane DEFINITION.

    PUBLIC SECTION.
    METHODS :
          constructor
            IMPORTING iv_name TYPE string
                      iv_planetype TYPE saplane-planetype
            EXCEPTIONS
                      wrong_planetype.
*  //----
*    METHODS : set_attributes
*      IMPORTING iv_name TYPE string
*                iv_planetype TYPE saplane-planetype,
*
              METHODS : display_attribute.

              CLASS-METHODS : display_n_o_airplanes.

              "return 값을 가진 class method (static)
              CLASS-METHODS : get_n_o_airplanes
                            RETURNING VALUE(rv_count) TYPE i.

  PRIVATE SECTION.
    DATA : mv_name TYPE string,
           mv_planetype TYPE saplane-planetype,
           mv_weight TYPE saplane-weight,
           mv_tankcap TYPE saplane-tankcap.

    CLASS-DATA : gv_n_o_airplanes TYPE i.

    CONSTANTS : c_pos_i TYPE i VALUE 30.


ENDCLASS.

CLASS lcl_airplane IMPLEMENTATION.

  METHOD constructor.

      DATA : ls_planetype TYPE saplane.
      mv_name = iv_name.
      mv_planetype = iv_planetype.

      SELECT SINGLE * INTO ls_planetype
        FROM saplane WHERE planetype = iv_planetype.

       IF sy-subrc NE 0.
          RAISE wrong_planetype.

        ELSE.
            mv_weight = ls_planetype-weight.
            mv_tankcap = ls_planetype-tankcap.
             gv_n_o_airplanes = gv_n_o_airplanes + 1.
        ENDIF.

    ENDMETHOD.

*// -----
METHOD get_n_o_airplanes.
  rv_count = gv_n_o_airplanes.
ENDMETHOD.

*  METHOD set_attributes.
*    mv_name = iv_name.
*    mv_planetype = iv_planetype.
*
*    gv_n_o_airplanes = gv_n_o_airplanes + 1.
* ENDMETHOD.

 METHOD display_attribute.
  WRITE : / icon_ws_plane AS ICON, " as icon을 써줘야 한다고함. icon으로 쓴다는 뜻
          / 'Name Of Airplane', AT c_pos_i mv_name,
          / 'type of Airplane', AT c_pos_i mv_planetype,
          / 'weight'          , AT c_pos_i mv_weight, mv_tankcap.
 ENDMETHOD.

 METHOD display_n_o_airplanes.
  WRITE : / 'Number of Airplanes', AT c_pos_i gv_n_o_airplanes.
 ENDMETHOD.

 ENDCLASS.

 DATA : go_airplane TYPE REF TO lcl_airplane.
 DATA : gt_airplanes TYPE TABLE OF REF TO lcl_airplane.

 START-OF-SELECTION.

 CALL METHOD lcl_airplane=>display_n_o_airplanes.
* lcl_airplane=>display_n_o_airplanes( ). " 위에 call method 축약 형!

 CREATE OBJECT go_airplane
        EXPORTING iv_name = 'LH Berlin'
                  iv_planetype = 'a321'
        EXCEPTIONS
          wrong_planetype = 1.
 IF sy-subrc EQ 0.
 APPEND go_airplane TO gt_airplanes.

  ENDIF.

*  call method go_airplane->set_attributes EXPORTING iv_name = 'LH Berlin'
*                                                   iv_planetype = 'a321'.

  CREATE OBJECT go_airplane
        EXPORTING iv_name = 'AA New York'
                  iv_planetype = '747-400'.
 APPEND go_airplane TO gt_airplanes.

*    call method go_airplane->set_attributes EXPORTING iv_name = 'AA New York'
*                                                     iv_planetype = '747-400'.

 CREATE OBJECT go_airplane
        EXPORTING iv_name = 'US Herculs'
                  iv_planetype = '747-200F'.
 APPEND go_airplane TO gt_airplanes.

*    call method go_airplane->set_attributes EXPORTING iv_name = 'US Herculs'
*                                                     iv_planetype = '747-200F'.

LOOP AT gt_airplanes INTO go_airplane.

    CALL METHOD go_airplane->display_attribute.
ENDLOOP.

DATA : gv_count TYPE i.

  gv_count = lcl_airplane=>get_n_o_airplanes( ).
  WRITE : / 'Number of airplane', gv_count.
