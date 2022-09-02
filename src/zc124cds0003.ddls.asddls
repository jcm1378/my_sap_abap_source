@AbapCatalog.sqlViewName: 'ZC124CDS0003_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[C1] Fake Standard table'
define view ZC124CDS0003 as select from ztc1240003 
{
    bukrs,
    belnr,
    gjahr,
    buzei,
    bschl    
}
