*&---------------------------------------------------------------------*
*& Include          ZBC405_ALV_CL1_A24_CLASS
*&---------------------------------------------------------------------*

CLASS lcl_handler DEFINITION.
PUBLIC SECTION.

  CLASS-METHODS : on_doubleclick FOR EVENT
                  double_click OF cl_gui_alv_grid
               IMPORTING e_row e_column es_row_no. "cl의 method 에서 가져옴

 ENDCLASS.

 CLASS lcl_handler IMPLEMENTATION.

   METHOD on_doubleclick.

        data : carrname type scarr-carrname.

        case e_column-fieldname.
          when 'CARRID'.
            READ TABLE gt_sbook into gs_sbook
                 INDEX e_row-index.
            IF sy-subrc eq 0.

              select SINGLE carrname into carrname
                FROM scarr WHERE carrid = gs_sbook-carrid.
                IF sy-subrc eq 0.
                    MESSAGE i000(za24_msg) with carrname.

                ENDIF.

            ENDIF.

       ENDCASE.

     ENDMETHOD.
  ENDCLASS.
