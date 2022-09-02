REPORT  zbc425_iep_fm_template.

PARAMETERS: netprice  TYPE bc425_price,
            discount  TYPE i.

DATA: fullprice  TYPE bc425_price,
      discprice  TYPE bc425_price.


* Calling the enhanced function module
CALL FUNCTION 'BC425_24_CALC_PRICE'
  EXPORTING
    im_netprice        = netprice
   IM_DISCOUNT        = discount
 IMPORTING
   EX_FULLPRICE       = fullprice
   EX_DISCPRICE       = discprice
          .



WRITE: / 'Full price :',     18 fullprice,
       / 'Discount price :', 18 discprice.
