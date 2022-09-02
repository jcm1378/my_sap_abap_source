*----------------------------------------------------------------------*
***INCLUDE MBC414_BOOK_LOCK_SF01
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  COLLECT_MODIFIED_DATA
*&---------------------------------------------------------------------*
*      -->PT_BOOKINGS        text
*      <--CT_BOOKINGS_MOD    text
*----------------------------------------------------------------------*
FORM collect_modified_data USING    pt_bookings     TYPE gty_t_bookings
                           CHANGING ct_bookings_mod TYPE gty_t_sbook.

  DATA ls_book         LIKE LINE OF pt_bookings.
  DATA ls_bookings_mod LIKE LINE OF ct_bookings_mod.

  CLEAR ct_bookings_mod.
  LOOP AT pt_bookings INTO ls_book
       WHERE    mark = abap_true
       AND cancelled = abap_true.
    MOVE-CORRESPONDING ls_book TO ls_bookings_mod.
    APPEND ls_bookings_mod TO ct_bookings_mod.
  ENDLOOP.

ENDFORM.                               " COLLECT_MODIFIED_DATA


*&---------------------------------------------------------------------*
*&      Form  CONVERT_TO_LOC_CURRENCY
*&---------------------------------------------------------------------*
*  -->  PV_FORCURAM        text
*  -->  PV_FORKURKEY       text
*  -->  PV_CARRID          text
*  <--  CV_LOCCURAM        text
*  <--  CV_LOCCURKEY       text
*----------------------------------------------------------------------*
FORM convert_to_loc_currency USING    pv_forcuram  TYPE s_f_cur_pr
                                      pv_forcurkey TYPE s_curr
                                      pv_carrid    TYPE s_carr_id
                             CHANGING cv_loccuram  TYPE s_l_cur_pr
                                      cv_loccurkey TYPE s_currcode.

  PERFORM read_currcode USING    pv_carrid
                        CHANGING cv_loccurkey.

  CALL FUNCTION 'CONVERT_TO_LOCAL_CURRENCY'
    EXPORTING
      client           = sy-mandt
      date             = sy-datum
      foreign_amount   = pv_forcuram
      foreign_currency = pv_forcurkey
      local_currency   = cv_loccurkey
    IMPORTING
      local_amount     = cv_loccuram
    EXCEPTIONS
      no_rate_found    = 1
      overflow         = 2
      no_factors_found = 3
      no_spread_found  = 4
      derived_2_times  = 5
      OTHERS           = 6.
  IF sy-subrc <> 0.
    MESSAGE e080 WITH sy-subrc.
  ENDIF.

ENDFORM.                               " CONVERT_TO_LOC_CURRENCY


************************************************************************
********************************* YOUR CODE ****************************
************************************************************************
