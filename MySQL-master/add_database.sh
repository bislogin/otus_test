#!/bin/bash

sudo mysql <<EOF
create database otus;
use otus;
create table test_tbl (id int);
insert into test_tbl values (2),(3),(4);
EOF

