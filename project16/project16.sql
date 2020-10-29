CREATE TABLE FunctionPurposes(purpose TEXT PRIMARY KEY);
-- Справочник функциональных предназначений, например бассейн, жилой дом и т.д.

CREATE TABLE Objects(id Serial PRIMARY KEY,
                     address TEXT NOT NULL,
                     purpose TEXT NOT NULL, 
                     name TEXT NOT NULL, -- клички могут и пересекаться
                    FOREIGN KEY(purpose) REFERENCES FunctionPurposes(purpose)); -- (N: 1) с таблицей FunctionPurposes
-- Каждый объект имеет уникальный номер. Располагается на address, имеет функциональное предназначение purpose, иногда имеет псевдоним name.

CREATE TABLE Delegations(country TEXT PRIMARY KEY,
                         head TEXT NOT NULL, 
                        phone TEXT NOT NULL, 
                        object_id SERIAL,
                        FOREIGN KEY(object_id) REFERENCES objects(id)); -- (N: 1) с таблицей Objects
-- Делегация представляет страну country, глава (head) - не уникальный, например у СССР и РФ может быть один и тот же глава, телефон главы в поле phone, делегация располагается в здании под номером object_id

CREATE TABLE Volunteers(ID SERIAL PRIMARY KEY,
                       name TEXT NOT NULL,
                       phone TEXT NOT NULL);
-- У каждого волонтёра есть уникальный идентификатор ID, имя name и номер телефона phone

CREATE TABLE Task(ID SERIAL PRIMARY KEY,
					volunteer_id SERIAL NOT NULL,
                  task_date Date,
                 task_time TIME,
                 task_text TEXT NOT NULL,
                 vehicle_number TEXT,
                 capacity INT, 
                 FOREIGN KEY(volunteer_id) REFERENCES Volunteers(ID));  -- (N: 1) с таблицей Volunteers
-- Каждое задание прикрпеплено к волонтёру его номером volunteer_id, задание начинается в task_date task_time, текст задания в поле task_text, если к заданию прикриплён автомобиль, то указывается номер автомобиля и его вместимость. 

CREATE TABLE Sportsmens(id SERIAL PRIMARY KEY,
                        name TEXT NOT NULL,
                       	gender TEXT CHECK(gender='m' or gender='f') NOT NULL,
                        height FLOAT CHECK(height > 0),
                        weight FLOAT CHECK(weight > 0),
                        age INT CHECK(age > 0),
                        country TEXT NOT NULL,
                        object_id SERIAL NOT NULL,
                        volunteer_id SERIAL NOT NULL, 
                        FOREIGN key(country) REFERENCES Delegations(country),  -- (N: 1) с таблицей Delegations
                       FOREIGN KEY(object_id) REFERENCES  Objects(ID), -- (N: 1) с таблицей Objects
                       FOREIGN KEY(volunteer_id) REFERENCES Volunteers(ID));  -- (N: 1) с таблицей Volunteers
-- Спортсмен имеет уникальный идентификатор id, имя name, пол gender (m/f), рост height, вес weight, возраст age, страну country, откуда он приехал (отсюда и делегация), номер объекта object_id, где он живёт, идентификатор волонтёра volunteer_id, к которому он прикреплён.

CREATE TABLe SportType(ID Serial PRIMARY key, sport TEXT UNIQUE NOT NULL);
-- Таблица - справочник. Различные виды спорта описываются своими идентификаторами и названиями. Названия уникальны, поэтому unique. 

 
CREATE TABLE SportsmensSport(sportsmen_id SERIAL NOT NULL, sport_id SERIAL NOT NULL,
                             FOREIGN KEY(sportsmen_id) REFERENCES sportsmens(ID),
                            FOREIGN KEY(sport_id) REFERENCES SportType(id));
-- Пара внешних (sportsmen_id, sport_id) ключей образуют связь (N: N) с таблиц sportsmens и SportType
-- Таблица справочник много спортсменов ко многим видам спорта


CREATE TABLE ObjectSport(object_id SERIAL NOT NULL, sport_id serial NOT NULL,
                         FOREIGN key(object_id) REFERENCES Objects(id),
                         FOREIGN KEY(sport_id) REFERENCES SportType(id));
-- Пара внешних (object_id, sport_id) ключей образуют связь (N: N) с таблиц Objects и SportType
-- Таблица справочник, объект object_id - виды спорта sport_id, многие ко многим.


CREATE TABLE Competitions(ID SERIAL PRIMARY KEY,
                         start_date DATE NOT NULL,
                         start_time TIME NOT NULL,
                         name TEXT NOT NULL, 
                         sport_id SERIAL NOT NULL,
                         object_id SERIAL NOT NULL,
                        FOREIGN KEY (sport_id) REFERENCES SportType(id), -- (N: 1) с таблицей SportType
                        FOREIGN KEY (object_id) REFERENCES Objects(ID)); -- (N: 1) с таблицей Objects
--Каждое соревнование проходит в некотором объекте (object_id), в определенное время start_date start_time, имеет название name и уникальный идентификатор id, одно соревнование может проводиться только по одному виду спорта sport_id.


CREATE TABLE CompetitionData(competition_id SERIAL NOT NULL, sportsmen_id SERIAL NOT NULL, place INT CHECK(place > 0),
                                   FOREIGN KEY(competition_id) REFERENCES Competitions(ID),
                                   FOREIGN KEY(sportsmen_id) REFERENCES Sportsmens(ID));
-- Пара внешних (competition_id, sportsmen_id) ключей образуют связь (N: N) с таблиц Competitions и Sportsmens
--Спортсмен с идентификатор sportsmen_id занял некоторый порядковый номер place (место) в соревновании с номером competition_id, если места ещё не распределены, то на поле места стоит NULL. Отношение многие ко многим.