-- https://medium.com/@jeffclark_61103/creating-a-date-dimension-in-sqlite-aa6f52450971
-- Create a table to permanently store the output
CREATE TABLE IF NOT EXISTS dm.dim_datum AS
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
      strftime('%Y%m%d', CalendarDateInterval) AS Dim_Datum_Key
    , CalendarDateInterval AS Datum
    , strftime('%w',CalendarDateInterval) +1 AS	DagNummer
    , CASE CAST (strftime('%w', CalendarDateInterval) AS integer)
	  	WHEN 0 THEN 'Zondag'
	    WHEN 1 THEN 'Maandag'
	    WHEN 2 THEN 'Dinsdag'
	    WHEN 3 THEN 'Woensdag'
	    WHEN 4 THEN 'Donderdag'
	    WHEN 5 THEN 'Vrijdag'
	    WHEN 6 THEN 'Zaterdag' END AS Dag
    , CASE
	  	WHEN strftime('%w', CalendarDateInterval) = '0' THEN 'Zo'
	    WHEN strftime('%w', CalendarDateInterval) = '1' THEN 'Ma'
	    WHEN strftime('%w', CalendarDateInterval) = '2' THEN 'Di'
	    WHEN strftime('%w', CalendarDateInterval) = '3' THEN 'Wo'
	    WHEN strftime('%w', CalendarDateInterval) = '4' THEN 'Do'
	    WHEN strftime('%w', CalendarDateInterval) = '5' THEN 'Vr'
	    WHEN strftime('%w', CalendarDateInterval) = '6' THEN 'Za' END AS DagAfkorting
    , strftime('%d',CalendarDateInterval) AS DagVanDeMaand
    , strftime('%m',CalendarDateInterval) AS MaandNummer
    , strftime('%Y',CalendarDateInterval) AS Jaar
    , CASE CAST (strftime('%w', CalendarDateInterval) AS integer)
	    WHEN 0 THEN 1
	    WHEN 6 THEN 1
	    ELSE 0 END AS IsWeekend
	, CASE CAST (strftime('%w', CalendarDateInterval) AS integer)
	    WHEN 0 THEN 0
	    WHEN 6 THEN 0
	    ELSE 1 END AS IsWeekdag
	, CASE strftime('%m', date(CalendarDateInterval))
        WHEN '01' THEN 'Januari'
        WHEN '02' THEN 'Februari'
        WHEN '03' THEN 'Maart'
        WHEN '04' THEN 'April'
        WHEN '05' THEN 'Mei'
        WHEN '06' THEN 'Juni'
        WHEN '07' THEN 'Juli'
        WHEN '08' THEN 'Augustus'
        WHEN '09' THEN 'September'
        WHEN '10' THEN 'Oktober'
        WHEN '11' THEN 'November'
        WHEN '12' THEN 'December' ELSE '' END AS Maand
   , CASE
		  -- Nieuwjaarsdag
		  WHEN strftime('%d',CalendarDateInterval) = '01' AND strftime('%m',CalendarDateInterval) = '01' THEN 1
		  -- Koningsdag: Als als 27-4 een zondag is, dan valt koningsdag op 26-4 (zaterdag)
		  WHEN strftime('%m',CalendarDateInterval) = '04' AND strftime('%d',CalendarDateInterval) = '27' AND strftime('%w', CalendarDateInterval) <> '0' THEN 1
		  WHEN strftime('%m',CalendarDateInterval) = '04' AND strftime('%d',CalendarDateInterval) = '27' AND strftime('%w', CalendarDateInterval) = '6' THEN 1
		  -- Bevrijdingsdag
		  WHEN strftime('%m',CalendarDateInterval) = '05' AND strftime('%d',CalendarDateInterval) = '05' THEN 1
		  -- Kerstdagen
		  WHEN strftime('%m',CalendarDateInterval) = '12' AND strftime('%d',CalendarDateInterval) = '25' THEN 1
		  WHEN strftime('%m',CalendarDateInterval) = '12' AND strftime('%d',CalendarDateInterval) = '26' THEN 1
		  ELSE 0
		  END AS IsFeestdag
	, CASE
	  	  WHEN strftime('%d',CalendarDateInterval) = '01' AND strftime('%m',CalendarDateInterval) = '01' THEN 'Nieuwjaarsdag'
	  	  WHEN strftime('%m',CalendarDateInterval) = '04' AND strftime('%d',CalendarDateInterval) = '27' AND strftime('%w', CalendarDateInterval) <> '0' THEN 'Koningsdag'
	  	  WHEN strftime('%m',CalendarDateInterval) = '04' AND strftime('%d',CalendarDateInterval) = '27' AND strftime('%w', CalendarDateInterval) = '6' THEN 'Koningsdag'
	  	  -- Bevrijdingsdag: Iedere 5 jaar is een Lustrumjaar
	  	  WHEN strftime('%m',CalendarDateInterval) = '05' AND strftime('%d',CalendarDateInterval) = '05' THEN 'Bevrijdingsdag'
	  	  -- Kerstdagen
		  WHEN strftime('%m',CalendarDateInterval) = '12' AND strftime('%d',CalendarDateInterval) = '25' THEN '1e Kerstdag'
		  WHEN strftime('%m',CalendarDateInterval) = '12' AND strftime('%d',CalendarDateInterval) = '26' THEN '2e Kerstdag'
		  ELSE ''
	  END AS  Toelichting
FROM rDateDimensionMinute;