:: Export PostgreSQL database as csv and json file, and make database dump

:: Don't display commands to the user
@echo off

:: Export database as games.csv
:: "-U postgres" - using (default admin) database user postgres
:: "-d open_data_games" - using database called open_data_games
:: "-f export_csv.sql" - runs export_csv.sql script
:: (P.S. Password might, or might not be a '123'... who knows?)
echo Exporting CSV...
psql -U postgres -d open_data_games -f export_csv.sql

:: Export database as games.json
:: "-t" - ensure only raw data is outputed to json 
::        (no column headers, row counts, footer text)
:: "-A" - prevent adding unnecessary spaces
:: "-o games.json" - output as games.json file
echo Exporting JSON...
psql -U postgres -d open_data_games -t -A -f export_json.sql -o games.json

:: Create a full database backup dump
:: "--clean" - adds SQL DROP commands for all database objects, right before
::             the CREATE commands. Ensures correct overwrite during restoration
:: "--if-exists" - prevents restoration errors if some tables are missing
:: "-f dump.sql" - output is games_dump.sql
:: "--no-owner --no-privileges" - removes ownership, makes restoring easier for everyone
echo Creating DB dump...
pg_dump -U postgres -d open_data_games --clean --if-exists --no-owner --no-privileges -f games_dump.sql

echo All exports completed!
pause