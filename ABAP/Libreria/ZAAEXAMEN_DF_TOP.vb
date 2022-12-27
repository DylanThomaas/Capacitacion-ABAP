*&---------------------------------------------------------------------*
*&  Include           ZAAEXAMEN_DF_TOP
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& TABLES
*&---------------------------------------------------------------------*

TABLES:
  ekko,
  ekpo,
  rbkp,
  rseg.

*&---------------------------------------------------------------------*
*& TYPE-POOLS
*&---------------------------------------------------------------------*
TYPE-POOLS:
  abap,
  slis.

*&---------------------------------------------------------------------*
*& TYPES
*&---------------------------------------------------------------------*
TYPES:
  BEGIN OF gty_ekko,
     ebeln TYPE ekko-ebeln, "Pedido de Compra
     bukrs TYPE ekko-bukrs, "Sociedad
     bstyp TYPE ekko-bstyp, "Tipo documento
     bsart TYPE ekko-bsart, "Clase de Documento
     lifnr TYPE ekko-lifnr, "Proveedor
     waers TYPE ekko-waers, "Moneda
  END OF gty_ekko,

 gty_t_ekko TYPE gty_ekko OCCURS 0.

TYPES:
  BEGIN OF gty_ekpo,
     ebeln TYPE ekpo-ebeln,   "Pedido de Compra conexion
     ebelp TYPE ekpo-ebelp,   "Posicion
     matnr TYPE ekpo-matnr,   "Material
     werks TYPE ekpo-werks,   "Centro
     lgort TYPE ekpo-lgort,   "Almacen
     menge TYPE ekpo-menge,   "Cantidad
     meins TYPE ekpo-meins,   "Unidad
     netwr TYPE ekpo-netwr,   "Importe
  END OF gty_ekpo,

  gty_t_ekpo TYPE STANDARD TABLE OF gty_ekpo.

TYPES:
  BEGIN OF gty_rseg,
    ebeln TYPE rseg-ebeln,  "Pedido de Compra conexion
    ebelp TYPE rseg-ebelp,  "Posicion conexion
    belnr TYPE rseg-belnr,  "Factura conexion
    gjahr TYPE rseg-gjahr,  "Ejercicio conexion
  END OF gty_rseg,

  gty_t_rseg TYPE STANDARD TABLE OF gty_rseg.

TYPES:
  BEGIN OF gty_rbkp,
    belnr TYPE rbkp-belnr,  "Factura
    gjahr TYPE rbkp-gjahr,  "Ejercicio
    blart TYPE rbkp-blart,  "Clase Documento
    xblnr TYPE rbkp-xblnr,  "Nro Legal
    lifnr TYPE rbkp-lifnr,  "Descripcion material
  END OF gty_rbkp,

  gty_t_rbkp TYPE STANDARD TABLE OF gty_rbkp.


TYPES:
  BEGIN OF gty_lfa1,
    name1 TYPE lfa1-name1, "Nombre de Proveedor
    lifnr TYPE lfa1-lifnr,
  END OF gty_lfa1,

  gty_t_lfa1 TYPE STANDARD TABLE OF gty_lfa1.

TYPES:
  BEGIN OF gty_makt,
   maktx TYPE makt-maktx, "Nombre del Material
   matnr TYPE makt-matnr,
  END OF gty_makt,

 gty_t_makt TYPE STANDARD TABLE OF gty_makt.

TYPES:
BEGIN OF gty_t161t,
  bsart TYPE t161t-bsart,
  batxt TYPE t161t-batxt, "Descripcion de la clase de Doc.
END OF gty_t161t,

  gty_t_t161t TYPE STANDARD TABLE OF gty_t161t.

TYPES:
  gty_t_string TYPE STANDARD TABLE OF string.

TYPES:
 BEGIN OF gty_alv,
    ebeln      TYPE ekko-ebeln,
    ebelp      TYPE ekpo-ebelp,
    bukrs      TYPE ekko-bukrs,
    bstyp      TYPE ekko-bstyp,
    bsart      TYPE ekko-bsart,
    bsart_desc TYPE t161t-batxt,
    lifnr      TYPE ekko-lifnr,
    lifnr_name TYPE lfa1-name1,
    matnr      TYPE ekpo-matnr,
    matnr_name TYPE makt-maktx,
    werks      TYPE ekpo-werks,
    lgort      TYPE ekpo-lgort,
    menge      TYPE ekpo-menge,
    meins      TYPE ekpo-meins,
    belnr      TYPE rbkp-belnr,
    gjahr      TYPE rbkp-gjahr,
    blart      TYPE rbkp-blart,
    xblnr      TYPE rbkp-xblnr,
    netwr      TYPE ekpo-netwr,
    waers      TYPE ekko-waers,
    seleccion  TYPE abap_bool,
 END OF gty_alv,

  gty_t_alv TYPE STANDARD TABLE OF gty_alv.


TYPES:
  BEGIN OF gty_9000,

    ebeln       TYPE ekko-ebeln,"zexamen_df-ebeln,
    ebelp       TYPE rseg-ebelp,"zexamen_df-ebelp,
    observacion TYPE string,"zexamen_df-observacion,

  END OF gty_9000.


TYPES:
  BEGIN OF s_9000,

    ebeln       TYPE ekko-ebeln,
    ebelp       TYPE ekpo-ebelp,""""""""""""""""2
    observacion TYPE string,

  END OF s_9000.

  TYPES:
  BEGIN OF gty_report,
    ebeln      TYPE ekko-ebeln,
    ebelp      TYPE ekpo-ebelp,
    bukrs      TYPE ekko-bukrs,
    bstyp      TYPE ekko-bstyp,
    bsart      TYPE ekko-bsart,
    bsart_desc TYPE t161t-batxt,
    lifnr      TYPE ekko-lifnr,
    lifnr_name TYPE lfa1-name1,
    matnr      TYPE ekpo-matnr,
    matnr_name TYPE makt-maktx,
    werks      TYPE ekpo-werks,
    lgort      TYPE ekpo-lgort,
    menge      TYPE ekpo-menge,
    meins      TYPE ekpo-meins,
    belnr      TYPE rbkp-belnr,
    gjahr      TYPE rbkp-gjahr,
    blart      TYPE rbkp-blart,
    xblnr      TYPE rbkp-xblnr,
    netwr      TYPE ekpo-netwr,
    waers      TYPE ekko-waers,
  END OF gty_report,

gty_t_report TYPE STANDARD TABLE OF gty_report.


*&---------- -----------------------------------------------------------*
*& DATA
*&---------------------------------------------------------------------*
DATA:
    gt_ekko      TYPE gty_t_ekko,
    gt_ekpo      TYPE gty_t_ekpo,
    gt_rbkp      TYPE gty_t_rbkp,
    gt_rseg      TYPE gty_t_rseg,
    gt_lfa1      TYPE gty_t_lfa1,
    gt_t161t     TYPE gty_t_t161t,
    gt_makt      TYPE gty_t_makt,
    gt_alv       TYPE gty_t_alv,
    gt_report    TYPE gty_t_report.

DATA:
    gv_name      TYPE string,
    gs_9000      TYPE gty_9000,
    gs_9000b     TYPE s_9000,
    gv_init_9000 TYPE abap_bool.

DATA:
 s_cabecera     TYPE zexamen_df_sf_cabecera,
 t_posiciones   TYPE zexamen_df_sf_posiciones_t,
 s_total        TYPE zexamen_df_sf_total.