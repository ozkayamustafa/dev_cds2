@AbapCatalog.sqlViewName: 'ZMO_001_V_CDS2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Fatura tutarları'
define view zmo_001_cds2_ddl as select from zmo_001_cds1_ddl as cds2
  inner join vbrk on vbrk.vbeln = cds2.vbeln 
{
   cds2.vbeln,
   sum(cds2.conversion_netwr) as Toplam_Net_Deger,
   cds2.kunnrAD,
   count(*) as Toplam_Fatura_Adet,
   division(cast(sum(cds2.conversion_netwr) as abap.curr( 12, 2 )), cast(count(*) as abap.int1), 2 ) as Ortalama_Deger,
   substring(cds2.fkdat,1,4) as Fatura_Yil,
   substring(cds2.fkdat,5,2) as Fatura_Ay,
   substring(cds2.fkdat,7,2) as Fatura_Gun,
   substring(vbrk.inco2_l,1,3) as incoterm_yer
}
group by cds2.vbeln,
         cds2.kunnrAD,
         cds2.fkdat,
         vbrk.inco2_l
