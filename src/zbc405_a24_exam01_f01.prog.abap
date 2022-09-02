*&---------------------------------------------------------------------*
*& Include          ZBC405_A24_EXAM01_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data.

"Main DATA ztspfli_a24
    select *
  FROM ztspfli_a24
  INTO CORRESPONDING FIELDS OF TABLE gt_spfli
  WHERE carrid in so_car AND
        connid in so_con.

*perform mopdify.
" I&D, icon, From_TIME_ZONE, TO_TIME_ZONE
LOOP AT gt_spfli into gs_spfli.

" Color
  IF gs_spfli-COUNTRYFR = gs_spfli-COUNTRYTO.
    gs_spfli-id = 'D'.
     "PERFOM SET COLOR
      gs_color-fname = 'ID'.
      gs_color-color-col = '3'.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_spfli-it_color.
  else.
    gs_spfli-id = 'I'.
      "PERFOM SET COLOR
      gs_color-fname = 'ID'.
      gs_color-color-col = '5'.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_spfli-it_color.
  ENDIF.

  IF gs_spfli-from_tz is INITIAL.
      SELECT single time_zone
      from SAIRPORT
      into gs_spfli-from_tz
      WHERE id = gs_spfli-AIRPFROM.
  ENDIF.

  IF gs_spfli-to_tz is INITIAL.
      SELECT SINGLE time_zone
      from SAIRPORT
      into gs_spfli-to_tz
      WHERE id = gs_spfli-AIRPTO.
  ENDIF.

if gs_spfli-fltype = 'X'.
    gs_spfli-flight = ICON_FLIGHT.
  endif.

  CASE gs_spfli-PERIOD.
    WHEN '0'.
      gs_spfli-light = 3.  "green.

    WHEN '1'.
      gs_spfli-light = 2.   "yellow

    WHEN OTHERS.
       gs_spfli-light = 1.    "red
  ENDCASE.


  Modify gt_spfli FROM gs_spfli.


ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_variant .

    CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'F'       "S :save, L :load  F: F4
    CHANGING
      cs_variant  = gs_variant.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    pa_lv  =  gs_variant-variant.
  ENDIF.

ENDFORM.
