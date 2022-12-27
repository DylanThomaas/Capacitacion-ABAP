*&---------------------------------------------------------------------*
*&  Include           ZAAEXAMEN_DF_DYN
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*

MODULE status_9000 OUTPUT.

  SET PF-STATUS 'STATUS_9000'.
  SET TITLEBAR 'TITLE_9000'.

ENDMODULE.                 " STATUS_9000  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_9000 INPUT.

  CASE sy-ucomm.

    WHEN 'VOLVER'.

      LEAVE TO SCREEN 0.

    WHEN 'GUARDAR'.

      PERFORM guardar_9000.

      LEAVE TO SCREEN 0.

  ENDCASE.

  CLEAR sy-ucomm.

ENDMODULE.                 " USER_COMMAND_9000  INPUT

*&---------------------------------------------------------------------*
*&      Module  INIT_9000  OUTPUT
*&---------------------------------------------------------------------*
MODULE init_9000 OUTPUT.
  PERFORM init_9000.
ENDMODULE.                 " INIT_9000  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_EXIT_COMMAND  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_exit_command INPUT.
  CASE sy-ucomm.

    WHEN 'BACK' OR 'EXIT' OR 'CANCEL' OR 'VOLVER'.

      LEAVE TO SCREEN 0.

  ENDCASE.

  CLEAR sy-ucomm.
ENDMODULE.                 " USER_COMMAND_EXIT_COMMAND  INPUT