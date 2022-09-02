*&---------------------------------------------------------------------*
*& Include          ZC1R240001_S01
*&---------------------------------------------------------------------*

Selection-screen BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

   PARAMETERS : pa_carr type sflight-carrid OBLIGATORY.
   SELECT-OPTIONS so_conn for sflight-connid.

SELECTION-SCREEN end of BLOCK b1.
