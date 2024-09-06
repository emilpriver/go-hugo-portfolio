---
title: "Implementing V7 UUID in Postgres"
date: 2024-09-05T18:17:07+02:00
draft: false
description: "How to implement v7 UUID in postgres with using SQL"
type: "blog"
tags: ["Postgres", "SQL", "UUID"]
toc: false
cover:
  image: "images/postgres.jpg"
series:
  - Guides
  - Postgres
---
Everyone likes fast Postgres databases, and so do I. Something developers have been talking about recently is the usage of UUID v7 in Postgres databases because rt is quicker to search on. I wanted to use v7 as IDs for the service I built, but I also didn't want to generate the UUID in the application layer as I think it's really nice to use `default` in SQL. This article shows a quick example of how I implemented it for my services as Postgres don't support V7 yet.

If you are unfamiliar with the differences between the various UUID versions, I can provide a quick overview:

UUID versions 1, 6, and 7 are generated using a timestamp, monotonic counter, and MAC address. Version 2 is specifically for security IDs. Version 3 is created from MD5 hashes of given data. Version 4 is generated from completely random data. Version 5 is generated from SHA1 hashes of provided data. Version 8 is completely customizable. For most developers, version 4 is sufficient and performs well. However, if you plan to use UUIDs for sorting purposes, you may experience slower sorting queries due to the randomness of the data. In this case, version 7 would be preferred for faster queries.

## The SQL function
A disclaimer is that I did not write this function myself. I found it on a Github thread. What the function does is it utilizes the existing `gen_random_uuid` function, which is the v4 implementation. We use `clock_timestamp` to obtain the current time, extract the epoch time in milliseconds as v7 uses milliseconds, and then convert the millisecond timestamp to a byte sequence using `int8send`. To incorporate the timestamp byte sequence into the UUID, we use `overlay` to replace the first part of the UUID with the byte sequence. Additionally, we need to add the version of the UUID by changing the 52nd and 53rd bits in the byte array using `set_bit`. We simply set both the `52` and `53` bits to 1 to indicate version 7. Finally, we use encode to convert it back to a `UUID`.

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

create or replace function uuid_generate_v7()
returns uuid
as $$
select encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
$$
language SQL
volatile;
```
## Compairing generating uuid V7 and v4

As you may have noticed, it generates a v7 UUID based on v4, which also explains why it is a bit slower at generating a v7.
```sql
psql (16.2 (Debian 16.2-1.pgdg120+2))
Type "help" for help.

development=# \timing on
Timing is on.
development=# select count(uuid_generate_v7()) from generate_series(1,1000000);
  count
---------
 1000000
(1 row)

Time: 1821.550 ms (00:01.822)
development=# select count(gen_random_uuid()) from generate_series(1,1000000);
  count
---------
 1000000
(1 row)

Time: 885.396 ms
development=#
```

## Inserting and sorting on UUIDS
The most interesting part is when we use the v7 UUID. So what I did was a super simple test just to see if it's faster. I used `timing` in Postgres to see how long the query takes. I also created 2 new tables with 1 `id` column of type UUID and then I inserted 1 million rows into each table with respective UUID versions and queried it with a simple sort.

```SQL
development=# create table test_v4(id uuid);
CREATE TABLE
development=# create table test_v7(id uuid);
CREATE TABLE
development=# INSERT INTO test_v4(id) SELECT gen_random_uuid() FROM generate_series(1, 1000000) as g (id);
INSERT 0 1000000
development=# INSERT INTO test_v7(id) SELECT uuid_generate_v^C FROM generate_series(1, 1000000) as g (id);
INSERT 0 1000000
development=# \timing on
Timing is on.
development=# SELECT * FROM test_v4 ORDER BY id DESC;
Time: 312.911 ms
development=# SELECT * FROM test_v7 ORDER BY id DESC;
Time: 270.869 ms
development=#
```
With this test, we can see that v7 is 13.44 times faster (42.042 ms).

I also performed a quick `EXPLAIN ANALYZE` on v7 and obtained the following results:
```sql
EXPLAIN ANALYZE SELECT * FROM test_v7 ORDER BY id DESC;
 Sort  (cost=132154.34..134654.34 rows=1000000 width=16) (actual time=160.443..209.393 rows=1000000 loops=1)
   Sort Key: id DESC
   Sort Method: external merge  Disk: 19640kB
   ->  Seq Scan on test_v7  (cost=0.00..15406.00 rows=1000000 width=16) (actual time=0.014..36.475 rows=1000000 loops=1)
 Planning Time: 0.152 ms
 Execution Time: 236.269 ms
(6 rows)
```
For v4:
```sql
EXPLAIN ANALYZE SELECT * FROM test_v4 ORDER BY id DESC; 
  Sort  (cost=132154.34..134654.34 rows=1000000 width=16) (actual time=176.818..254.316 rows=1000000 loops=1)
   Sort Key: id DESC
   Sort Method: external merge  Disk: 19640kB
   ->  Seq Scan on test_v4  (cost=0.00..15406.00 rows=1000000 width=16) (actual time=0.005..36.282 rows=1000000 loops=1)
 Planning Time: 0.074 ms
 Execution Time: 281.140 ms
(6 rows)
```

## The end 
I hope you enjoyed this article. If you have any suggestions for changes, please let me know. You can reach me at [X](https://x.com/emil_priver). Have a great day!
