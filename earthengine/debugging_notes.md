Earth Engine Debugging, presentation by Noel
https://earthoutreachonair.withgoogle.com/events/geoforgood22?talk=day3-track4-talk2

How to debug an error within a map.

If the error gives you an id, filter then map over the single item returned, see if you get the error
collection.filter('system:index == 16434').map(..)

if you do, filter down to just that element, use first() to save to a new object, then directly run the function on that object

Shortcuts to extract a number from an element
ee.Number(image.get(..)) or
image.getNumber(...)

try to avoid reduceRegion (or other aggregations) inside a map function
- this is b/c reduce region spools up ~20 workers, but then workers get spooled up for each map
	so they don't let you spool up workers within workers. it will run but will be slow.

Computed value is too large
- aggregations save to cache, which has a limit of 100MB, so your aggregation is requesting too much information to fit into cache memory

timeouts
- there is an interactive stack and batch stack. interactive is for the playground, batch is for exports
- interactive stack timeout is 4.5 min
- batch stack has limit if 10 min per feature
- numer of days limit is 10 days, but google servers are rebooted weekly (often on Thursday) so at most you get 7 days
- they will retry a task 5 times
- if someone else kills a machine that you are using, your task will fail
- there is an internal cache for computations. so if you run a task then run it again, it will try to make use of the cache. cache usually lasts 24 hours but someone else can kick your data out

Map is better than iterate(). only use iterate if you need the results of the previous iteration in the next iteration. a for loop will make multiple copies of the computational description, so the object sent to the server can be very large. but, iterate does the same thing on the server side.
