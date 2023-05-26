# learn-sql-queries

## Troubleshoot High CPU Utilization in PostgreSQL

### Connections summary

Examine the running sessions trying to `EXPLAIN ANALYZE` the long-running/badly written/too-frequent queries. If the 
number of active connections is > 1/CPU core - check and tune how the app works with the DB.

Check the maximum number of connections:

```postgresql
show max_connections;
```

The default is 100.

If the number of connections approaches `max_connections` consider:

* analyzing the app activity
* reducing the number of connections arriving at the DB
* tuning the `max_connections` parameter
* scaling up the DB instance

The `max_connections` defines the maximum number of concurrent connections to the PostgreSQL DB Server. Try to set the 
`max_connections` to the maximum number of connections expected at peak load.

However, the `max_connections` parameter needs to be aligned with the available resources of the DB. Tune it carefully 
to avoid system out-of-memory issues, since each connection allocates a chunk of the memory.

```postgresql
select A.total_connections,
       A.non_idle_connections,
       B.max_connections,
       round((100 * A.total_connections::numeric / B.max_connections::numeric), 2) connections_utilization_pctg
from (select count(1) as total_connections, sum(case when state != 'idle' then 1 else 0 end) as non_idle_connections
      from pg_stat_activity) A,
     (select setting as max_connections from pg_settings where name = 'max_connections') B;
```

### Distribution of non-idle connections per DB

Examine the running sessions per DB and optimize the one that has the highest value.

```postgresql
select datname as db_name, count(1) as num_non_idle_connections 
from pg_stat_activity 
where state != 'idle' 
group by 1;
```

### Distribution of non-idle connections per DB and per query

Examine the queries having the top non-idle connections. A high number of non-idle connections might indicate 
ineffective, not scalable architecture or workload.

```postgresql
select datname as db_name, substr(query, 1, 200) short_query, count(1) as num_non_idle_connections 
from pg_stat_activity 
where state !='idle' 
group by 1, 2 
order by 3 desc;
```

### Non-idle sessions 

Long-running queries can cause high CPU utilization. Analyze which take more than 3 seconds and tune them.

```postgresql
select 
	now() - query_start as runtime, 
	pid as process_id, 
	datname as db_name, 
	client_addr,
	client_hostname,
	substr(query, 1, 200) short_query
from pg_stat_activity
where state != 'idle'
and now() - query_start > '3 seconds'::interval
order by 1 desc;
```

### Running frequent SQL queries

Quick, but too frequent queries running hundreds of times per second can cause high CPU utilization. Show all queries
that execute more than 100/s. Try improving the app logic and consider using caching.

```postgresql
with
    a as (select dbid, queryid, query, calls from pg_stat_statements),
    b as (select dbid, queryid, query, calls from pg_stat_statements, pg_sleep(1))
select
    pd.datname as db_name,
    substr(a.query, 1, 200) as short_query,
    sum(b.calls - a.calls) as runs_per_second
from a, b, pg_database pd
where a.dbid = b.dbid
  and a.queryid = b.queryid
  and b.calls - a.calls > 100
group by 1, 2
order by 3 desc;
```

### CPU distribution per database, and per query

Check queries that use a lot of CPU or time. Look for queries with a high mean time/number of calls.

```postgresql
SELECT
    pss.userid,
    pss.dbid,
    pd.datname as db_name,
    round((pss.total_exec_time + pss.total_plan_time)::numeric, 2) as total_time,
    pss.calls,
    round((pss.mean_exec_time + pss.mean_plan_time)::numeric, 2) as mean,
    round((100 * (pss.total_exec_time + pss.total_plan_time) / sum((pss.total_exec_time + pss.total_plan_time)::numeric) OVER ())::numeric, 2) as cpu_portion_pctg,
    substr(pss.query, 1, 200) as query
FROM pg_stat_statements pss, pg_database pd
WHERE pd.oid = pss.dbid
ORDER BY (pss.total_exec_time + pss.total_plan_time)
DESC LIMIT 30;
```

### DB tables statistics

Outdated PostgreSQL statistics can be another root cause for high CPU utilization. When statistical data isn’t updated,
the PostgreSQL query planner may generate non-efficient execution plans for queries, which will lead to a bad
performance of the entire PostgreSQL DB Server.

Ensure tables are analyzed regularly.

```postgresql
select schemaname,
       relname,
       DATE_TRUNC('minute', last_analyze),
       DATE_TRUNC('minute', last_autoanalyze)
from pg_stat_all_tables
where schemaname = 'public'
order by last_analyze desc NULLS FIRST, last_autoanalyze desc NULLS FIRST;
```

To collect statistics manually for a specific table and its associated indexes run the command: 

```postgresql
ANALYZE table_name;
```

### PostgreSQL database bloat

In cases of intensive data updates, both with frequent UPDATE and with INSERT / DELETE operations, PostgreSQL tables and
their indices become bloated. Bloat refers to disk space that was allocated by a table or index and is now available for
reuse by the database, but has not been reclaimed. Because of this bloat, the performance of the PostgreSQL DB Server is
degraded, which can lead to high CPU utilization scenarios.

Under normal PostgreSQL operations, tuples that are deleted or stale because of an update aren’t physically removed from
the table— they’re stored there until the VACUUM command is issued. VACUUM releases the space occupied by “dead” tuples.
Thus, it’s necessary to perform a VACUUM periodically, especially for tables that change often.

To check information about dead tuples, and when vacuum / autovacuum was run for each table in the PostgreSQL DB Server
for specific DB, connect to the DB and run the following query:

```postgresql
select 
  schemaname, 
  relname, 
  n_tup_ins, 
  n_tup_upd, 
  n_tup_del, 
  n_live_tup, 
  n_dead_tup, 
  DATE_TRUNC('minute', last_vacuum) last_vacuum, 
  DATE_TRUNC('minute', last_autovacuum) last_autovacuum
from 
  pg_stat_all_tables 
where 
  schemaname = 'public'
order by 
  n_dead_tup desc;
```

Ensure tables are vacuumed regularly. To run VACUUM (regular, not FULL) for a specific table and all its associated
indexes run the command:

```postgresql
VACUUM table_name;
```

### Check PostgreSQL database tables statistics and bloat

```postgresql
select 
  schemaname, 
  relname, 
  n_tup_ins, 
  n_tup_upd, 
  n_tup_del, 
  n_live_tup, 
  n_dead_tup, 
  last_vacuum, 
  last_autovacuum, 
  last_analyze, 
  last_autoanalyze 
from 
  pg_stat_all_tables 
where 
  schemaname = 'public'
order by 
  n_dead_tup desc;
```

Get a list of tables that were either never analyzed or vacuumed, or that were analyzed a long time ago, or that have
had a lot of changes since the last time DB statistics were collected and vacuum run. Tune the autovacuum PostgreSQL
process to ensure the more frequently a table or its indexes are getting changes, the more frequently vacuum and analyze
will be performed.
