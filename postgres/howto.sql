st_geogfromtext('SRID=4326;POINT(-77 38)'); #create a geography from POINT(-77 38). can leave out SRID=4326 and postgis will assume 4326.  good practice to make it explicit though.
