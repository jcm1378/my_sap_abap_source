class ZCLC124_0001 definition
  public
  final
  create public .

public section.

  methods GET_AIRLINE_INFO
    importing
      !PI_CARRID type SCARR-CARRID
    exporting
      !PE_CODE type CHAR1
      !PE_MSG type CHAR100
    changing
      !ET_AIRLINE type ZC1TT24001 .
protected section.
private section.
ENDCLASS.



CLASS ZCLC124_0001 IMPLEMENTATION.


  method GET_AIRLINE_INFO.

IF pi_carrid is initial.
  pe_code = 'E'.
  pe_msg = TEXT-e01.
  EXIT.
ENDIF.

select carrid carrname currcode url
  into CORRESPONDING FIELDS OF table et_airline
  FROM scarr
  WHERE carrid = pi_carrid.

  IF sy-subrc ne 0.
    pe_code = 'E'.
    pe_msg = TEXT-e02.

    else.
      pe_code = 'S'.
    ENDIF.



  endmethod.
ENDCLASS.
