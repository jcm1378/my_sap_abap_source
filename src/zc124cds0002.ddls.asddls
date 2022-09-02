@AbapCatalog.sqlViewName: 'ZC124CDS0002_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[C1] Flight and Booking View'
define view Zc124cds0002 as 
select a.carrid,
       a.connid,
       a.fldate,
       b.bookid,
       b.customid,
       b.custtype,
       case a.planetype
        when '747-400' then '@7T@'
        when 'A380-800' then '@AV@'
        else a.planetype
       end as planetype,
       a.price,
       a.currency,
       b.invoice

from sflight as a
inner join sbook as b
    on  a.mandt = b.mandt 
    and a.carrid = b.carrid
    and a.connid = b.connid
    and a.fldate = b.fldate
 where a.carrid = 'KA' 
    
