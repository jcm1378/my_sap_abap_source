*&---------------------------------------------------------------------*
*& Include          ZBC405_A24_ALV_CLASS
*&---------------------------------------------------------------------*

"내가 만드는 Event Class
CLASS lcl_handler DEFINITION. "선언 부 (정의 부)
  PUBLIC SECTION.
    CLASS-METHODS : on_doubleclick FOR EVENT double_click "class-method는 static으로 선언
                                    OF cl_gui_alv_grid "of 뒤 이 이벤트를 가지고 있는 class
                                    IMPORTING e_row e_column es_row_no,"내가 이밴트 발생시에 받을 row와 column을 받겠다는 것

                    on_hotspot FOR EVENT hotspot_click
                                OF cl_gui_alv_grid
                                IMPORTING E_row_id e_column_id es_row_no,
                     "toolbar 에 button 생성
                    on_toolbar FOR EVENT toolbar
                               OF cl_gui_alv_grid
                               IMPORTING e_object,
                     "button에 Event처리
                    on_user_command FOR EVENT user_command
                                   OF cl_gui_alv_grid
                                   IMPORTING e_ucomm,

                    on_button_click FOR EVENT button_click
                                   OF cl_gui_alv_grid
                                   IMPORTING es_col_id es_row_no,
                    " context menu
                    on_context_menu_request FOR EVENT context_menu_request
                                            OF cl_gui_alv_grid
                                            IMPORTING e_object, "Class type 의 object

                    "Before User Command User command 들어가기 전에 사용하는데 , 지금은 기존 standard 버튼의 동작을 바꿨다
                    on_before_user_command FOR EVENT before_user_command
                                            OF cl_gui_alv_grid
                                            IMPORTING e_ucomm.

 ENDCLASS.

 CLASS lcl_handler IMPLEMENTATION.

    METHOD on_before_user_command.

      CASE e_ucomm.
        WHEN cl_gui_alv_grid=>mc_fc_detail.
          CALL METHOD go_alv_grid->set_user_command
            EXPORTING
              i_ucomm = 'SCHC'
          .

      ENDCASE.

      ENDMETHOD.



   " menu 도 Screen 처럼 Status임, 메뉴를 만드는 방법 2가지 Screen의 메뉴(Status)를 붙여 가져 오거나 P246.
   " method를 통해서 가져오가나

   "context menu를 가져옴
   METHOD on_context_menu_request.
    CALL METHOD e_object->add_separator.

          CALL METHOD cl_ctmenu=>load_gui_status
       EXPORTING
         program    = sy-cprog
         status     = 'CT_MENU'
*         disable    =
         menu       = e_object
       EXCEPTIONS
         read_error = 1
         OTHERS     = 2
             .
     IF sy-subrc <> 0.
*      Implement suitable error handling here
     ENDIF.


     DATA : ls_row_id TYPE lvc_s_row,
            ls_col_id TYPE lvc_s_col.
     CALL METHOD go_alv_grid->get_current_cell
       IMPORTING
*         e_row     =
*         e_value   =
*         e_col     =
         es_row_id = ls_row_id
         es_col_id = ls_col_id
*         es_row_no =
         .

     IF ls_col_id-fieldname = 'CARRID'.
             "e_object 에서 funtion 을 가져와서 추가  " 모든 culomn에서 Airlien이 나오도록 함
      "culomn마다 쓰고싶으면 get_current_cell써서 특정해 준 뒤 method작성 246page
     CALL METHOD e_object->add_function
     EXPORTING
       fcode             = 'CARR_NAME'
        text              = 'Display Airline'
*     icon              =
*     ftype             =
*     disabled          =
*     hidden            =
*     checked           =
*     accelerator       =
*     insert_at_the_top = SPACE
    .
     ENDIF.







     ENDMETHOD.


   METHOD on_button_click.
     CASE es_col_id-fieldname. "event button이 1개 초과일때 case써서 field이름으로 구분해 동작할수있도로고함..

    WHEN'BTN_TEXT'.
     READ TABLE gt_flt INTO gs_flt
                INDEX es_row_no-row_id.

     IF ( gs_flt-seatsmax NE gs_flt-seatsocc )
       OR ( gs_flt-seatsmax_F NE gs_flt-seatsocc_f ).

       MESSAGE i000(zsa24_msg) WITH '다른 등급 좌석을 예약하세요'.

       ELSE.

       MESSAGE i000(zsa24_msg) WITH '모든좌석이 예약되어있습니다.'.

     ENDIF.
      ENDCASE.
   ENDMETHOD.


   METHOD on_user_command.

        DATA : lv_occp TYPE i,
               lv_capa TYPE i,
               lv_perct TYPE p LENGTH 8 DECIMALS 1,
               lv_text(20).

        DATA: lt_rows TYPE lvc_t_roid,
              ls_rows TYPE lvc_s_roid,
              ls_col TYPE lvc_s_col, " USE CARRNAME
              ls_row TYPE lvc_s_row. "USE CARRNAME

                CALL METHOD go_alv_grid->get_current_cell
                  IMPORTING
*                    e_row     =
*                    e_value   =
*                    e_col     =
                    es_row_id = ls_row
                    es_col_id = ls_col
*                    es_row_no =
                    .


        CASE e_ucomm.

         "before user command의 SCHE의 command
          WHEN'SCHC'. "goto flight schedule
            READ TABLE gt_flt INTO gs_flt INDEX ls_row-index.
            IF sy-subrc eq 0.
               SUBMIT bc405_event_d4 AND RETURN     " 점프를 뛴다.
                      WITH so_car EQ gs_flt-carrid  "with 뒤가  조건이다.
                      WITH so_con EQ gs_flt-connid.
            ENDIF.

          "전체 영역에서 좌석 퍼센트
          WHEN 'PERCENTAGE'.
            LOOP AT gt_flt INTO gs_flt.
              lv_occp = lv_occp + gs_flt-seatsocc.
              lv_capa = lv_capa + gs_flt-seatsmax.
            ENDLOOP.

            lv_perct = lv_occp / lv_capa * 100.
            lv_text = lv_perct.
            CONDENSE lv_text.

            MESSAGE i000(zsa24_msg)
                  WITH 'percentage of occupied seats : ' lv_text.

          "선택된 영역에서 퍼센트
          WHEN 'PERCENTAGE_MARKED'.

          CALL METHOD go_alv_grid->get_selected_rows
            IMPORTING
*              et_index_rows =
              et_row_no     = lt_rows.

            IF lines( lt_rows ) > 0. "만약 선택한 라인이 있을때랑 없을떄 구분

            LOOP AT lt_rows INTO ls_rows.

              READ TABLE gt_flt INTO gs_flt INDEX ls_rows-row_id.
              IF sy-subrc EQ 0.
                lv_occp = lv_occp + gs_flt-seatsocc.
                lv_capa = lv_capa + gs_flt-seatsmax.
              ENDIF.

            ENDLOOP.

            lv_perct = lv_occp / lv_capa * 100.
            lv_text = lv_perct.
            CONDENSE lv_text.

            MESSAGE i000(zsa24_msg)
                  WITH 'percentage of MARKED seats : ' lv_text.

            ELSE.
              MESSAGE i000(zsa24_msg)
                        WITH 'plese selecet rows'.

          ENDIF.

          WHEN'CARR_NAME'.


               CLEAR lv_text.

                  IF ls_col-fieldname = 'CARRID'.
                    READ TABLE gt_flt INTO gs_flt INDEX ls_row-index.
                       SELECT SINGLE carrname
                       FROM scarr
                       INTO lv_text
                       WHERE carrid = gs_flt-carrid.
                  MESSAGE i000(zsa24) WITH lv_text.

                    ELSE.
                      MESSAGE i000(zsa24) WITH 'Select carrid'.
            ENDIF.
        ENDCASE.


     ENDMETHOD.

   METHOD on_toolbar.
      DATA : ls_button TYPE stb_button. "work space s
      ls_button-function = 'PERCENTAGE'. "funtion name
*      ls_button-icon = ?  "아이콘
      ls_button-quickinfo = 'Occupied Total Percentage'. "마우스 오버하면 뜨는 짧ㅅ은
      ls_button-butn_type = '0'. "버튼 type  0번은 nomal 3번은 separator
      ls_button-text = 'percentage'.
      INSERT ls_button INTO TABLE e_object->mt_toolbar.

      CLEAR: ls_button.

       ls_button-butn_type = '3'.
      INSERT ls_button INTO TABLE e_object->mt_toolbar.

      CLEAR: ls_button.

      ls_button-function = 'PERCENTAGE_MARKED'. "funtion name
*      ls_button-icon = ?  "아이콘
      ls_button-quickinfo = 'Occupied MarKED Percentage'. "마우스 오버하면 뜨는 짧ㅅ은
      ls_button-butn_type = '0'. "버튼 type  0번은 nomal 3번은 separator
      ls_button-text = 'Marked percentage'.
      INSERT ls_button INTO TABLE e_object->mt_toolbar.

        CLEAR ls_button.
      ls_button-function = 'CARR_NAME'.
      ls_button-quickinfo = 'show CARR NAME'.
      ls_button-butn_type = '0'.
      ls_button-text = 'CARR NAME'.
      INSERT ls_button INTO TABLE e_object->mt_toolbar.




   ENDMETHOD.


     METHOD on_doubleclick.
    DATA : total_occ TYPE i,
         : total_occ_c TYPE c LENGTH 10. "문자로 넘기면 에러나서 C type 하나 만들어 줌

      CASE e_column-fieldname. "row전체가 아닌 특정 필드(culomn까지 만족할  때만 동작하도록 지정)
        WHEN 'CHANGES_POSSIBLE'.

    READ TABLE gt_flt INTO gs_flt INDEX es_row_no-row_id. "
    IF sy-subrc EQ 0.
        total_occ = gs_flt-seatsocc
        + gs_flt-seatsocc_b
        + gs_flt-seatsocc_f.

        total_occ_c = total_occ. "i type 값을 c로
        CONDENSE total_occ_c.   " 정렬,
        MESSAGE i000(zsa24_msg) WITH 'total number of bookings :'
                    total_occ_c.
      ELSE.
        MESSAGE i075(bc405_408). "internal error
        EXIT.
    ENDIF.
    ENDCASE.

  ENDMETHOD.

      "동작목표 aa를 클릭하면 amrica airline) 뜨게
     METHOD on_hotspot.

     DATA: carr_name TYPE scarr-carrname.

     CASE e_column_id-fieldname.
       WHEN 'CARRID'.
       READ TABLE gt_flt INTO gs_flt INDEX es_row_no-row_id.
        IF sy-subrc EQ 0.
           SELECT SINGLE carrname INTO carr_name FROM scarr
             WHERE carrid = gs_flt-carrid.

           IF sy-subrc EQ 0.
              MESSAGE i000(zsa24_meg) WITH carr_name.
           ELSE.
              MESSAGE i000(zsa24_meg) WITH 'No found!'.
           ENDIF.
        ENDIF.

     ENDCASE.
     ENDMETHOD.


 ENDCLASS.
