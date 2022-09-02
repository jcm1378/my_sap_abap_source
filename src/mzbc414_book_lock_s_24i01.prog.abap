*----------------------------------------------------------------------*
***INCLUDE MBC414_BOOK_LOCK_SI01
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  CHECK_FLIGHT  INPUT
*&---------------------------------------------------------------------*
MODULE check_flight INPUT.
  CALL FUNCTION 'ENQUEUE_ESFLIGHT'
    EXPORTING
      carrid         = sdyn_conn-carrid
      connid         = sdyn_conn-connid
      fldate         = sdyn_conn-fldate
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.
  CASE sy-subrc.
    WHEN 0.
    WHEN 1.
      MESSAGE e060.
    WHEN OTHERS.
      MESSAGE e063 WITH sy-subrc.
  ENDCASE.
  PERFORM check_sflight CHANGING sdyn_conn.
  PERFORM check_spfli   CHANGING sdyn_conn.
ENDMODULE.                 " CHECK_FLIGHT  INPUT


*&---------------------------------------------------------------------*
*&      Module  MODIFY_ITAB  INPUT
*&---------------------------------------------------------------------*
MODULE modify_itab INPUT.
  MOVE-CORRESPONDING sdyn_book TO gs_bookings.
  gs_bookings-mark = abap_true.
  MODIFY gt_bookings FROM gs_bookings INDEX tc_sbook-current_line
                                      TRANSPORTING cancelled mark.
ENDMODULE.                             " MODIFY_ITAB  INPUT


*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'CANCEL'.
      CASE sy-dynnr.
        WHEN '0100'.
          LEAVE PROGRAM.
        WHEN '0200'.
          CALL FUNCTION 'DEQUEUE_ALL'.
          LEAVE TO SCREEN '0100'.
        WHEN '0300'.
          CALL FUNCTION 'DEQUEUE_ALL'.
          LEAVE TO SCREEN '0100'.
        WHEN OTHERS.
      ENDCASE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.                             " EXIT  INPUT


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
******************************CANCEL BOOKING****************************
    WHEN 'BOOKC'.
      SET SCREEN '0200'.
      CALL FUNCTION 'ENQUEUE_ESBOOK'
        EXPORTING
          carrid         = sdyn_conn-carrid
          connid         = sdyn_conn-connid
          fldate         = sdyn_conn-fldate
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.
      CASE sy-subrc.
        WHEN 0.
          gv_read_bookings = abap_true.
        WHEN OTHERS.
          MESSAGE e063 WITH sy-subrc.
      ENDCASE.
******************************CREATE BOOKING****************************
    WHEN 'BOOKN'.
      gv_init_booking = abap_true.
      SET SCREEN '0300'.
    WHEN 'BACK'.
      SET SCREEN '0000'.
    WHEN OTHERS.
      SET SCREEN '0100'.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CASE ok_code.
    WHEN 'SAVE'.
      PERFORM collect_modified_data USING    gt_bookings
                                    CHANGING gt_bookings_mod.
*     Modify bookings
      PERFORM modify_bookings USING gt_bookings_mod
                                    sdyn_conn.
      CALL FUNCTION 'DEQUEUE_ALL'.
*     ToDo: Create Change Document for all modified bookings
      SET SCREEN '0100'.
    WHEN 'BACK'.
      CALL FUNCTION 'DEQUEUE_ALL'.
      SET SCREEN '0100'.
    WHEN OTHERS.
      SET SCREEN '0200'.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0200  INPUT


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0300 INPUT.
  CASE ok_code.
    WHEN 'BOOK' OR 'DETCON' OR 'DETFLT'.
      tab-activetab = ok_code.
    WHEN 'NEW_CUSTOM'.
*     Optional: Create new customer
      SET SCREEN '0300'.
    WHEN 'SAVE'.
      PERFORM convert_to_loc_currency USING    sdyn_book-forcuram
                                               sdyn_book-forcurkey
                                               sdyn_book-carrid
                                      CHANGING sdyn_book-loccuram
                                               sdyn_book-loccurkey.
*     ToDo: Get next free number in the number range '01'
*           of number object 'SBOOKID'
      CALL FUNCTION 'ENQUEUE_ESBOOK'
        EXPORTING
          carrid         = sdyn_book-carrid
          connid         = sdyn_book-connid
          fldate         = sdyn_book-fldate
          bookid         = sdyn_book-bookid
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.
      CASE sy-subrc.
        WHEN 0.
        WHEN 1.
          MESSAGE e061.
        WHEN OTHERS.
          MESSAGE e063 WITH sy-subrc.
      ENDCASE.
*     ToDo: Save booking and update flight
      CALL FUNCTION 'DEQUEUE_ALL'.
      SET SCREEN '0100'.
    WHEN 'BACK'.
      CALL FUNCTION 'DEQUEUE_ALL'.
      SET SCREEN '0100'.
    WHEN OTHERS.
      SET SCREEN '0300'.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0300  INPUT
