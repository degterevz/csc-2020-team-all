-- Действующее вещество с названием "name" и формулой "formula"
create table substance
(
   name    text primary key,
   formula text not null
);
-- Лаборатория с номером "id", названием "name"; фамилия руководителя лаборатории "head_last_name"
create table lab
(
   id             int primary key,
   name           text not null,
   head_last_name text not null
);
-- Сертификат с номером "id", сроком действия "expiration_date", который выпустила лаборатория с номером "lab_id"; Тип связей между certificate и lab N:1
create table certificate
(
   id              int primary key,
   expiration_date date,
   lab_id          int references lab (id)
);
-- Лекарственная форма “id” с названием “name” (таблетка/капсула и тд), (каждому типу соответствует один свой id)
create table drug_form
(
   id   int primary key,
   name text not null unique
);
-- Перевозочная упаковка “id” , вес упаковки “weight”, число отпускных упаковок “release_packages”, их цена “release_price”
create table shipping_package
(
   id               int primary key,
   weight           numeric not null check (weight > 0.0),
   release_packages int     not null check (release_packages >= 0),
   release_price    numeric check (release_price > 0.0)
);
-- Лекарство “id”, его торговое название “trademark”, международное непатентованное название “international_name”, лекарственная форма “drug_form_id”, производитель “manufacturer”, действующее вещество “substance_name”, Сертификат “certificate_id”, отпускная форма “release_package_type”, отпускная упаковка “shipping_package_id” (одному лекарству соответствует только одна упаковка); Тип связей между drug и drug_form N:1; между drug и substance N:1; между drug и shipping_package 1:1, drug и certificate 1:1
create table drug
(
   id                   int primary key,
   trademark            text not null,
   international_name   text not null,
   drug_form_id         int references drug_form (id),
   manufacturer         text not null,
   substance_name       text references substance (name),
   certificate_id       int references certificate (id),
   release_package_type text not null,
   shipping_package_id  int unique references shipping_package (id)
);
-- Дистрибьютор “id” с адресом address, номером счета account_number, с фамилией  “contact_last_name”, именем “contact_first_name”, номером телефона “contact_phone”
create table distributor
(
   id                 int primary key,
   address            text not null,
   account_number     text not null,
   contact_last_name  text not null,
   contact_first_name text not null,
   contact_phone      text not null
);
-- Склад “id” с адресом “address”
create table warehouse
(
   id      int primary key,
   address text not null
);
-- Поставка на склад “id” с ответственным “warehouse_id”, время поставки “arrival_time”, фамилия кладовщика “storekeepers_last_name”; Связь между warehouse_delivery и distributor 1:1, между warehouse_delivery и  warehouse 1:1
create table warehouse_delivery
(
   id                     int primary key,
   distributor_id         int references distributor (id),
   warehouse_id           int references warehouse (id),
   arrival_time           time not null,
   storekeepers_last_name text not null
);
-- Аптека “id” с адресом “address”
create table drugstore
(
   id      int primary key,
   address text not null
);
-- Список лекарств в аптеке: В аптеке “drugstore_id” есть лекарство “drug_id” ценой price в кол-ве “items_count”; Связь между drugstore и drug N:N
create table drugstore_price_list
(
   drugstore_id int references drugstore (id),
   drug_id      int references drug (id),
   price        numeric not null check (price > 0.0),
   items_count  int     not null check (items_count >= 0),
   primary key(drugstore_id, drug_id)
);

-- Автомобиль для поставки с номером “reg_num”, дата техобслуживания “date”
create table transport_vehicle
(
   registration_number text primary key,
   date                date not null
);
-- Поставка в аптеку id, осуществил автомобиль с номером “transport_vehicle_number”, дата поставки “delivery_date”, со склада “warehouse_id”, кол-во упаковок “package_count”, лекарство "drugstore_id”; Связь между drugstore_delivery и drugstore 1:1
create table drugstore_delivery
(
   id                       int primary key,
   transport_vehicle_number text references transport_vehicle (registration_number),
   delivery_date            date not null,
   warehouse_id             int references warehouse (id),
   package_count            int  not null check (package_count > 0),
   drugstore_id             int  not null references drugstore (id)
);
-- Список лекарств в поставке:  В поставке “delivery_id” находится лекарство “drug_id” в кол-ве packages_count; Связь между warehouse_delivery и drug N:N
create table warehouse_delivery_drugs
(
   delivery_id    int references warehouse_delivery (id),
   drug_id        int references drug (id),
   packages_count int not null check (packages_count > 0),
   primary key(delivery_id, drug_id)
);

