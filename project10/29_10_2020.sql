-- ТС в парке с ID типа model_name выпущенного в release_year в состоянии CONDITION
CREATE TABLE vehicle (
	id INT NOT NULL UNIQUE, -- мы не допускаем повторяющихся идентификаторов
	release_year INT CHECK(release_year > 1800),
	condition TEXT CHECK(condition IN ('исправен', 'некритические неисправности', 'требует ремонта')),
	model_name TEXT NOT NULL
);

-- Модель ТС с названием model_name типа vehicle_type и вместимостью capacity
CREATE TABLE vehicle_model (
	model_name TEXT NOT NULL UNIQUE, -- у нас не повторяются названия моделей
	vehicle_type TEXT NOT NULL,
	capacity INT CHECK(capacity > 0)
);

-- Тип ТС (автобус, троллейбус, трамвай, ТУАХ, электробус)
CREATE TABLE vehicle_type (
	NAME TEXT NOT NULL UNIQUE -- у нас нету одинаковых типов ТС
);

-- Остановка с номером ID по адресу address с количество платформ available_platforms
CREATE TABLE stop (
	id INT NOT NULL UNIQUE, -- у нас не повторяются остановки
	address TEXT NOT NULL,
	available_platforms INT CHECK(available_platforms > 0)
);

-- Маршрут между начальной initial_stop остановкой и final_stop остановкой с номером ID для типа ТС vehicle_type
CREATE TABLE route (
	id INT NOT NULL UNIQUE, -- у нас не повторяются маршруты
	vehicle_type TEXT NOT NULL,
	initial_stop INT NOT NULL,
	final_stop INT NOT NULL
);

-- Запись с номером ID о времени прибытия TIME номера маршрута route_id на остановку stop_id 
-- платформу platform_number в is_weekend день недели
CREATE TABLE timetable (
  	ID INT NOT NULL UNIQUE, -- номер записи не повторяется
	time time NOT NULL,
	route_id INT NOT NULL,
	stop_id INT NOT NULL,
	platform_number INT NOT NULL,
	is_weekend boolean
);

-- Водитель с именем NAME с номером удостоверения ID
CREATE TABLE driver (
	id INT NOT NULL UNIQUE, -- номера удостоверения не повторяются
	name TEXT NOT NULL
);

-- Описание наряда для водителя с номером удостоверения driver_id 
-- на ТС с номером-идентификатором vehicle_id по маршруту номер маршрута route_id
-- с начальной остановки initial_stop с времени начала initial_time в день DATE
CREATE TABLE assignment (
	id int NOT NULL UNIQUE, -- номера нарядов не повторяются
	vehicle_id int NOT NULL,
	route_id int NOT NULL,
	initial_stop int NOT NULL,
	initial_time time NOT NULL,
	driver_id int NOT NULL,
	date date NOT NULL
);


-- Запись с номером ID о фактическом actual_time и ожидаемом expected_time времени прибытия 
-- наряда assignment_id на остановку stop_id
CREATE TABLE supervisor_info (
	id int NOT NULL UNIQUE, -- номера записей не повторяются
	assignment_id int NOT NULL,
	stop_id int NOT NULL,
	actual_time time NOT NULL,
	expected_time time NOT NULL
);

-- Билет с типом TYPE стоимостью price
CREATE TABLE ticket (
	type TEXT NOT NULL UNIQUE, -- типы билетов уникальны
	price int NOT NULL CHECK(price > 0)
);

-- Количество валидаций number_of_validations билета типа ticket_type в наряде assignment_id
CREATE TABLE statistics (
  	id INT NOT NULL UNIQUE, -- номер записи о статистике не повторяется
	assignment_id int NOT NULL,
	ticket_type TEXT NOT NULL,
	number_of_validations int NOT NULL CHECK(number_of_validations > 0)
);