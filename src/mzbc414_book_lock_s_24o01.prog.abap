*----------------------------------------------------------------------*
***INCLUDE MBC414_BOOK_LOCK_SO01
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  CLEAR_OKCODE  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE clear_okcode OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " CLEAR_OKCODE  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  HIDE_BOOKID  OUTPUT
*&---------------------------------------------------------------------*
MODULE hide_bookid OUTPUT.
* hide field displaying customer number when working with number range
* object BS_SCUSTOM
  LOOP AT SCREEN.
    CHECK screen-name = 'SDYN_BOOK-BOOKID'.
    screen-active = 0.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.                             " HIDE_BOOKID  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  INITIALIZE_SDYN_BOOK  OUTPUT
*&---------------------------------------------------------------------*
MODULE initialize_sdyn_book OUTPUT.
  IF gv_init_booking = abap_true.
    MOVE-CORRESPONDING sdyn_conn TO sdyn_book.
    sdyn_book-forcuram   = sdyn_conn-price.
    sdyn_book-forcurkey  = sdyn_conn-currency.
    sdyn_book-order_date = sy-datum.
    gv_init_booking = abap_false.
  ENDIF.
ENDMODULE.                 " INITIALIZE_SDYN_BOOK  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
MODULE modify_screen OUTPUT.
  LOOP AT SCREEN.
    CHECK screen-name = 'SDYN_BOOK-CANCELLED' AND
          ( NOT sdyn_book-cancelled IS INITIAL ) AND
          ( sdyn_book-mark IS INITIAL ).
    screen-input = 0.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.                             " MODIFY_SCREEN  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  READ_BOOKINGS  OUTPUT
*&---------------------------------------------------------------------*
MODULE read_bookings OUTPUT.
  IF gv_read_bookings = abap_true.
    PERFORM read_bookings USING    sdyn_conn-carrid
                                   sdyn_conn-connid
                                   sdyn_conn-fldate
                          CHANGING gt_bookings
                                   gt_cd.
    gv_read_bookings = abap_false.
    REFRESH CONTROL 'TC_SBOOK' FROM SCREEN '0200'.
  ENDIF.
ENDMODULE.                 " READ_BOOKINGS  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYN_100'.
  SET TITLEBAR  'DYN_100'.
ENDMODULE.                             " STATUS_0100  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'DYN_200'.
  SET TITLEBAR  'DYN_200' WITH sdyn_conn-carrid
                               sdyn_conn-connid
                               sdyn_conn-fldate.
ENDMODULE.                             " STATUS_0200  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  STATUS_0300  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0300 OUTPUT.
  SET PF-STATUS 'DYN_300'.
  SET TITLEBAR  'DYN_300' WITH sdyn_conn-carrid
                               sdyn_conn-connid
                               sdyn_conn-fldate.
ENDMODULE.                             " STATUS_0300  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  TABSTRIP_INIT  OUTPUT
*&---------------------------------------------------------------------*
MODULE tabstrip_init OUTPUT.
  CASE tab-activetab.
    WHEN 'BOOK'.
      gv_screen_no = '0301'.
    WHEN 'DETCON'.
      gv_screen_no = '0302'.
    WHEN 'DETFLT'.
      gv_screen_no = '0303'.
    WHEN OTHERS.
      tab-activetab = 'BOOK'.
      gv_screen_no  = '0301'.
  ENDCASE.
ENDMODULE.                             " TABSTRIP_INIT  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  TRANS_TO_TC  OUTPUT
*&---------------------------------------------------------------------*
MODULE trans_to_tc OUTPUT.
  MOVE-CORRESPONDING gs_bookings TO sdyn_book.
ENDMODULE.                             " TRANS_TO_TC  OUTPUT
