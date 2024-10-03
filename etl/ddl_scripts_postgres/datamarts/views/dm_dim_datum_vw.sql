CREATE OR REPLACE VIEW dm.dim_datum_vw AS
    WITH cte_min_max_datum AS (
        SELECT
              MIN(Dim_Filmavond_Datum_key) AS Eerste_Filmavond_key
            , MAX(Dim_Filmavond_Datum_key) AS Laatste_Filmavond_key
        FROM dm.fact_filmavond
    )
        SELECT
			  ddd.dim_datum_key
			, ddd.date
			, ddd.year
			, ddd.month
			, ddd.monthname
			, ddd.day
			, ddd.dayofyear
			, ddd.weekdayname
			, ddd.calendarweek
			, ddd.formatteddate
			, ddd.quartal
			, ddd.yearquartal
			, ddd.yearmonth
			, ddd.yearcalendarweek
			, ddd.weekend
			, ddd.americanholiday
			, ddd.austrianholiday
			, ddd.canadianholiday
			, ddd.period
			, ddd.cwstart
			, ddd.cwend
			, ddd.monthstart
			, ddd.monthend
        FROM dm.dim_datum ddd
        JOIN cte_min_max_datum cmmd ON TRUE
        WHERE ddd.Dim_Datum_Key >= cmmd.Eerste_Filmavond_key
        AND ddd.Dim_Datum_Key <= cmmd.Laatste_Filmavond_key
;