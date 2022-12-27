*&---------------------------------------------------------------------*
*& Report  ZAAEXAMEN_DF
*&---------------------------------------------------------------------*

REPORT  zaaexamen_df.


INCLUDE zaaexamen_df_top.
INCLUDE zaaexamen_df_scr.
INCLUDE ZAAEXAMEN_DF_F01.
INCLUDE ZAAEXAMEN_DF_DYN.

*&---------------------------------------------------------------------*
*& END OF SELECTION
*&---------------------------------------------------------------------*
END-OF-SELECTION.

  PERFORM get_data
    CHANGING
      gt_ekko[]
      gt_ekpo[]
      gt_rseg[]
      gt_rbkp[]
      gt_t161t[]
      gt_lfa1[]
      gt_makt[]
      gt_alv[].

  PERFORM process_data
    USING
      gt_ekko[]
      gt_ekpo[]
      gt_rseg[]
      gt_rbkp[]
      gt_t161t[]
      gt_lfa1[]
      gt_makt[]
    CHANGING
      gt_alv[].

  PERFORM show_report
    USING
      gt_alv[].