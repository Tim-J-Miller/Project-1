create database if not exists P1 
with dbproperties ('creator'='timmiller','date'='09/05/2021');

create table if not exists BevcountA(beverage string,count int) row format delimited fields terminated by ',';
create table if not exists BevcountB(beverage string,count int) row format delimited fields terminated by ',';
create table if not exists BevcountC(beverage string,count int) row format delimited fields terminated by ',';

create table if not exists BevbranchA(beverage string,branch string) row format delimited fields terminated by ',';
create table if not exists BevbranchB(beverage string,branch string) row format delimited fields terminated by ',';
create table if not exists BevbranchC(beverage string,branch string) row format delimited fields terminated by ',';

 load data inpath '/user/hive/P1-input/Bev_ConscountA.txt' into table BevcountA;
 load data inpath '/user/hive/P1-input/Bev_ConscountB.txt' into table BevcountB;
 load data inpath '/user/hive/P1-input/Bev_ConscountC.txt' into table BevcountC;

 load data inpath '/user/hive/P1-input/Bev_BranchA.txt' into table BevbranchA;
 load data inpath '/user/hive/P1-input/Bev_BranchB.txt' into table BevbranchB;
 load data inpath '/user/hive/P1-input/Bev_BranchC.txt' into table BevbranchC;

-----------------------------------------------------
--scenario 1

create table if not exists Branch1Beverages as select * from BevBranchA where branch = 'Branch1';
insert into table Branch1Beverages select * from BevBranchB where branch = 'Branch1';
insert into table Branch1Beverages select * from BevBranchC where branch = 'Branch1';

create table if not exists Branch1ConsumerCount(beverage string, count int);
insert into table Branch1ConsumerCount select BevcountA.beverage, sum(BevcountA.count) 
	from Branch1Beverages join BevcountA on(Branch1Beverages.beverage=BevcountA.beverage) group by BevcountA.beverage;
insert into table Branch1ConsumerCount select BevcountB.beverage, sum(BevcountB.count) 
	from Branch1Beverages join BevcountB on(Branch1Beverages.beverage=BevcountB.beverage) group by BevcountB.beverage;
insert into table Branch1ConsumerCount select BevcountC.beverage, sum(BevcountC.count) 
	from Branch1Beverages join BevcountC on(Branch1Beverages.beverage=BevcountC.beverage) group by BevcountC.beverage;

select sum(count) Branch1Total from Branch1ConsumerCount;

create table if not exists Branch2Beverages as select * from BevBranchA where branch = 'Branch2';
insert into table Branch2Beverages select * from BevBranchB where branch = 'Branch2';
insert into table Branch2Beverages select * from BevBranchC where branch = 'Branch2';

create table if not exists Branch2ConsumerCount(beverage string, count int);
insert into table Branch2ConsumerCount select BevcountA.beverage, sum(BevcountA.count) 
	from Branch2Beverages join BevcountA on(Branch2Beverages.beverage=BevcountA.beverage) group by BevcountA.beverage;
insert into table Branch2ConsumerCount select BevcountB.beverage, sum(BevcountB.count) 
	from Branch2Beverages join BevcountB on(Branch2Beverages.beverage=BevcountB.beverage) group by BevcountB.beverage;
insert into table Branch2ConsumerCount select BevcountC.beverage, sum(BevcountC.count) 
	from Branch2Beverages join BevcountC on(Branch2Beverages.beverage=BevcountC.beverage) group by BevcountC.beverage;
	
select sum(count) Branch2Total from Branch2ConsumerCount;

-----------------------------------------------------------------------------------
--scenario 2

select beverage, sum(count) c from branch1consumercount group by beverage order by c desc limit 1;
select beverage, sum(count) c from branch2consumercount group by beverage order by c limit 1;

----------------------------------------------------------------------------------
--scenario 3

create table if not exists Branch10Beverages as select * from BevBranchA where branch = 'Branch10';
insert into table Branch10Beverages select * from BevBranchB where branch = 'Branch10';
insert into table Branch10Beverages select * from BevBranchC where branch = 'Branch10';

create table if not exists Branch8Beverages as 
(
	select * from BevBranchA where branch = 'Branch8'
	union all select * from BevBranchB where branch = 'Branch8'
	union all select * from BevBranchC where branch = 'Branch8'
);

select DISTINCT beverage, branch10beverages.branch from branch10beverages 
union select DISTINCT beverage, branch8beverages.branch from branch8beverages 
union select DISTINCT beverage, branch1beverages.branch from branch1beverages;

create table if not exists Branch7Beverages as 
(
	select * from BevBranchA where branch = 'Branch7' 
	union select * from BevBranchB where branch = 'Branch7' 
	union select * from BevBranchC where branch = 'Branch7'
);
create table if not exists Branch4Beverages as 
(
	select * from BevBranchA where branch = 'Branch4' 
	union select * from BevBranchB where branch = 'Branch4' 
	union select * from BevBranchC where branch = 'Branch4'
);

select branch4beverages.beverage Beverages from branch4beverages 
inner join branch7beverages on (branch4beverages.beverage = branch7beverages.beverage);

-------------------------------------------------------------------------------------
--scenario 4

create table if not exists Branch10Branch8Branch1Beverages (beverages string)
partitioned by (branch string)
row format delimited
fields terminated by ',' stored as textfile;

set hive.exec.dynamic.partition.mode=nonstrict;
insert into table Branch10Branch8Branch1Beverages partition(Branch) 
(
	select DISTINCT beverage, branch from branch10beverages 
	union select DISTINCT beverage, branch from branch8beverages 
	union select DISTINCT beverage, branch from branch1beverages
);
select * from Branch10Branch8Branch1Beverages;

create table if not exists Branch4_Branch7Beverages as select distinct * from 
(
	select * from BevBranchA where branch = 'Branch7' or branch = 'Branch4' 
	union select * from BevBranchB where branch = 'Branch7' or branch = 'Branch4'  
	union select * from BevBranchC where branch = 'Branch7'or branch = 'Branch4'
)dual;

CREATE INDEX index_beverage ON TABLE Branch4_Branch7Beverages (beverage)
AS 'compact' with deferred rebuild;


create view branch4branch7beverages as
select branch4beverages.beverage Beverages from branch4beverages 
inner join branch7beverages on (branch4beverages.beverage = branch7beverages.beverage);

select * from branch4branch7beverages;

---------------------------------------------------------------------------------------------------
--scenario 5

Alter table Branch4_Branch7Beverages set tblproperties ('note'='test note','comment'='test comment')

--does not work when executed in DBeaver, works when executed in terminal
show tblproperties Branch4_Branch7Beverages;

---------------------------------------------------------------------------------------------------
--scenario 6

select * from Branch1ConsumerCount order by beverage;

create table if not exists Branch1ConsumerCount_sans_row_5 as select * from(
select *,ROW_NUMBER() over (Order by beverage) as rowid from Branch1ConsumerCount
)t
where rowid != 5;

select * from Branch1ConsumerCount_sans_row_5;

