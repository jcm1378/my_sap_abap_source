class ZCLC124_0002 definition
  public
  final
  create public .

public section.

  methods GET_MAT
    importing
      !PI_MATNR type MAKT-MATNR
    exporting
      !PE_MAKTX type MAKT-MAKTX
      !PE_CODE type CHAR1
      !PE_MSG type CHAR100 .
protected section.
private section.
ENDCLASS.



CLASS ZCLC124_0002 IMPLEMENTATION.


  METHOD get_mat.

IF pi_matnr is not initial.
  pe_code = 'E'.
  pe_msg = TEXT-e03.
  EXIT.
ENDIF.

    SELECT SINGLE maktx
      FROM makt
      INTO pe_maktx
      WHERE matnr = pi_matnr AND
            spras = sy-langu.

    IF sy-subrc EQ 0.
      pe_code = 'S'.

    ELSE.
      pe_code = 'E'.
      pe_msg = TEXT-e02.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
