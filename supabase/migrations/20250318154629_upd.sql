drop table if exists market;
create table market(
    id bigint primary key generated always as identity not null,
    quantity bigint not null,
    name text not null unique,
    type text not null,
    price bigint not null
);
