DROP TABLE IF EXISTS stocks;
CREATE TABLE stocks(
	code VARCHAR(16),
	name VARCHAR(32),
	industry VARCHAR(32),
	area VARCHAR(32),
	pe DECIMAL(16,3),
	outstanding DECIMAL(16,3),
	totals DECIMAL(16,3),
	totalAssets DECIMAL(16,3),
	liquidAssets DECIMAL(16,3),
	fixedAssets DECIMAL(16,3),
	reserved DECIMAL(16,3),
	reservedPerShare DECIMAL(16,3),
	esp DECIMAL(16,3),
	bvps DECIMAL(16,3),
	pb DECIMAL(16,3),
	timeToMarket DATE,
	undp DECIMAL(16,3),
	perundp DECIMAL(16,3),
	rev DECIMAL(16,3),
	profit DECIMAL(16,3),
	gpr DECIMAL(16,3),
	npr DECIMAL(16,3),
	holders DECIMAL(16,3),
	PRIMARY KEY(code)
);

DROP TABLE IF EXISTS data_update;
CREATE TABLE data_update(
	code VARCHAR(16),
	brief_data_update_time DATE,
	history_data_update_time DATE,
	PRIMARY KEY(code)
);