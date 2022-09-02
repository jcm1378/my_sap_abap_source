@AbapCatalog.sqlViewName: 'ZC124CDS0001_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[C1] Airline Flight CDS view'
define view ZC124CDS0001 as select from scarr
inner join sflight
    on scarr.mandt = sflight.mandt
    and scarr.carrid = sflight.carrid     
{
   key scarr.carrid,
   key sflight.connid,
   key sflight.fldate,
   scarr.carrname,
   sflight.paymentsum,
   scarr.currcode,
   sflight.price,
   sflight.planetype    
}
