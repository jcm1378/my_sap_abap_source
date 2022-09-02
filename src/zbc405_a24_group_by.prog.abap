*&---------------------------------------------------------------------*
*&  REPORT BC405_SELECT_S2
*&---------------------------------------------------------------------*
REPORT zbc405_a24_group_by.

TYPES: BEGIN OF gty_flight,
         carrid      TYPE sflight-carrid,
         connid      TYPE sflight-connid,
         seatsmax    TYPE sflight-seatsmax,
         seatsocc    TYPE sflight-seatsocc,
         num_flights TYPE i,
       END OF gty_flight.

DATA: gt_flights TYPE TABLE OF gty_flight,
      gs_flight  TYPE          gty_flight.

DATA: go_alv_grid TYPE REF TO cl_salv_table.

SELECT-OPTIONS: so_car FOR gs_flight-carrid.


*----------------------------------------------------------------------*
START-OF-SELECTION.

  SELECT
      carrid connid
      SUM( seatsmax ) "seatsmax 레코드 더함
      SUM( seatsocc ) "seatsocc 레코드 더함
      COUNT( * )  "더한 레코드의 row의 수
    INTO TABLE gt_flights
    FROM sflight
    WHERE carrid IN so_car
    GROUP BY carrid connid.

  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = go_alv_grid
    CHANGING
      t_table        = gt_flights ).

  go_alv_grid->display( ).
