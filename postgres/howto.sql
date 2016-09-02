st_geogfromtext('SRID=4326;POINT(-77 38)'); --create a geography from POINT(-77 38). can leave out SRID=4326 and postgis will assume 4326.  good practice to make it explicit though.
create index idx_t_geom on t using gist(geom) --create a spatial index on table t and column geom

-- return the type of geometry stored in column g. either works, there are some minor differences between the two
geometrytype(g)
st_geometrytype(g)

explain sql_statement --show the query plan for sql_statement

select version() --check the version 
select postgis_full_version() --check the postgis version

select n, (st_dump(g)).geom as g from t --from table t with column n, break column g which has type multi-polygon into rows of single polygons

-- create g as coordinate system 4326 and then transform to 2163
st_geomfromtext(POINT(-77 38),4326) as g 
st_transform(g, 2163)

st_dwithin(points.geom, roads.geom, 10) --see all points within 10 meters of a road

select st_point(1,2) as mypoint --create mypoint at 1,2 

select st_geomfromtext('POINT(-77.036548 38.895108')', 4326) --create a lon/lat point from WKT, first point is lon, second is lat

st_astext('010100E6...') ---> POINT(-77 38) (does not include SRID)
st_asewkt('010100E6...') ---> SRID=4326;POINT(-77 38) (includes SRID)






