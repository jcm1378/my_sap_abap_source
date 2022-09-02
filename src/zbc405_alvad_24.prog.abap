*&---------------------------------------------------------------------*
*& Report ZBC405_ALVAD_24
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_alvad_24.

TABLES : ztsbook_a24.
*---------------------Selection Screen (TOP Condoition
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
SELECT-OPTIONS: so_car FOR ztsbook_a24-carrid "OBLIGATORY
                            MEMORY ID car,
                so_con for ztsbook_a24-connid
                            MEMORY ID con,
                so_fld FOR ztsbook_a24-fldate,
                so_cus FOR ztsbook_a24-customid.

SELECTION-SCREEN END OF BLOCK b1.


SELECTION-SCREEN SKIP.

PARAMETERS : p_layout TYPE disvariant-variant.

*---------------------DaTa 선언 (TOP / .
TYPES : BEGIN OF gty_sbook.
        INCLUDE TYPE ztsbook_a24.

TYPES : light TYPE c LENGTH 1. "  Selection Button 신호등 Field 추가
TYPES : row_color TYPE c LENGTH 4. " row Color

"Add field - for Catarlog
TYPES : telephone TYPE ztscustom_a24-telephone.
TYPES : email type ztscustom_a24-email.

"sel Color
TYPES : it_color TYPE lvc_t_scol. "sel color type (table)
TYPES : END OF gty_sbook.

"---
  DATA: gt_sbook TYPE TABLE OF gty_sbook,
        gs_sbook TYPE gty_sbook.

  DATA: ok_code TYPE sy-ucomm.


* ----FOR ALV 변수
  DATA : go_container TYPE REF TO cl_gui_custom_container,
         go_alv       TYPE REF TO cl_gui_alv_grid.

" Variant
  DATA : gs_variant TYPE disvariant,
        gs_layout TYPE lvc_s_layo. "A, B, C, D " Selection Button 01

  "Sort
  DATA :  gt_sort TYPE lvc_t_sort,
          gs_sort type lvc_s_sort. "sort work area

  "Sel Color
  DATA: gs_color TYPE lvc_s_scol. "Color work area

  "Toolbar Excluding
  DATA : gt_exct TYPE ui_functions.

  "Field Catalog - for Catarlog
  DATA : gt_fcat TYPE lvc_t_fcat.
  DATA : gs_fcat TYPE lvc_s_fcat.

"Create Class
include ZBC405_ALV_CL1_A24_CLASS.

*--------- Event
  " EVNo1) variant를 parameter로 받아서 variant를 실행때부터 내가 저장한 variant로 접속하기 위함 함수명 저장필수.
  AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_layout. "Parameters F4기능 만드는 것이라고함
    CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
     EXPORTING
       i_save_load                 = 'F'  "S : SAVE
      CHANGING
        cs_variant                  = gs_variant.
    IF sy-subrc <> 0.
* Implement suitable error handling here
      ELSE.
        p_layout = gs_variant-variant.
    ENDIF.

  INITIALIZATION.
  gs_variant-report = sy-cprog.

  START-OF-SELECTION.

    PERFORM get_data.

    CALL SCREEN 100.

*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

"add field - for Catarlog ALL ENTRISE
  DATA : gt_custom TYPE TABLE OF ztscustom_a24,
         gs_custom type ztscustom_a24.

  DATA : gt_temp TYPE TABLE OF gty_sbook.

  "get Sbook data
   SELECT *
     FROM ztsbook_A24
     INTO CORRESPONDING FIELDS OF TABLE gt_sbook
     WHERE carrid IN so_car
     AND connid IN so_con
     AND customid IN so_cus.

  "Add (join) field,, from custom info - for Catarlog, ALL ENTRISE
    IF sy-subrc EQ 0.

      gt_temp = gt_sbook.
      DELETE gt_temp WHERE customid = space. "customid가 없는 것도 지우고.

      SORT gt_temp BY customid.
      DELETE ADJACENT DUPLICATES FROM gt_temp COMPARING customid. "중복 되는 것도 지우고

    SELECT * INTO TABLE gt_custom "Custom 정보를 가져 와서 field를 추가 하겠다.
            FROM ztscustom_a24
            FOR ALL ENTRIES IN gt_temp "새롭게 배운 기법
            WHERE id = gt_temp-customid.
    ENDIF.

     LOOP AT gt_sbook INTO gs_sbook.

      "add field customid - for Catarlog
       READ TABLE gt_custom into gs_custom
                        WITH KEY id = gs_sbook-customid.
       IF sy-subrc eq 0.
         gs_sbook-telephone = gs_custom-telephone.
         gs_sbook-email = gs_custom-email.
       ENDIF.


 " ----Exception handling, Selection Button 01 신호등 추가
       IF gs_sbook-luggweight > 25.
           gs_sbook-light = 1. " 1 red

            ELSEIF gs_sbook-luggweight > 15.
           gs_sbook-light = 2. " 2 yellow

          ELSE.
            gs_sbook-light = 3.
        " 3 Green
            ENDIF.

  "---- row-Color
          IF gs_sbook-class = 'F'. "First Class
               gs_sbook-row_color = 'C710'. " 1C- 2C- 3C- 4C ( c자리마다의 의미)
          ENDIF.

  "---- sel Color
         IF gs_sbook-smoker = 'X'.
           gs_color-fname = 'SMOKER'.
           gs_color-color-col = col_negative.
           gs_color-color-int = '1'. "internar
           gs_color-color-inv = '0'. "invoice
           APPEND gs_color to gs_sbook-it_color.
         ENDIF.

    MODIFY gt_sbook FROM gs_sbook.

     ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'S100'.
 SET TITLEBAR 'S100' WITH 'Maintain booking lst' sy-datum sy-uname.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_object OUTPUT.
   "alv 오브젝트가 컨테이너가 있을때만 생성되도록 하는 코드
  IF go_container IS INITIAL.
     CREATE OBJECT go_container
       EXPORTING

         container_name              = 'MY_CONTROL_AREA'. "이거는 screen 에서 지어준 container area Name을 적어 주어야 한다.
      IF sy-subrc EQ 0.
         CREATE OBJECT go_alv
           EXPORTING
*
             i_parent          = go_container.

          IF sy-subrc EQ 0.


*---PERPORM 으로 SET ____ VALUE 로 설정해서 정리를 해주어도 됨,
            "EVNo1) variant
            gs_variant-variant = p_layout. "i_variant 내가 넣어줬던 variant가 넣어지도록 만들어준 변수, parameter로 variant를 받아서 그 설정 저장한 창을 열기 위함

            "Selection Button
            gs_layout-sel_mode = 'D'. "A, B, C, D

            "Exception handling
            gs_layout-excp_fname = 'LIGHT'. " Selection Button 01 신호등, '' 안에는 내가 선언한 field이름
            gs_layout-excp_led = 'X'. "Icon 모양 변경

            "Zevra Patton
            gs_layout-zebra = 'X'.

            "culomn OPT (TEXT recode 칸이맞게 정렬 가장 긴 자리 기준 field도 포함.
            gs_layout-cwidth_opt ='X'.

            "row-Color 필드 설정.
            gs_layout-info_fname = 'ROW_COLOR'.

            "SORT ( 실행화면에 sort하고 있다면 field위에 붉은색 화살표 모양이 뜬다.
            gs_sort-fieldname = 'CARRID'.
            gs_sort-up = 'X'. "Sort type uo or down
            gs_sort-spos = '1'.
            APPEND gs_sort TO gt_sort. "work area 를 append

            CLEAR gs_sort.
            gs_sort-fieldname = 'CONNID'.
            gs_sort-up = 'X'. "Sort type uo or down
            gs_sort-spos = '2'.
            APPEND gs_sort TO gt_sort.

            CLEAR gs_sort.
            gs_sort-fieldname = 'FLDATE'.
            gs_sort-down = 'X'. "Sort type uo or down
            gs_sort-spos = '3'.
             APPEND gs_sort TO gt_sort.

             "Sel Color
             gs_layout-ctab_fname = 'IT_COLOR'.

      "exclude ->?? Button delete??************
            APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_exct.
            APPEND cl_gui_alv_grid=>mc_fc_info TO gt_exct.

  "-------make field Catarlog - for Catarlog
             CLEAR : gs_fcat.
             gs_fcat-fieldname = 'LIGHT'.
             gs_fcat-coltext = 'info'.
             APPEND gs_fcat TO gt_fcat.

             CLEAR : gs_fcat.
             gs_fcat-fieldname = 'SMOKER'.
             gs_fcat-checkbox = 'X'.
             APPEND gs_fcat TO gt_fcat.

             CLEAR : gs_fcat.
             gs_fcat-fieldname = 'INVOICE'.
             gs_fcat-checkbox = 'X'.
             APPEND gs_fcat TO gt_fcat.

             "Add field - for catarlog
             clear : gs_fcat.
             gs_fcat-fieldname = 'TELEPHONE'.
             gs_fcat-ref_table = 'ZTSCUSTOM_A24'.
             gs_fcat-ref_field = 'TELETPHONE'.
             gs_fcat-col_pos = '4'.
             append gs_fcat to gt_fcat.

             clear : gs_fcat.
             gs_fcat-fieldname = 'EMAIL'.
             gs_fcat-ref_table = 'ZTSCUSTOM_A24'.
             gs_fcat-ref_field = 'EMAIL'.
             gs_fcat-col_pos = '5'.
             append gs_fcat to gt_fcat.

            "coulom color
             clear : gs_fcat.
            gs_fcat-fieldname = 'CUSTUMID'.
            gs_fcat-emphasize = 'C410'. " culomn에 강조할대 쓴다
            append gs_fcat to gt_fcat.

            "---Triger
            SET HANDLER lcl_handler=>on_doubleclick for go_alv.

            CALL METHOD go_alv->set_table_for_first_display "class bilder는 /nse24이다.
              EXPORTING
*                i_buffer_active               =
*                i_bypassing_buffer            =
*                i_consistency_check           =
                i_structure_name              = 'ZTSBOOK_A24' "내가 참조하고있는 테이블..
                is_variant                    = gs_variant "variant  데이터 레코드 ui를 수정이 가능하다 "이거 class가서 type이랑 확인해 봐야함
                i_save                        = 'A'  "수정했던 variant  저장할 수 잇따 *---- i_save : ''(자체 변경만가능 저장x) A(글로벌까지 가능) X U(내가 설정한걸 나만봄)
                i_default                     =   'X' "이 세가지가 모두 켜져야 cariant가 사용이 가능하다
                is_layout                     = gs_layout "각종 layout 설정 strcuture
*                is_print                      =
*                it_special_groups             =
                it_toolbar_excluding          = gt_exct
*                it_hyperlink                  =
*                it_alv_graphics               =
*                it_except_qinfo               =
*                ir_salv_adapter               =
              CHANGING
                it_outtab                     = gt_sbook
                it_fieldcatalog               = gt_fcat         "new Fiele# gt_sbook에 포함 된 필드 중에서 ZTSBOOK_A24에 없는 필드를 화면에 보이고 싶다! 할때
                it_sort                       = gt_sort
*                it_filter                     =
*              EXCEPTIONS
*                invalid_parameter_combination = 1
*                program_error                 = 2
*                too_many_lines                = 3
*                others                        = 4
                    .
            IF sy-subrc <> 0.
*             Implement suitable error handling here
            ENDIF.
*
         ENDIF.
       ENDIF.

    ELSE.
    "-- refresh alv method 올자리

    ENDIF.

ENDMODULE.
