
-- PUNTO 1
drop table if exists eta;

create temporary table eta as(
select cliente.id_cliente,
left((current_date-cliente.data_nascita),2) as eta
from banca.cliente cliente
);

-- PUNTO 2 e 3
drop table if exists num_trans;

create temporary table num_trans as(
select cliente.id_cliente,
count(case when (tipot.segno='-') then 1 end) as tot_transazioni_uscita,
count(case when (tipot.segno='+') then 1 end) as tot_transazioni_entrata
from banca.cliente cliente
left join banca.conto conto on cliente.id_cliente = conto.id_cliente
left join transazioni trans on  trans.id_conto = conto.id_conto
left join tipo_transazione tipot on  trans.id_tipo_trans = tipot.id_tipo_transazione
group by 1
);

-- PUNTO 4 e 5
drop table if exists tot_trans;

create temporary table tot_trans as(
select cliente.id_cliente,
round(sum(case when (trans.importo <0) then trans.importo end),2) as tot_importi_uscite,
round(sum(case when (trans.importo >0) then trans.importo end),2) as tot_importi_entrate
from banca.cliente cliente
left join banca.conto conto on cliente.id_cliente = conto.id_cliente
left join transazioni trans on  trans.id_conto = conto.id_conto
left join tipo_transazione tipot on  trans.id_tipo_trans = tipot.id_tipo_transazione
group by 1
);

-- PUNTO 6
drop table if exists num_conti;

create temporary table num_conti as(
select cliente.id_cliente,
    count(distinct conto.id_conto) as num_conti

from banca.cliente cliente
left join banca.conto conto on cliente.id_cliente = conto.id_cliente
left join transazioni trans on  trans.id_conto = conto.id_conto
left join tipo_transazione tipot on  trans.id_tipo_trans = tipot.id_tipo_transazione
group by 1
);


-- PUNTO 7
drop table if exists tipologia_conto;

create temporary table tipologia_conto as(
select id_cliente,
 sum(case when tipoc.desc_tipo_conto='Conto Privati' then 1 else 0 end) as conto_priv,
 sum(case when tipoc.desc_tipo_conto='Conto Base' then 1 else 0 end) as conto_base,
 sum(case when tipoc.desc_tipo_conto='Conto Business' then 1 else 0 end) as conto_business,
 sum(case when tipoc.desc_tipo_conto='Conto Famiglie' then 1 else 0 end) as conto_famiglie
from banca.tipo_conto tipoc
left join banca.conto  c
on tipoc.id_tipo_conto = c.id_tipo_conto
group by 1
);



-- PUNTO 8
drop table if exists tipologia_trans_uscita;

create temporary table tipologia_trans_uscita as(
select cliente.id_cliente,
 sum(case when tipot.desc_tipo_trans='Acquisto su Amazon' then 1 else 0 end) as uscita_amazon,
 sum(case when tipot.desc_tipo_trans='Rata mutuo' then 1 else 0 end) as uscita_mutuo,
 sum(case when tipot.desc_tipo_trans='Hotel' then 1 else 0 end) as uscita_hotel,
 sum(case when tipot.desc_tipo_trans='Biglietto aereo' then 1 else 0 end) as uscita_aereo,
 sum(case when tipot.desc_tipo_trans='Supermercato' then 1 else 0 end) as uscita_supermercato
from banca.cliente cliente
left join banca.conto conto on cliente.id_cliente = conto.id_cliente
left join transazioni trans on  trans.id_conto = conto.id_conto
left join tipo_transazione tipot on  trans.id_tipo_trans = tipot.id_tipo_transazione
group by 1
);

-- PUNTO 9
drop table if exists tipologia_trans_entrata;

create temporary table tipologia_trans_entrata as(
select cliente.id_cliente,
 sum(case when tipot.desc_tipo_trans='Stipendio' then 1 else 0 end) as entrata_stipendio,
 sum(case when tipot.desc_tipo_trans='Pensione' then 1 else 0 end) as entrata_pensione,
 sum(case when tipot.desc_tipo_trans='Dividendi' then 1 else 0 end) as entrata_dividendi
from banca.cliente cliente
left join banca.conto conto on cliente.id_cliente = conto.id_cliente
left join transazioni trans on  trans.id_conto = conto.id_conto
left join tipo_transazione tipot on  trans.id_tipo_trans = tipot.id_tipo_transazione
group by 1
);

-- PUNTO 10
drop table if exists importo_trans_uscite;

create temporary table importo_trans_uscite as(
select 
	cliente.id_cliente,
	round(sum(case when (trans.importo <0 and tipoc.desc_tipo_conto = 'Conto Privati') then trans.importo end),2) as tot_uscite_cprivati,
    round(sum(case when (trans.importo <0 and tipoc.desc_tipo_conto = 'Conto Business') then trans.importo end),2) as tot_uscite_cbusiness,
	round(sum(case when (trans.importo <0 and tipoc.desc_tipo_conto = 'Conto Base') then trans.importo end),2) as tot_uscite_cbase,
	round(sum(case when (trans.importo <0 and tipoc.desc_tipo_conto = 'Conto Famiglie') then trans.importo end),2) as tot_uscite_cfamiglie
from banca.cliente cliente
left join banca.conto conto on cliente.id_cliente = conto.id_cliente
left join transazioni trans on  trans.id_conto = conto.id_conto
left join tipo_transazione tipot on  trans.id_tipo_trans = tipot.id_tipo_transazione
left join tipo_conto tipoc on tipoc.id_tipo_conto = conto.id_tipo_conto
group by 1
);

-- PUNTO 11
drop table if exists importo_trans_entrate;

create temporary table importo_trans_entrate as(
select 
	cliente.id_cliente,
	round(sum(case when (trans.importo >0 and tipoc.desc_tipo_conto = 'Conto Privati') then trans.importo end),2) as tot_entrate_cprivati,
    round(sum(case when (trans.importo >0 and tipoc.desc_tipo_conto = 'Conto Business') then trans.importo end),2) as tot_entrate_cbusiness,
	round(sum(case when (trans.importo >0 and tipoc.desc_tipo_conto = 'Conto Base') then trans.importo end),2) as tot_entrate_cbase,
	round(sum(case when (trans.importo >0 and tipoc.desc_tipo_conto = 'Conto Famiglie') then trans.importo end),2) as tot_entrate_cfamiglie
from banca.cliente cliente
left join banca.conto conto on cliente.id_cliente = conto.id_cliente
left join transazioni trans on  trans.id_conto = conto.id_conto
left join tipo_transazione tipot on  trans.id_tipo_trans = tipot.id_tipo_transazione
left join tipo_conto tipoc on tipoc.id_tipo_conto = conto.id_tipo_conto
group by 1
);


-- richiamo temporary

select 
eta.id_cliente, 
eta, 
tot_transazioni_uscita, tot_transazioni_entrata,
tot_importi_uscite, tot_importi_entrate,
num_conti,
conto_priv, conto_base, conto_business, conto_famiglie,
uscita_amazon, uscita_mutuo, uscita_hotel, uscita_aereo, uscita_supermercato,
entrata_stipendio, entrata_pensione, entrata_dividendi,
tot_uscite_cprivati, tot_uscite_cbusiness, tot_uscite_cbase, tot_uscite_cfamiglie,
tot_entrate_cprivati, tot_entrate_cbusiness, tot_entrate_cbase, tot_entrate_cfamiglie
from eta -- punto 1
left join num_trans
on eta.id_cliente=num_trans.id_cliente -- punto 2 e 3
left join tot_trans
on num_trans.id_cliente = tot_trans.id_cliente  -- punto 4 e 5
left join num_conti
on  tot_trans.id_cliente = num_conti.id_cliente -- punto 6
left join tipologia_conto
on num_conti.id_cliente = tipologia_conto.id_cliente -- punto 7
left join tipologia_trans_uscita
on tipologia_conto.id_cliente = tipologia_trans_uscita.id_cliente  -- punto 8
left join tipologia_trans_entrata
on  tipologia_trans_uscita.id_cliente = tipologia_trans_entrata.id_cliente  -- punto 9
left join importo_trans_uscite
on  importo_trans_uscite.id_cliente = tipologia_trans_entrata.id_cliente  -- punto 10
left join importo_trans_entrate
on  importo_trans_entrate.id_cliente = tipologia_trans_entrata.id_cliente  -- punto 11


