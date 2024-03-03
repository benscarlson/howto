-- To use a reserved word as a column defintion when creating a table, enclose the column name with "". eg. 'group'

-- How to use a sequence as the default value for a primary key
create sequence seq_my_id start 1;

create table mytb (
  my_id ubigint primary key default nextval('seq_my_id'), 
);
