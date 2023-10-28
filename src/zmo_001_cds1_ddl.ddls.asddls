@AbapCatalog.sqlViewName: 'ZMO_001_V_CDS1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Fatura Kalem bilgileri'
define view zmo_001_cds1_ddl as select from vbrp
    inner join vbrk on vbrk.vbeln = vbrp.vbeln
    inner join mara on mara.matnr = vbrp.matnr
    left outer join vbak on vbak.vbeln = vbrp.aubel
    left outer join kna1 on kna1.kunnr = vbak.kunnr
    left outer join makt on makt.matnr = mara.matnr
                         and makt.spras = $session.system_language
{
    
    key vbrp.vbeln,
    key vbrp.posnr,
    vbrp.aubel,
    vbrp.aupos,
    vbak.kunnr,
    concat_with_space(kna1.name1,kna1.name2,1) as kunnrAD,
    left(vbak.kunnr,3) as left_kunnr,
    currency_conversion(
        amount             => vbrp.netwr, //Belge para birimi cinsinden faturalama kalemi net değeri
        source_currency    => vbrk.waerk, //SD belgesi para birimi
        target_currency    => cast('EUR' as abap.cuky),
        exchange_rate_date => vbrk.fkdat // Faturalama tarih
      )        as conversion_netwr,
    
    length(mara.matnr) as matnr_lenght,
    case
        when vbrk.fkart = 'FAS' then 'Peşinat talebi iptali'
        when vbrk.fkart = 'FAZ' then 'Peşinat talebi'
        else 
            'Fatura'
        end as Faturalama_tur,
        
        
      vbrk.fkdat 
        
     
    
}
