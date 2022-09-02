class ZCL_ZC124_0001_DPC_EXT definition
  public
  inheriting from ZCL_ZC124_0001_DPC
  create public .

public section.
protected section.

  methods SFLIGHT24SET_CREATE_ENTITY
    redefinition .
  methods SFLIGHT24SET_DELETE_ENTITY
    redefinition .
  methods SFLIGHT24SET_GET_ENTITY
    redefinition .
  methods SFLIGHT24SET_UPDATE_ENTITY
    redefinition .
  methods SFLIGHT24SET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZC124_0001_DPC_EXT IMPLEMENTATION.


  method SFLIGHT24SET_CREATE_ENTITY.
**TRY.
*CALL METHOD SUPER->SFLIGHT24SET_CREATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
  endmethod.


  method SFLIGHT24SET_DELETE_ENTITY.
**TRY.
*CALL METHOD SUPER->SFLIGHT24SET_DELETE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
  endmethod.


  method SFLIGHT24SET_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->SFLIGHT24SET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
  endmethod.


  method SFLIGHT24SET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->SFLIGHT24SET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

select carrid connid fldate price currency planetype
  into CORRESPONDING FIELDS OF table et_entityset
  FROM sflight.
  endmethod.


  method SFLIGHT24SET_UPDATE_ENTITY.
**TRY.
*CALL METHOD SUPER->SFLIGHT24SET_UPDATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
  endmethod.
ENDCLASS.
