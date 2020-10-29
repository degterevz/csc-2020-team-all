CREATE TABLE transport_condition(
Id SERIAL PRIMARY KEY,
name TEXT Unique NOT NULL);

CREATE TABLE transport_unit(
tail_number SERIAL PRIMARY KEY, --значения бортового номера уникальны для каждого автомобиля

release_year INT NOT NULL check(release_year > 0),
condition_id INT references transport_condition, --состояние ищем по айди в таблице состояний 1:N
model_id INT not null,
check(condition_id BETWEEN 1 AND 3)
);


CREATE TABLE transport_type(
id SERIAL PRIMARY KEY, 
name TEXT Unique NOT NULL);

CREATE TABLE transport_model(
id SERIAL PRIMARY KEY, 
type_id INT NOT NULL references transport_type, --ссылаемся на тип транспорта в таблице типов транспорта 1:N
name TEXT unique, -- имена моделей обычно уникальные 
capacity INT NOT NULL CHECK(capacity >= 0));

CREATE TABLE transport_stop(
id SERIAL PRIMARY KEY,
address TEXT unique NOT NULL, -- существует только одна остановка с таким адресом 
number_of_platforms INT NOT NULL CHECK(number_of_platforms >= 1));

CREATE TABLE transport_route(
id SERIAL PRIMARY KEY,
transport_type_id INT NOT NULL references transport_type, --ссылаемся на тип транспорта в таблице типов транспорта 1:N
first_stop_id INT NOT NULL references transport_stop, -- есть только одна первая остановка с таким айди 1:N, но остановки могут быть разные у разных маршрутов
last_stop_id INT NOT NULL references transport_stop); -- есть только одна последняя остановка с таким айди 1:N, но остановки могут быть разные у разных маршрутов


CREATE TABLE route_stop(
route_id INT NOT NULL references transport_route, --есть описание маршрута с таким айди 1:1
stop_id INT NOT NULL references transport_stop, --есть одна такая остановка по айди остановки 1:1
platform_number INT NOT NULL check(platform_number >= 1),
primary key (stop_id, platform_number, arrival_time, weekday), --Не может быть совпадений остановок разных маршрутов на одной платформе в одно и то же время в разные дни недели
arrival_time TIME NOT NULL,
weekday BOOLEAN NOT NULL);

CREATE TABLE driver(
id SERIAL PRIMARY KEY,
name TEXT NOT NULL);

CREATE TABLE work_order(
id SERIAL PRIMARY KEY,
days DATE NOT NULL,
transport_unit_id INT NOT NULL references transport_unit(tail_number),-- номер транспорта, который участвует в наряде 1:1
first_stop_id INT NOT NULL references transport_stop(id),  -- есть только одна первая остановка с таким айди 1:N, но остановки могут быть разные у разных маршрутов

starting_time TIME NOT NULL,
driver_id INT NOT NULL references driver(id)); -- по айди можно узнать описание водителя 1:1 и он участвует в одном наряде

CREATE TABLE dispatcher_record(
work_order_id SERIAL PRIMARY KEY,
stop_id INT NOT NULL references transport_stop,   -- есть только одна первая остановка с таким айди 1:N, но остановки могут быть разные у разных маршрутов

arrival_time TIME NOT NULL);


CREATE TABLE ticket_type(
id SERIAL PRIMARY KEY,
description TEXT NOT NULL,
price NUMERIC(5, 2) NOT NULL CHECK(price >= 0)); --ограничили разряды у цены билета

CREATE TABLE validation_result(
work_order_id INT references work_order, --описание наряда единственно для результата валидации 1:N
ticket_type_id INT NOT NULL references ticket_type, --билет уникален для типа валидации 1:N
number_of_validations INT NOT NULL CHECK(number_of_validations >= 0));
