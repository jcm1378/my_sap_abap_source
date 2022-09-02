*&---------------------------------------------------------------------*
*& Include          ZBC405_A24_SOLE01
*&---------------------------------------------------------------------*


select *
  FROM dv_flights
  into gs_flight.

  write : / gs_flight-carrid,


            gs_flight-price currency PRICE.
