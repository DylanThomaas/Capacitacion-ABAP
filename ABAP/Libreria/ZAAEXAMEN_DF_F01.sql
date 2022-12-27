*&---------------------------------------------------------------------*
*&  Include           ZAAEXAMEN_DF_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  FORM GET_DATA
*&---------------------------------------------------------------------*

FORM get_data

     CHANGING
      ch_t_ekko  TYPE gty_t_ekko
      ch_t_ekpo  TYPE gty_t_ekpo
      ch_t_rseg  TYPE gty_t_rseg
      ch_t_rbkp  TYPE gty_t_rbkp
      ch_t_t161t TYPE gty_t_t161t
      ch_t_lfa1  TYPE gty_t_lfa1
      ch_t_makt  TYPE gty_t_makt
      ch_t_alv   TYPE gty_t_alv.

   SELECT ebeln bukrs bstyp bsart lifnr waers
         FROM ekko
         INTO TABLE ch_t_ekko
           WHERE ebeln IN s_ebeln.

    if ch_t_ekko is NOT INITIAL.

   SELECT ebeln ebelp matnr werks lgort menge meins netwr
       FROM ekpo
       INTO TABLE ch_t_ekpo
       FOR ALL ENTRIES IN ch_t_ekko
       WHERE ebeln EQ ch_t_ekko-ebeln.

    SORT ch_t_ekpo BY ebeln.

   if ch_t_rseg IS NOT INITIAL.

   SELECT ebeln ebelp belnr gjahr
       FROM rseg
       INTO TABLE ch_t_rseg
       FOR ALL ENTRIES IN ch_t_ekpo
       WHERE ebeln EQ ch_t_ekpo-ebeln
        AND ebelp EQ ch_t_ekpo-ebelp.

   SORT ch_t_rseg BY ebeln.

    if ch_t_rbkp IS NOT INITIAL.

   SELECT belnr gjahr blart xblnr lifnr
       FROM rbkp
       INTO TABLE ch_t_rbkp
       FOR ALL ENTRIES IN ch_t_rseg
       WHERE belnr EQ ch_t_rseg-belnr
         AND gjahr EQ ch_t_rseg-gjahr.

   SORT ch_t_rbkp BY belnr.

   SELECT name1 lifnr
     FROM lfa1
     INTO TABLE ch_t_lfa1
     FOR ALL ENTRIES IN ch_t_rbkp
     WHERE lfa1~lifnr EQ ch_t_rbkp-lifnr
     "WHERE lifnr EQ ch_t_rbkp-lifnr
       AND spras EQ sy-langu.

   SELECT bsart batxt
     FROM t161t
     INTO TABLE ch_t_t161t
     FOR ALL ENTRIES IN ch_t_ekko
     WHERE t161t~bsart = ch_t_ekko-bsart
        and spras = sy-langu.

    endif.
     endif.
    endif.
ENDFORM.                    " GET_DATA

*&---------------------------------------------------------------------*
*&      Form  PROCESS_DATA
*----------------------------------------------------------------------*
FORM process_data
  USING
     us_t_ekko  TYPE gty_t_ekko
     us_t_ekpo  TYPE gty_t_ekpo
     us_t_rseg  TYPE gty_t_rseg
     us_t_rbkp  TYPE gty_t_rbkp
     us_t_t161t TYPE gty_t_t161t
     us_t_lfa1  TYPE gty_t_lfa1
     us_t_makt  TYPE gty_t_makt

  CHANGING
     ch_t_alv   TYPE gty_t_alv.

  DATA:
     ls_ekko        TYPE gty_ekko,
     ls_ekpo        TYPE gty_ekpo,
     ls_rseg        TYPE gty_rseg,
     ls_rbkp        TYPE gty_rbkp,
     ls_t161t       TYPE gty_t161t,
     ls_lfa1        TYPE gty_lfa1,
     ls_makt        TYPE gty_makt.

  DATA:
        ls_alv TYPE gty_alv.

  LOOP AT us_t_ekko INTO ls_ekko.

    CLEAR ls_ekpo.

    "READ TABLE us_t_ekpo INTO ls_ekpo BINARY SEARCH
     " WITH KEY ebeln = ls_ekko-ebeln.


    LOOP AT us_t_ekpo INTO ls_ekpo
       WHERE ebeln EQ ls_ekpo-ebeln.

      CLEAR ls_rseg.

     " READ TABLE us_t_rseg INTO ls_rseg BINARY SEARCH
      "  WITH KEY ebeln = ls_ekpo-ebeln
       "          ebelp = ls_ekpo-ebelp.
       LOOP At us_T_rseg into ls_rseg
         where ebeln eq ls_ekpo-ebeln.

      CLEAR ls_rbkp.

      READ TABLE us_t_rbkp INTO ls_rbkp  BINARY SEARCH
        WITH KEY belnr = ls_rseg-belnr
                 gjahr = ls_rseg-gjahr.

      CLEAR ls_t161t.

      READ TABLE us_t_t161t INTO ls_t161t  BINARY SEARCH
        WITH KEY bsart = ls_ekko-bsart.

      CLEAR ls_lfa1.

      READ TABLE us_t_lfa1 INTO ls_lfa1 BINARY SEARCH
        WITH KEY lifnr = ls_rbkp-lifnr.

      CLEAR ls_makt.

      READ TABLE us_t_makt INTO ls_makt BINARY SEARCH
        WITH KEY matnr = ls_ekpo-matnr.




      CLEAR ls_alv.

      ls_alv-ebeln      = ls_ekko-ebeln.
      ls_alv-ebelp      = ls_ekpo-ebelp.
      ls_alv-bukrs      = ls_ekko-bukrs.
      ls_alv-bstyp      = ls_ekko-bstyp.
      ls_alv-bsart      = ls_ekko-bsart.
      ls_alv-bsart_desc = ls_t161t-bsart.
      ls_alv-lifnr      = ls_ekko-lifnr.
      ls_alv-lifnr_name = ls_lfa1-name1.
      ls_alv-matnr      = ls_ekpo-matnr.
      ls_alv-matnr_name = ls_makt-maktx.
      ls_alv-werks      = ls_ekpo-werks.
      ls_alv-lgort      = ls_ekpo-lgort.
      ls_alv-menge      = ls_ekpo-menge.
      ls_alv-meins      = ls_ekpo-meins.
      ls_alv-belnr      = ls_rbkp-belnr.
      ls_alv-gjahr      = ls_rbkp-gjahr.
      ls_alv-blart      = ls_rbkp-blart.
      ls_alv-xblnr      = ls_rbkp-xblnr.
      ls_alv-netwr      = ls_ekpo-netwr.
      ls_alv-waers      = ls_ekko-waers.

      APPEND ls_alv TO ch_t_alv.

       ENDLOOP.
    ENDLOOP.
  ENDLOOP.
ENDFORM.                    " PROCESS_DATA
*&---------------------------------------------------------------------*
*& FORM SHOW_REPORT
*&---------------------------------------------------------------------*
FORM show_report

  USING
      us_t_alv  TYPE gty_t_alv.

  DATA:
        ls_layout   TYPE slis_layout_alv,
        lt_fieldcat TYPE slis_t_fieldcat_alv,
        lt_sort     TYPE slis_t_sortinfo_alv.

  PERFORM set_layout
    CHANGING
      ls_layout.

  PERFORM set_fieldcat
    CHANGING
      lt_fieldcat[].

  PERFORM set_sort
    CHANGING
       lt_sort[].

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      is_layout                = ls_layout
      it_fieldcat              = lt_fieldcat
      i_callback_pf_status_set = 'SET_STATUS_ALV'
      i_callback_user_command  = 'ALV_USER_COMMAND'
      it_sort                  = lt_sort
    TABLES
      t_outtab                 = us_t_alv
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc NE 0.

    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

  ENDIF.

ENDFORM.                    " SHOW_REPORT
*&---------------------------------------------------------------------*
*&      Form  SET_LAYOUT
*----------------------------------------------------------------------*
FORM set_layout
  CHANGING
    ch_s_layout TYPE  slis_layout_alv.

  ch_s_layout-colwidth_optimize = abap_true.
  ch_s_layout-zebra = abap_true.
  ch_s_layout-box_fieldname = 'SELECCION'.


ENDFORM.                    " SET_LAYOUT
*&---------------------------------------------------------------------*
*&      Form  SET_SORT
*&---------------------------------------------------------------------*

FORM set_sort
  CHANGING
    ch_t_sort TYPE slis_t_sortinfo_alv.

  DATA:
     ls_sort TYPE LINE OF slis_t_sortinfo_alv.

  CLEAR ls_sort.

  ls_sort-tabname   = 'GT_ALV'.
  ls_sort-fieldname = 'EBELN'.
  ls_sort-up        = abap_true.
  ls_sort-subtot    = abap_true.

  APPEND ls_sort TO ch_t_sort.
ENDFORM.                    " SET_SORT
*&---------------------------------------------------------------------*
*&      Form  SET_FIELDCAT
*&---------------------------------------------------------------------*
FORM  set_fieldcat
  CHANGING
    ch_t_fieldcat TYPE slis_t_fieldcat_alv.

  PERFORM set_fieldcat_field
    USING
         'GT_ALV'
         'EBELN'
         'Pedido de Compra'(001)
         abap_true
         abap_true
    CHANGING
      ch_t_fieldcat[].

  PERFORM set_fieldcat_field
    USING
         'GT_ALV'
         'EBELP'
         'Posición'(002)
         abap_false
         abap_false
    CHANGING
      ch_t_fieldcat[].

  PERFORM set_fieldcat_field
    USING
         'GT_ALV'
         'BUKRS'
         'Sociedad'(003)
         abap_false
         abap_false
    CHANGING
      ch_t_fieldcat[].

  PERFORM set_fieldcat_field
    USING
         'GT_ALV'
         'BSTYP'
         'Tipo doc.'(004)
          abap_false
          abap_false
    CHANGING
      ch_t_fieldcat[].

  PERFORM set_fieldcat_field
    USING
         'GT_ALV'
         'BSART'
         'Clase de doc.'(006)
         abap_false
         abap_false
    CHANGING
      ch_t_fieldcat[].

  PERFORM set_fieldcat_field
    USING
         'GT_ALV'
         'BSART_DESC'
         'Desc. clase de doc.'(007)
         abap_false
         abap_false
    CHANGING
      ch_t_fieldcat[].

  PERFORM set_fieldcat_field
    USING
         'GT_ALV'
         'LIFNR'
         'Proveedor'(008)
         abap_true
         abap_false
    CHANGING
      ch_t_fieldcat[].

  PERFORM set_fieldcat_field
    USING
        'GT_ALV'
        'LIFNR_NAME'
        'Nombre del proveedro'(009)
        abap_false
        abap_false
   CHANGING
     ch_t_fieldcat[].


  PERFORM set_fieldcat_field
    USING
         'GT_ALV'
         'MATNR'
         'Material'(010)
         abap_true
         abap_false
    CHANGING
      ch_t_fieldcat[].

  PERFORM set_fieldcat_field
    USING
         'GT_ALV'
         'MATNR_NAME'
        'Descripción de material'(011)
        abap_false
        abap_false
   CHANGING
     ch_t_fieldcat[].


  PERFORM set_fieldcat_field
    USING
         'GT_ALV'
         'WERKS'
         'Centro'(012)
         abap_false
         abap_false
    CHANGING
      ch_t_fieldcat[].

  PERFORM set_fieldcat_field
    USING
         'GT_ALV'
         'LGORT'
         'Almacén'(013)
         abap_false
         abap_false
    CHANGING
      ch_t_fieldcat[].

  PERFORM set_fieldcat_field
    USING
         'GT_ALV'
         'MENGE'
         'Cantidad'(014)
         abap_false
         abap_false
    CHANGING
      ch_t_fieldcat[].

  PERFORM set_fieldcat_field
    USING
         'GT_ALV'
         'MEINS'
         'Unidad'(015)
         abap_false
         abap_false
    CHANGING
      ch_t_fieldcat[].

  PERFORM set_fieldcat_field
    USING
         'GT_ALV'
         'BELNR'
         'Factura'(016)
         abap_true
         abap_false
    CHANGING
      ch_t_fieldcat[].

  PERFORM set_fieldcat_field
    USING
         'GT_ALV'
         'GJAHR'
         'Ejercicio'(017)
         abap_false
         abap_false
    CHANGING
      ch_t_fieldcat[].

  PERFORM set_fieldcat_field
    USING
         'GT_ALV'
         'BLART'
         'Clase de Doc.'(018)
          abap_false
          abap_false
    CHANGING
      ch_t_fieldcat[].

  PERFORM set_fieldcat_field
    USING
         'GT_ALV'
         'XBLNR'
         'Nro Legal'(019)
         abap_false
         abap_false
    CHANGING
      ch_t_fieldcat[].

  PERFORM set_fieldcat_field
    USING
         'GT_ALV'
         'NETWR'
         'Importe'(020)
         abap_false
         abap_true
    CHANGING
      ch_t_fieldcat[].

  PERFORM set_fieldcat_field
    USING
         'GT_ALV'
         'WAERS'
         'Moneda'(021)
         abap_false
         abap_false
    CHANGING
      ch_t_fieldcat[].

ENDFORM.                    " SET_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  SET_FIELDCAT_FIELD
*----------------------------------------------------------------------*
FORM set_fieldcat_field

  USING
        us_v_tabname
        us_v_field_name
        us_v_text
        us_v_hotspot
        us_v_do_sum
  CHANGING
        ch_t_fieldcat TYPE slis_t_fieldcat_alv.

  DATA:
     ls_fieldcat TYPE LINE OF slis_t_fieldcat_alv.

  CLEAR ls_fieldcat.

  MOVE:
   us_v_tabname    TO ls_fieldcat-tabname,
   us_v_field_name TO ls_fieldcat-fieldname,
   us_v_text       TO ls_fieldcat-seltext_l,
   us_v_hotspot    TO ls_fieldcat-hotspot,
   us_v_do_sum     TO ls_fieldcat-do_sum.

  APPEND ls_fieldcat TO ch_t_fieldcat.


ENDFORM.                    " SET_FIELDCAT_FIELD

*&---------------------------------------------------------------------*
*& Form SET_STATUS_ALV
*&---------------------------------------------------------------------*
FORM set_status_alv
  USING
      us_t_extab TYPE slis_t_extab.
  SET PF-STATUS 'STATUS_ALV' EXCLUDING us_t_extab.

ENDFORM.                    "set_status_alv

*&---------------------------------------------------------------------*
*& Form ALV_USER_COMMAND
*&---------------------------------------------------------------------*
FORM alv_user_command
  USING
      us_v_ucomm TYPE sy-ucomm
      us_e_selfield TYPE slis_selfield.

  DATA:
        ls_alv   TYPE gty_alv.

  CASE us_v_ucomm.

    WHEN 'CSV'.

      PERFORM csv.

    WHEN 'DYNPRO'.

      PERFORM dynpro.

    WHEN 'SMARTFORM'.

      PERFORM smartform_file.

    WHEN '&IC1'.

      CASE us_e_selfield-fieldname.

        WHEN 'EBELN'.

          SET PARAMETER ID 'AUN' FIELD us_e_selfield-value.
          CALL TRANSACTION 'VA02' AND SKIP FIRST SCREEN.

        WHEN 'LIFNR'.

          SET PARAMETER ID 'LIF' FIELD us_e_selfield-value.
          CALL TRANSACTION 'XK02' AND SKIP FIRST SCREEN.

        WHEN 'BELNR'.

          SET PARAMETER ID 'AUN' FIELD us_e_selfield-value.
          CALL TRANSACTION 'FK08' AND SKIP FIRST SCREEN.

        WHEN 'MATNR'.

          SET PARAMETER ID 'MAT' FIELD us_e_selfield-value.
          CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.

      ENDCASE.

  ENDCASE.

ENDFORM.                    "alv_user_command


*&---------------------------------------------------------------------*
*&      Form  DESCARGAR_CSV
*&---------------------------------------------------------------------*
FORM descargar_csv.

  DATA:
     lt_file     TYPE gty_t_string,
     ls_alv      TYPE gty_alv,
     lv_string   TYPE string,
     lv_filename TYPE string,
     lv_filepath TYPE string,
     lv_fullpath TYPE string.

  LOOP AT gt_alv INTO ls_alv

    WHERE seleccion EQ abap_true.

    CLEAR lv_string.

    PERFORM format_file_out_csv
     USING
        ls_alv
     CHANGING
        lv_string.

    APPEND lv_string TO lt_file.

  ENDLOOP.

  CALL METHOD cl_gui_frontend_services=>file_save_dialog
    EXPORTING
      default_extension         = 'CSV'
      file_filter               = '*CSV'
    CHANGING
      filename                  = lv_filename
      path                      = lv_filepath
      fullpath                  = lv_fullpath
    EXCEPTIONS
      cntl_error                = 1
      error_no_gui              = 2
      not_supported_by_gui      = 3
      invalid_default_file_name = 4
      OTHERS                    = 5.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename = lv_fullpath
    TABLES
      data_tab = lt_file.

ENDFORM.                    " DESCARGAR_CSV

*&---------------------------------------------------------------------*
*&      Form  FORMAT_FILE_OUT_CSV
*&---------------------------------------------------------------------*
FORM format_file_out_csv
  USING
    us_s_alv TYPE gty_alv
  CHANGING
    ch_v_string TYPE string.

  DATA:
    lv_ebeln_aux TYPE c LENGTH 10,
    lv_ebelp_aux TYPE c LENGTH 5,
    lv_lifnr_aux TYPE c LENGTH 10,
    lv_matnr_aux TYPE c LENGTH 18,
    lv_menge_aux TYPE c LENGTH 10,
    lv_belnr_aux TYPE c LENGTH 10,
    lv_netwr_aux TYPE c LENGTH 15.

  lv_ebeln_aux = us_s_alv-ebeln.
  SHIFT lv_ebeln_aux LEFT DELETING LEADING '0'.

  lv_ebelp_aux = us_s_alv-ebelp.
  SHIFT lv_ebelp_aux LEFT DELETING LEADING '0'.

  lv_lifnr_aux = us_s_alv-lifnr.
  SHIFT lv_lifnr_aux LEFT DELETING LEADING '0'.

  lv_matnr_aux = us_s_alv-matnr.
  SHIFT lv_matnr_aux LEFT DELETING LEADING '0'.

  lv_belnr_aux = us_s_alv-belnr.
  SHIFT lv_belnr_aux LEFT DELETING LEADING '0'.

  lv_menge_aux = us_s_alv-menge.
  REPLACE '.' IN lv_menge_aux WITH ','.
  CONDENSE lv_menge_aux.

  lv_netwr_aux = us_s_alv-netwr.
  REPLACE '.' IN lv_netwr_aux WITH ','.
  CONDENSE lv_netwr_aux.

  CONCATENATE
             lv_ebeln_aux
             lv_ebelp_aux
             us_s_alv-bukrs
             us_s_alv-bstyp
             us_s_alv-bsart
             lv_lifnr_aux
             lv_matnr_aux
             us_s_alv-werks
             us_s_alv-lgort
             lv_menge_aux
             us_s_alv-meins
             lv_belnr_aux
             us_s_alv-gjahr
             us_s_alv-blart
             us_s_alv-xblnr
             lv_netwr_aux
             us_s_alv-waers
          INTO ch_v_string SEPARATED BY ';'.


ENDFORM.                    " FORMAT_FILE_OUT_CSV
*&---------------------------------------------------------------------*
*&      Form  CSV
*&---------------------------------------------------------------------*

FORM csv .

  DATA:
     ls_alv TYPE gty_alv,
     lv_linea TYPE i.

  lv_linea = 0.

  LOOP AT gt_alv INTO ls_alv
    WHERE seleccion EQ abap_true.

    ADD 1 TO lv_linea.

  ENDLOOP.

  IF lv_linea EQ 0.

    MESSAGE 'Seleccione por lo menos una linea' TYPE 'S' DISPLAY LIKE 'E'.

  ELSEIF lv_linea EQ 1.

    PERFORM descargar_csv.

    MESSAGE 'El archivo CSV se descargo correctamente' TYPE 'S' DISPLAY LIKE 'S'.

  ELSEIF lv_linea GT 1.

    PERFORM descargar_csv.

    MESSAGE 'Los archivs CSV se descargaron correctamente' TYPE 'S' DISPLAY LIKE 'S'.

  ENDIF.

ENDFORM.                    " CSV
*&---------------------------------------------------------------------*
*&      Form  DYNPRO
*&---------------------------------------------------------------------*
FORM dynpro.
  DATA:
       ls_alv       TYPE gty_alv,
       lv_linea     TYPE i.

  lv_linea = 0.

  LOOP AT gt_alv INTO ls_alv
    WHERE seleccion EQ abap_true.

    ADD 1 TO lv_linea.

  ENDLOOP.

  IF lv_linea EQ 0.

    MESSAGE 'Seleccione por lo menos una linea' TYPE 'S' DISPLAY LIKE 'E'.

  ELSEIF lv_linea GT 1.

    MESSAGE 'Solo puede seleccionar una linea' TYPE 'S' DISPLAY LIKE 'E'.

  ELSEIF lv_linea EQ 1.

    gv_init_9000 = abap_true.

    CALL SCREEN 9000 STARTING AT 30 1 ENDING AT 80 15.

  ENDIF.
ENDFORM.                    " DYNPRO
*&---------------------------------------------------------------------*
*&      Form  INIT_9000
*&---------------------------------------------------------------------*
FORM init_9000 .

  DATA:
    ls_alv TYPE gty_alv.

  IF gv_init_9000 EQ abap_true.

    gv_init_9000 = abap_false.

    LOOP AT gt_alv INTO ls_alv
      WHERE seleccion EQ abap_true.

      gs_9000b-ebelp = ls_alv-ebelp.
      gs_9000b-ebeln = ls_alv-ebeln.

    ENDLOOP.
  ENDIF.
ENDFORM.                    "init_9000

*&---------------------------------------------------------------------*
*&      Form  GUARDAR_9000
*&---------------------------------------------------------------------*
FORM guardar_9000.

  DATA:
     ls_zexamen_df  TYPE zexamen_df.

  ls_zexamen_df-ebeln       = gs_9000b-ebeln.
  ls_zexamen_df-ebelp       = gs_9000b-ebelp.

  MODIFY zexamen_df FROM ls_zexamen_df.

  IF sy-subrc EQ 0.

    COMMIT WORK.

    MESSAGE 'Datos guardados con éxito' TYPE 'S'.

  ELSE.

    MESSAGE 'No se logró guardar los datos' TYPE 'S'.

  ENDIF.
ENDFORM.                    " GUARDAR_9000

*&---------------------------------------------------------------------*
*&      Form  SMARTFORM_FILE
*&---------------------------------------------------------------------*
FORM smartform_file .

  DATA:
     ls_alv       TYPE gty_alv,
     lv_linea     TYPE i,
     ls_report TYPE gty_report.

  lv_linea = 0.

  LOOP AT gt_alv INTO ls_alv
     WHERE seleccion EQ abap_true.

    ADD 1 TO lv_linea.

  ENDLOOP.

  IF lv_linea EQ 0.

    MESSAGE 'Seleccione por lo menos una linea' TYPE 'S' DISPLAY LIKE 'E'.

  ELSEIF lv_linea GT 1.

    MESSAGE 'Solo puede seleccionar una linea' TYPE 'S' DISPLAY LIKE 'E'.

  ELSEIF lv_linea EQ 1.

    PERFORM get_seleccion
       CHANGING
          gt_report.

    READ TABLE gt_report INTO ls_report INDEX 1.

    PERFORM smartform_cabecera
      USING
         ls_report
      CHANGING
         s_cabecera.

    PERFORM smartform_posiciones
      USING
         ls_report
      CHANGING
         t_posiciones
         s_total.

    PERFORM smartform_print
      USING
        s_cabecera
        t_posiciones
        s_total.
  ENDIF.
ENDFORM.                    " SMARTFORM_FILE
*&---------------------------------------------------------------------*
*&      Form  SMARTFORM
*&---------------------------------------------------------------------*

FORM smartform_cabecera
  USING
     us_s_report TYPE gty_report
  CHANGING
      ch_s_cabecera TYPE zexamen_df_sf_cabecera.

  ch_s_cabecera-pedido    =  us_s_report-ebeln.
  ch_s_cabecera-sociedad  =  us_s_report-bukrs.
  ch_s_cabecera-clase_doc =  us_s_report-bsart.
  ch_s_cabecera-clase_des =  us_s_report-bsart_desc.
  ch_s_cabecera-proveedor =  us_s_report-lifnr.
  ch_s_cabecera-prov_des  =  us_s_report-lifnr_name.
ENDFORM.                    " SMARTFORM_CABECERA
*&---------------------------------------------------------------------*
*&      Form  SMARTFORM_POSICIONES
*----------------------------------------------------------------------*
FORM smartform_posiciones
  USING
    us_t_report TYPE gty_report
  CHANGING
    ch_t_posiciones TYPE zexamen_df_sf_posiciones_t
    ch_s_total      TYPE zexamen_df_sf_total.

  FIELD-SYMBOLS:
     <lfs_alv> TYPE gty_alv.

  DATA:
    ls_posiciones LIKE LINE OF ch_t_posiciones,
    ls_total TYPE gty_alv-netwr.

  CLEAR ls_posiciones.
  CLEAR ch_t_posiciones.

  LOOP AT gt_alv ASSIGNING <lfs_alv> WHERE ebeln EQ s_cabecera-pedido.

    ls_posiciones-material    = <lfs_alv>-matnr.
    ls_posiciones-descripcion = <lfs_alv>-bsart_desc.
    ls_posiciones-importe     = <lfs_alv>-netwr.
    ls_posiciones-moneda      = <lfs_alv>-waers.

    APPEND ls_posiciones TO ch_t_posiciones.

    ls_total = ls_total + ls_posiciones-importe.

  ENDLOOP.

  ch_s_total-total = ls_total.

ENDFORM.                    " SMARTFORM_POSICIONES

*&---------------------------------------------------------------------*
*&      Form  SMARTFORM_PRINT
*&---------------------------------------------------------------------*
FORM smartform_print
  USING
      us_s_cabecera   TYPE zexamen_df_sf_cabecera
      us_t_posiciones TYPE zexamen_df_sf_posiciones_t
      us_s_total      TYPE zexamen_df_sf_total.

  DATA:
      lv_fnam  TYPE rs38l_fnam.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZEXAMEN_DF'
    IMPORTING
      fm_name            = lv_fnam
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.


  CALL FUNCTION lv_fnam
    EXPORTING
      s_cabecera       = us_s_cabecera
      t_posiciones     = us_t_posiciones
      s_total          = us_s_total
    EXCEPTIONS
      formatting_error = 1
      internal_error   = 2
      send_error       = 3
      user_canceled    = 4
      OTHERS           = 5.

ENDFORM.                    " SMARTFORM_PRINT
*&---------------------------------------------------------------------*
*&      Form  GET_SELECCION
*&---------------------------------------------------------------------*
FORM get_seleccion
CHANGING
    ch_t_report TYPE gty_t_report.

  FIELD-SYMBOLS:
     <lfs_alv> TYPE gty_alv.
  DATA:
     ls_report TYPE gty_report.

  CLEAR ls_report.
  CLEAR ch_t_report.

  LOOP AT gt_alv ASSIGNING <lfs_alv> WHERE seleccion EQ abap_true.

    ls_report-ebeln      = <lfs_alv>-ebeln.
    ls_report-ebelp      = <lfs_alv>-ebelp.
    ls_report-bukrs      = <lfs_alv>-bukrs.
    ls_report-bstyp      = <lfs_alv>-bstyp.
    ls_report-bsart      = <lfs_alv>-bsart.
    ls_report-bsart_desc = <lfs_alv>-bsart_desc.
    ls_report-lifnr      = <lfs_alv>-lifnr.
    ls_report-lifnr_name = <lfs_alv>-lifnr_name.
    ls_report-matnr      = <lfs_alv>-matnr.
    ls_report-matnr_name = <lfs_alv>-matnr_name.
    ls_report-werks      = <lfs_alv>-werks.
    ls_report-lgort      = <lfs_alv>-lgort.
    ls_report-menge      = <lfs_alv>-menge.
    ls_report-meins      = <lfs_alv>-meins.
    ls_report-belnr      = <lfs_alv>-belnr.
    ls_report-gjahr      = <lfs_alv>-gjahr.
    ls_report-blart      = <lfs_alv>-blart.
    ls_report-xblnr      = <lfs_alv>-xblnr.
    ls_report-netwr      = <lfs_alv>-netwr.
    ls_report-waers      = <lfs_alv>-waers.

    APPEND ls_report  TO  ch_t_report[].
  ENDLOOP.
ENDFORM.                    " GET_SELECCION