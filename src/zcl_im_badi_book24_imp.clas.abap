class ZCL_IM_BADI_BOOK24_IMP definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BADI_BOOK24 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_BADI_BOOK24_IMP IMPLEMENTATION.


  method IF_EX_BADI_BOOK24~CHANGE_VLINE.

    c_pos = c_pos + 27.
  endmethod.


  method IF_EX_BADI_BOOK24~OUTPUT.

    data : name type SCUSTOM-name.

    select name
      FROM scustom
      into name
      where id = i_booking-CUSTOMID.
    ENDSELECT.

      write : name, i_booking-ORDER_DATE.
  endmethod.
ENDCLASS.
