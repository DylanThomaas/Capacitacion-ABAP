*&---------------------------------------------------------------------*
*&  Include           ZAAEXAMEN_DF_SCR
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& SELECTION-SCREEN
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE text-b01.

SELECT-OPTIONS:

 s_ebeln FOR ekko-ebeln,
 s_bukrs FOR ekko-bukrs,
 s_bsart FOR ekko-bsart,
 s_lifnr FOR ekko-lifnr,
 s_matnr FOR ekpo-matnr,
 s_waers FOR ekko-waers.

SELECTION-SCREEN END OF BLOCK b01.