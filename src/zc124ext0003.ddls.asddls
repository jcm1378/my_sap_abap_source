@AbapCatalog.sqlViewAppendName: 'ZC124EXT0003_V'
@EndUserText.label: '[C1] Fake Standard table Extend'
extend view ZC124CDS0003 with Zc124EXT0003 
{
    ztc1240003.zzsaknr,
    ztc1240003.zzkostl,
    ztc1240003.zzshkzg,
    ztc1240003.zzlgort
}
