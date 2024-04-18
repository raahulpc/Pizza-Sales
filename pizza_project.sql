create database papajohns;
use papajohns;
CREATE TABLE orders (
    order_id INT NOT NULL PRIMARY KEY,
    orderdate DATE NOT NULL,
    ordertime TIME NOT NULL
);

create table order_details(
order_details_id int not null primary key,
orderid int not null,
pizza_id text not null,
quantity int not null);
use papajohns;
show tables;

select * from pizza_types;
select * from pizzas;
select * from orders;
select * from order_details;





