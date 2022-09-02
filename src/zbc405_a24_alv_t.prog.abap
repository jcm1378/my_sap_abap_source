*&---------------------------------------------------------------------*
*& Report ZBC405_T3_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a24_alv_t.

"스텐다드의 테이블 타입 외에 내가 추가할 필드를 넣으려고 만들어준 테이블 타입
TYPES BEGIN OF typ_flt.
  INCLUDE TYPE sflight.
  TYPES : changes_possible TYPE icon-id. "필드를 하나 추가했음.
  TYPES: btn_text TYPE c LENGTH 10. "버튼 텍스트 추가
  types: tankcap type saplane-tankcap,
         cap_unit type saplane-cap_unit,
         weight type saplane-weight,
         wei_unit type saplane-wei_unit.
  TYPES: light TYPE c LENGTH 1. "내가 추가한 light field
  TYPES: row_color TYPE c LENGTH 4.
  TYPES: it_color TYPE lvc_t_scol. "sell 단위 색 넣기위해
  TYPES: it_styl TYPE lvc_t_styl.
  TYPES : END OF typ_flt.

DATA : gt_flt TYPE TABLE OF typ_flt.
DATA : gs_flt TYPE typ_flt.
DATA : ok_code LIKE sy-ucomm.

*----------------------------------------------- alv data 선언
DATA : go_container TYPE REF TO cl_gui_custom_container, "Container class REF
       go_alv_grid  TYPE REF TO cl_gui_alv_grid, "alv grid class REF

       gs_variant   TYPE disvariant,
       gs_layout TYPE lvc_s_layo,
       gv_save      TYPE c LENGTH 1,
       gt_sort      TYPE lvc_t_sort,
       gs_sort      TYPE lvc_s_sort,
       gs_color     TYPE lvc_s_scol,
       gt_exct      TYPE ui_functions,
       gt_fcat      TYPE lvc_t_fcat,
       gs_fcat      TYPE lvc_s_fcat,
       gs_stable    TYPE lvc_s_stbl,
       gs_styl      TYPE lvc_s_styl,
       gv_soft_refresh TYPE abap_bool.

INCLUDE zbc405_a24_ALV_class. "이거 인클루드 밑에다 해야함, 위에 선언해준 변수들도 사용할 거라서.\


*---------------------------------------------- selection-screen

SELECT-OPTIONS : so_car FOR gs_flt-carrid MEMORY ID car,
                 so_con FOR gs_flt-connid MEMORY ID con,
                 so_dat FOR gs_flt-fldate.


SELECTION-SCREEN SKIP 1.

PARAMETERS : p_date TYPE sy-datum DEFAULT '20201001'. "이건 그냥 기준이 되는 데이터 넣어준 거임
PARAMETERS : pa_lv TYPE disvariant-variant.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_lv.

  gs_variant-report = sy-cprog.

  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load     = 'F'     "S, F L 저장 유저 권한설정
    CHANGING
      cs_variant      = gs_variant
    EXCEPTIONS
      not_found       = 1
      wrong_input     = 2
      fc_not_complete = 3
      OTHERS          = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here

  ELSE.
    pa_lv = gs_variant-variant.
  ENDIF.

*---------------------------------------------------------START OF SELECTION
START-OF-SELECTION.
  PERFORM get_data.



  CALL SCREEN 100.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T10' WITH sy-datum sy-uname.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      " 메모리에 쌓이는 object 들을 다시 지워 줌. 안해줘도 되지만 하는 걸 원칙으로 한다.
      CALL METHOD go_alv_grid->free.
      CALL METHOD go_container->free.

      LEAVE TO SCREEN 0.   "SET SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_AND_TRANSFER OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_and_transfer OUTPUT.

  IF go_container IS INITIAL.
    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'
      EXCEPTIONS
        OTHERS         = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.



    CREATE OBJECT go_alv_grid
      EXPORTING
        i_parent = go_container
      EXCEPTIONS
        OTHERS   = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


    PERFORM make_variant.
    PERFORM make_layout.
    PERFORM make_sort.
    PERFORM make_fieldcatalog.


* ALV의 버튼을 없애는 것
    APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_exct.  "=> CLass에 ATribute를 직접 참조한다.
    APPEND cl_gui_alv_grid=>mc_fc_info TO gt_exct.
*    APPEND cl_GUI_ALV_GRID=>mc_fc_excl_all TO gt_exct "전체 없애는 것


      SET HANDLER lcl_handler=>on_doubleclick FOR go_alv_grid. "Static Method기 때문에 이름 그대로 사용
      SET HANDLER lcl_handler=>on_hotspot FOR go_alv_grid.
      SET HANDLER lcl_handler=>on_toolbar FOR go_alv_grid.
      SET HANDLER lcl_handler=>on_user_command FOR go_alv_grid.
      SET HANDLER lcl_handler=>on_button_click FOR go_alv_grid.
      SET HANDLER lcl_handler=>on_context_menu_request for go_alv_grid.
      set handler lcl_handler=>on_before_user_command for go_alv_grid.
    CALL METHOD go_alv_grid->set_table_for_first_display
      EXPORTING
*       i_buffer_active               =
*       i_bypassing_buffer            =
*       i_consistency_check           =
        i_structure_name              = 'SFLIGHT'
        is_variant                    = gs_variant "variant 다이나믹하게 필드를 조작 할 수 있도록 함
        i_save                        = gv_save  "Variant  "X , A,  U 레이아웃 설정 저장이 가능하게함
        i_default                     = 'X'
        is_layout                     = gs_layout "레이아웃 설정 (꾸미기)
*       is_print                      =
*       it_special_groups             =
       it_toolbar_excluding          = gt_exct     "EXcludeing 화면에 있는 버튼을 지워 줌, 버튼의 이름은 CL_GUI_ALV_GRID의 attribute에 MC로 시작하는 field에 있음
*       it_hyperlink                  =
*       it_alv_graphics               =
*       it_except_qinfo               =
*       ir_salv_adapter               =
      CHANGING
        it_outtab                     = gt_flt
       it_fieldcatalog               = gt_fcat " 필드를 수정하기 위해 사용
       it_sort                       = gt_sort "Funtion의 네이밍 룰을 보고 type을 확인해야함
*       it_filter                     =
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


    ELSE.
      gv_soft_refresh = 'X'.
      gs_stable-row = 'X'.
      gs_stable-col = 'X'.


     CALL METHOD go_alv_grid->refresh_table_display
       EXPORTING
         is_stable      = gs_stable
         i_soft_refresh = gv_soft_refresh
       EXCEPTIONS
         finished       = 1
*         others         = 2
             .
     IF sy-subrc <> 0.
*      Implement suitable error handling here
     ENDIF.


  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
    SELECT *
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_flt
    WHERE carrid IN so_car
    AND connid IN so_con
    AND fldate IN so_dat.





      LOOP AT gt_flt INTO gs_flt.
        IF gs_flt-seatsocc < 5.
           gs_flt-light = '1'.
        ELSEIF gs_flt-seatsocc < 100.
           gs_flt-light = '2'.
        ELSE.
           gs_flt-light = '3'.
        ENDIF.

        IF gs_flt-fldate+4(2) = sy-datum+4(2).
            gs_flt-row_color = 'C511'. "c - color 대문자 여야함 , 3=intensified글자 강조, 1ntensified off연하게,
        ENDIF.

        IF gs_flt-planetype = '747-400'.

            gs_color-fname = 'PLANETYPE'.
            gs_color-color-col = col_total.
            gs_color-color-int = '1'.
            gs_color-color-inv  = '0'.
            APPEND gs_color TO gs_flt-it_color.

        ENDIF.

        IF gs_flt-seatsocc_b = 0.
          gs_color-fname = 'PLANETYPE'.
           gs_color-color-col = col_negative.

            gs_color-color-int = '1'.
            gs_color-color-inv  = '0'.
            APPEND gs_color TO gs_flt-it_color.
        ENDIF.

        IF gs_flt-fldate < p_date.

           gs_flt-changes_possible = icon_space.
             ELSE.
           gs_flt-changes_possible = icon_okay.
        ENDIF.

        IF gs_flt-seatsmax_b = gs_flt-seatsocc_b.
          gs_flt-btn_text = 'FullSeats'.

          gs_styl-fieldname = 'BTN_TEXT'.
          gs_styl-style = cl_gui_alv_grid=>mc_style_button.
          APPEND gs_styl TO gs_flt-it_styl.
        ENDIF.

        SELECT SINGLE *
          FROM saplane
          INTO CORRESPONDING FIELDS OF gs_flt
          WHERE planetype = gs_flt-planetype.

        MODIFY gt_flt FROM gs_flt.
      ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_variant .
       gs_variant-report = sy-cprog.
        gs_variant-variant = pa_lv.
        gv_save = 'A'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_layout .
     gs_layout-zebra = 'X'.
*    gs_layout-cwidth_opt = 'X'. "화면 사이즈에 맞게, fieldcat col_opt역할
    gs_layout-sel_mode = 'D'. " A, B, C, D space

    gs_layout-excp_fname = 'LIGHT'. "exception handling 이건 ALV에 고정적으로 있는 field임
    gs_layout-excp_led = 'X'.

    gs_layout-info_fname = 'ROW_COLOR'.

    gs_layout-ctab_fname ='IT_color'.

    gs_layout-stylefname = 'IT_STYL'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_sort .

  CLEAR gs_sort.

  gs_sort-fieldname = 'CARRID'. "field name
  gs_sort-up = 'X'. " up toggle
  gs_sort-spos = 1. " 우선순위, carrid가 1순위
  APPEND gs_sort TO gt_sort.

    gs_sort-fieldname = 'CONNID'.
  gs_sort-up = 'X'.
  gs_sort-spos = 2. " carrid 기준 정렬 안에서 2순위 정렬
  APPEND gs_sort TO gt_sort.

    gs_sort-fieldname = 'FLDATE'.
  gs_sort-down = 'X'. "down 내림차순
  gs_sort-spos = 3.
  APPEND gs_sort TO gt_sort.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_fieldcatalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_fieldcatalog .

  "hot spot 사용하기 위해 필드에 추가
    CLEAR : gs_fcat.
  gs_fcat-fieldname = 'CARRID'.
*  gs_fcat-hotspot = 'X'.
  APPEND gs_fcat TO gt_fcat.

  " Change Field text
  gs_fcat-fieldname = 'LIGHT'. "기존에 있던 field
  gs_fcat-coltext = 'info'. " 속성의 이름을 수정해줌
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat. "work area는 항상 재사용할때지워줘야함

  " Hide Field , columm, opt , emphasize
  gs_fcat-fieldname = 'PRICE'.
  gs_fcat-emphasize = 'C610'.
  gs_fcat-edit = 'X'. "display를 수정이 가능하게 만들고 버튼이 생김. 내가 edit에 필요한 것들이 생김.
*  gs_fcat-no_out = 'X'. "hide
  gs_fcat-col_opt = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.

  " Sflight에 없는 field 를 추가
  gs_fcat-fieldname = 'CHANGES_POSSIBLE'.
  gs_fcat-coltext = 'Change.Poss'.
  gs_fcat-col_opt = 'X'.
  gs_fcat-col_pos = 5.
  APPEND gs_fcat TO gt_fcat.

  CLEAR: gs_fcat.

   gs_fcat-fieldname = 'BTN_TEXT'.
   gs_fcat-coltext = 'status'.
   gs_fcat-col_pos = 12.
   APPEND gs_fcat TO gt_fcat.

*tankcap type saplane-tankcap,
*         cap_unit type saplane-cap_unit,
*         weight type saplane-weight,
*         wei_unit type saplane-wei_unit.


"ref 를 사용해 table과 field 가져오기 -> 이걸쓰면 위에 데이터 타입을 가져오지 않아도 된다.
"단위 레퍼런스 해준 거다...quntati 라서 qfieldname 임 통화는 curr이라서 cfieldname을 적어줘야 함
  CLEAR: gs_fcat.
  gs_fcat-fieldname = 'TANKCAP'.
  gs_fcat-ref_table = 'SAPLANE'.
  gs_fcat-ref_field = 'TANKCAP'.
  gs_fcat-qfieldname = 'cap_unit'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR: gs_fcat.
  gs_fcat-fieldname = 'CAP_UNIT'.
  gs_fcat-ref_table = 'SAPLANE'.
  gs_fcat-ref_field = 'CAP_UNIT'.
*  gs_fcat-coltext = 'cap_unit'.,
  APPEND gs_fcat TO gt_fcat.

  CLEAR: gs_fcat.
  gs_fcat-fieldname = 'WEIGHT'.
  gs_fcat-ref_table = 'SAPLANE'.
  gs_fcat-ref_field = 'WEIGHT'.
  gs_fcat-qfieldname = 'WEI_UNIT'.
*  gs_fcat-coltext = 'Weight'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR: gs_fcat.
  gs_fcat-fieldname = 'WEI_UNIT'.
  gs_fcat-ref_table = 'SAPLANE'.
  gs_fcat-ref_field = 'WEI_UNIT'.
*  gs_fcat-coltext = 'cwei-unit'.
  APPEND gs_fcat TO gt_fcat.



ENDFORM.
