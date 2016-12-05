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
	holders DECIMAL(16,3)
);

INSERT INTO stocks(totalAssets,rev,code,outstanding,timeToMarket,bvps,totals,liquidAssets,area,reserved,holders,perundp,npr,fixedAssets,profit,pb,gpr,name,reservedPerShare,industry,esp,pe,undp) VALUES('131237.2','-11.14','600107','3.6','199
71106','1.44','3.6','86535.82','ºþ±±','15956.38','23686','-0.07','-3.51','15406.
82','-458.2','13.51','36.83','ÃÀ¶ûÑÅ','0.44','·þÊÎ','-0.029','0','-2694.3');