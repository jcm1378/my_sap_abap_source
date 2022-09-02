*&---------------------------------------------------------------------*
*& Include ZBC405_A24_EX01_TOP                      - Report ZBC405_A24_EX01
*&---------------------------------------------------------------------*
REPORT ZBC405_A24_EX01.

DATA: gs_flight type dv_flights.

SELECTION-SCREEN begin of BLOCK b1 WITH FRAME title text-t01.

SELECT-OPTIONS: so_car for gs_flight-carrid MEMORY ID car,
                so_con for gs_flight-connid,
                so_dat  for gs_flight-fldate no-EXTENSION.

  SELECTion-screen end of block b1.



selection-SCREEN BEGIN OF BLOCK radio WITH FRAME title text-t02.
  selection-SCREEN begin of line.
    PARAMETERS: p_rad1 RADIOBUTTON GROUP rd1 ,
            p_rad2 RADIOBUTTON GROUP rd1,
            p_rad3 RADIOBUTTON GROUP rd1.
  selection-screen end of line.
  SELECTion-screen end of block radio.
