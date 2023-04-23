-- https://medium.com/@jeffclark_61103/creating-a-date-dimension-in-sqlite-aa6f52450971
-- Create a table to permanently store the output
CREATE TABLE IF NOT EXISTS dm_dim_datum AS
-- Initiate the recursive loop
WITH RECURSIVE
-- Define a CTE to hold the recursive output
rDateDimensionMinute (CalendarDateInterval)
AS
    (
        -- The anchor of the recursion is the start date of the date dimension
        SELECT datetime('2021-03-06 00:00:00')
        UNION ALL
        -- The recursive query increments the time interval by the desired amount
        -- This can be any time increment (monthly, daily, hours, minutes)
        SELECT datetime(CalendarDateInterval, '+24 hour') FROM rDateDimensionMinute
        -- Set the number of recursions
        -- Functionally, this is the number of periods in the date dimension
        LIMIT 100000
    )
-- Output the result set to the permanent table
SELECT
      strftime('%Y%m%d', CalendarDateInterval) as Dim_Datum_Key
    , CalendarDateInterval as Datum
    , strftime('%w',CalendarDateInterval) +1 as	DagNummer
    , case cast (strftime('%w', CalendarDateInterval) as integer)
	  	when 0 then 'Zondag'
	    when 1 then 'Maandag'
	    when 2 then 'Dinsdag'
	    when 3 then 'Woensdag'
	    when 4 then 'Donderdag'
	    when 5 then 'Vrijdag'
	    when 6 then 'Zaterdag' end as Dag
    , CASE
	  	WHEN strftime('%w', CalendarDateInterval) = '0' THEN 'Zo'
	    WHEN strftime('%w', CalendarDateInterval) = '1' THEN 'Ma'
	    WHEN strftime('%w', CalendarDateInterval) = '2' THEN 'Di'
	    WHEN strftime('%w', CalendarDateInterval) = '3' THEN 'Wo'
	    WHEN strftime('%w', CalendarDateInterval) = '4' THEN 'Do'
	    WHEN strftime('%w', CalendarDateInterval) = '5' THEN 'Vr'
	    WHEN strftime('%w', CalendarDateInterval) = '6' THEN 'Za' end as DagAfkorting
    , strftime('%d',CalendarDateInterval) as DagVanDeMaand
    , strftime('%m',CalendarDateInterval) as MaandNummer
    , strftime('%Y',CalendarDateInterval) as Jaar
    , case cast (strftime('%w', CalendarDateInterval) as integer)
	    when 0 then 1
	    when 6 then 1
	    else 0 end as IsWeekend
	, case cast (strftime('%w', CalendarDateInterval) as integer)
	    when 0 then 0
	    when 6 then 0
	    else 1 end as IsWeekdag
	, case strftime('%m', date(CalendarDateInterval))
        when '01' then 'Januari'
        when '02' then 'Februari'
        when '03' then 'Maart'
        when '04' then 'April'
        when '05' then 'Mei'
        when '06' then 'Juni'
        when '07' then 'Juli'
        when '08' then 'Augustus'
        when '09' then 'September'
        when '10' then 'Oktober'
        when '11' then 'November'
        when '12' then 'December' else '' end as Maand
   , case
		  -- Nieuwjaarsdag
		  when strftime('%d',CalendarDateInterval) = '01' and strftime('%m',CalendarDateInterval) = '01' then 1
		  -- Koningsdag: Als als 27-4 een zondag is, dan valt koningsdag op 26-4 (zaterdag)
		  when strftime('%m',CalendarDateInterval) = '04' and strftime('%d',CalendarDateInterval) = '27' and strftime('%w', CalendarDateInterval) <> '0' then 1
		  when strftime('%m',CalendarDateInterval) = '04' and strftime('%d',CalendarDateInterval) = '27' and strftime('%w', CalendarDateInterval) = '6' then 1
		  -- Bevrijdingsdag
		  when strftime('%m',CalendarDateInterval) = '05' and strftime('%d',CalendarDateInterval) = '05' then 1
		  -- Kerstdagen
		  when strftime('%m',CalendarDateInterval) = '12' and strftime('%d',CalendarDateInterval) = '25' then 1
		  when strftime('%m',CalendarDateInterval) = '12' and strftime('%d',CalendarDateInterval) = '26' then 1
		  else 0
		  end as IsFeestdag
	, case
	  	  when strftime('%d',CalendarDateInterval) = '01' and strftime('%m',CalendarDateInterval) = '01' then 'Nieuwjaarsdag'
	  	  when strftime('%m',CalendarDateInterval) = '04' and strftime('%d',CalendarDateInterval) = '27' and strftime('%w', CalendarDateInterval) <> '0' then 'Koningsdag'
	  	  when strftime('%m',CalendarDateInterval) = '04' and strftime('%d',CalendarDateInterval) = '27' and strftime('%w', CalendarDateInterval) = '6' then 'Koningsdag'
	  	  -- Bevrijdingsdag: Iedere 5 jaar is een Lustrumjaar
	  	  when strftime('%m',CalendarDateInterval) = '05' and strftime('%d',CalendarDateInterval) = '05' then 'Bevrijdingsdag'
	  	  -- Kerstdagen
		  when strftime('%m',CalendarDateInterval) = '12' and strftime('%d',CalendarDateInterval) = '25' then '1e Kerstdag'
		  when strftime('%m',CalendarDateInterval) = '12' and strftime('%d',CalendarDateInterval) = '26' then '2e Kerstdag'
		  else ''
	  end as  Toelichting
FROM rDateDimensionMinute;