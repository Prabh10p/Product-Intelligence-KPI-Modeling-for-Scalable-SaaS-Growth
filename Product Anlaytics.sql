create database if not exists Project1;
use Project1;




#1 - Understanding the Dataset
select * from ab_test_dataset;
select count(*) from ab_test_dataset;  
show columns from ab_test_dataset;
describe ab_test_dataset;

alter table ab_test_dataset
rename column `group` to `groups_exp`;





#2 - Column Data Analysis(CDA)
#Testing unique categories present in there
select distinct(click) from ab_test_dataset;  -- 0-means not clicked 1-means clicked
select distinct(groups_exp) from ab_test_dataset;  -- it have exp,a,con,null,a,con - means this need deep cleaning
select distinct(device_type) from ab_test_dataset;  -- mobile,desktop
select distinct(referral_source) from ab_test_dataset;  -- search,email,direct,social,null,ads,seach,Social-- need cleaning too







#3 - Data Cleaning/Preprocessing(Removing Null Values,duplicated,outliers)
Set SQL_SAFE_UPDATEs = 0;


#(a)-Removing Null Values 
SELECT * FROM ab_test_dataset 
WHERE click IS NULL 
  OR groups_exp IS NULL
  OR session_time IS NULL 
  OR click_time IS NULL                       -- There is no null value so we will keep it as it is
  OR device_type IS NULL 
  OR referral_source IS NULL;




## (b) - Normalising values into specific category

select count(distinct groups_exp) from ab_test_dataset;  -- we have 6 groups but we only want 2 so we will change other

 select groups_exp,count(*) from ab_test_dataset -- we will make ['A,a'] into (exp) experimental group 
 group by groups_exp;                            -- we will make [con,Null value] into (con)controlled group  

update ab_test_dataset
set groups_exp=case
when groups_exp in ('A','a','exp') then 'exp' --   exp(99038),con(1000982)
else 'con'
end;


select referral_source,count(*) from ab_test_dataset -- we will make 5 categories in it(search,email,direct,social,ads) 
 group by referral_source;  

update ab_test_dataset
set referral_source = 'search'
where referral_source regexp 'seach';

update ab_test_dataset
set referral_source = 'social'
where referral_source regexp 'Social';

update ab_test_dataset
set referral_source = 'direct'
where trim(referral_source) = '';           -- weh have 5 categories in referrla sources now





## c - Findind outliers

select * from ab_test_dataset;
select count(*) from (
select *,abs(session_time-avg(session_time)over())/std(session_time)over() as "z_score"
from ab_test_dataset)r
where r.z_score>3;                      
									     
	

## d- Removing outliers
create table ab_test_cleaned as(
select * from (
select *,abs(session_time-avg(session_time)over())/std(session_time)over() as "z_score"
from ab_test_dataset)r
where r.z_score<3);     



## e -Handling missing values.  -- Almost 2000 missing click values
delete from ab_test_cleaned
where trim(click_time)='';

select count(*) from ab_test_cleaned;    --  Now we have 196041 cleaned values after removing missing click values






ALTER TABLE ab_test_cleaned
ADD COLUMN user_id INT AUTO_INCREMENT PRIMARY KEY FIRST;


ALTER TABLE ab_test_cleaned 
MODIFY COLUMN user_id INT;

ALTER TABLE ab_test_cleaned 
DROP PRIMARY KEY;



UPDATE ab_test_cleaned
SET user_id = FLOOR(1 + (RAND() * 10000));





# 4- Stastical Analysis

select * from ab_test_cleaned;



#Question 1- Find (Conversion Rate) Proportion of Customer who clicked/Not Clicked on Web Service


select click,concat(round(count(*)*100/(select count(*) from ab_test_cleaned),2),'%') as 'Proportion'
from ab_test_cleaned
group by click;     -- Convertion Rate is 35%,whereas 65 percent user didn't clicked on services



#Question 2- Find Prorportion of Experimental/Controlled group(how much users used for experimental purposes)
select groups_exp,concat(round(count(*)*100/(select count(*) from ab_test_cleaned),2),'%') as 'Proportion'
from ab_test_cleaned
group by groups_exp;     -- Almost 50% of dataset contain experiemental groups so its pretty balanced



#Question 3-  Find Prorportion of Device_type used based on Click/Not clicked

select click,device_type,groups_exp,concat(round(count(*)*100/(select count(*) from ab_test_cleaned),2),'%') as 'Proportion'
from ab_test_cleaned
group by click,device_type,groups_exp  
order by proportion desc;              



#Question 4-  Find Avg session time by group

select click,round(avg(session_time),2) as "average"
from ab_test_cleaned
group by click
order by average;






# 5 - Defining and Anlaysis Metrics(DAU,WAU,CTR,Bounce Rate,Avg time per session)

#(a) - Finding DAU((Daily active users),MAU(monthly active users)

CREATE TEMPORARY TABLE  if not exists metric_analysis AS
SELECT 
  *,user_id,DATE(click_time) AS `date`,
  DATE_FORMAT(click_time, '%x-W%v') AS `week`,
  DATE_FORMAT(click_time, '%Y-%m') AS `month`
FROM ab_test_cleaned
WHERE click_time IS NOT NULL;



# 1-DAU based on Session(Daily Active Users)
select user_id,date,count(*) from metric_analysis
group by user_id,date
order by date;

# 2- WAU based on Session(Weekly Active Users)
select user_id,week,count(*) from metric_analysis       # week 1 - 98144
group by user_id,week									# week 2 - 97897
order by user_id,week asc;





# 3 - Finding daily CTR(Click Through Rate)
select date(click_time),
concat(round(SUM(click=1) * 100.0/count(*),2),"%")   --                      
from ab_test_cleaned													    														
group by date(click_time);



#(b)Finding weekly CTR(Click Through Rate) 
select date_format(click_time,'%Y-W%v'),
concat(round(SUM(click=1) * 100.0/count(*),2),"%")   --                       
from ab_test_cleaned													   												
group by date_format(click_time,'%Y-W%v');


#(c) - Finding CTR(click-through rate)by group, device, referral
select groups_exp,
concat(round(SUM(click=1) * 100.0/count(*),2),"%")                          
from ab_test_cleaned													    														
group by groups_exp;


# (d)Finding CTR(click-through rate) by device

select device_type,
concat(round(sum(click=1)*100.0/count(*),2),"%")                              
from ab_test_cleaned													   													
group by device_type;



# (e)Finding CTR(click-through rate) by referral
select referral_source,
concat(round(sum(click=1)*100.0/count(*),2),"%")                            
from ab_test_cleaned													   
																			  												
group by referral_source;



# 4- Funnel in(Basic Session → Click Funnel)
select
"Sessions" as Staged,
count(*) as "Counts"
from ab_test_cleaned                  
									
union all
select 
"Clicked" as Staged,
count(*) as "Counts"
from ab_test_cleaned
where click=1;




#(b) - Funnel based on Sessio Duration

SELECT
  'Sessions' AS Staged,
  COUNT(*) AS Counts
FROM ab_test_cleaned

UNION ALL

SELECT 
  'Clicked' AS Staged,
  COUNT(*) AS Counts
FROM ab_test_cleaned
WHERE click = 1

UNION ALL

SELECT 
  'Long Session (5+ min)' AS Staged,
  COUNT(*) AS Counts                                             
FROM ab_test_cleaned 
WHERE session_time >= 5

union all
SELECT 
  'Long Session Clicked(5+ min)' AS Staged,
  COUNT(*) AS Counts                                           
FROM ab_test_cleaned 
where click=1
and session_time >= 5

Union ALL
Select 
'Medium Session (3-5)' AS Staged,
  COUNT(*) AS Counts                                         
FROM ab_test_cleaned 
WHERE session_time >= 3 and session_time<5;





# (c)-  Split Funnel by A/B Group(based on CTR,Bounce Rate,Avg session time)
select
groups_exp as variant,
count(*) as 'sessions',
sum(click=1) as "Clicked",
sum(session_time>=5) as "Long Session (5+ min)",
concat(round(sum(click=1)*100.0/count(*),2),"%")as "CTR",
concat(round(sum(click=0)*100.0/count(*),2),"%")as "Bounce Rate",
concat(round(sum(session_time>=5)*100.0/count(*),2),"%")as "long session_rate",
concat(round(sum(session_time<3)*100.0/count(*),2),"%")as  "short session rate",
avg(session_time) as "Avg_session_time"
from ab_test_cleaned
group by groups_exp;







# -(d) Split Funnel by device_type Group(based on CTR,Bounce Rate,Avg session time)
select
device_type as variant,
count(*) as 'sessions',
sum(click=1) as "Clicked",
sum(session_time>=5) as "Long Session (5+ min)",
concat(round(sum(click=1)*100.0/count(*),2),"%")as "CTR",
concat(round(sum(click=0)*100.0/count(*),2),"%")as "Bounce Rate",
concat(round(sum(session_time>=5)*100.0/count(*),2),"%")as "long session_rate",
concat(round(sum(session_time<3)*100.0/count(*),2),"%")as  "short session rate",
avg(session_time) as "Avg_session_time"
from ab_test_cleaned
group by device_type;

ALTER TABLE ab_test_cleaned
DROP PRIMARY KEY;

ALTER TABLE ab_test_cleaned
DROP INDEX user_id;

-- Create a few repeating users
UPDATE ab_test_cleaned
SET user_id = FLOOR(1 + (RAND() * 10000));  -- assigns ~10k random users







# 6 -Cohort Analysis 
# (A technique used to identify behaviour of customer engagememnet overtime by grouping them into cohorts)
#Cohort Anlaysis Based on  Sessions


WITH cohort1 AS (
  SELECT user_id,
    DATE(MIN(click_time)) AS 'cohort_day'
    from ab_test_cleaned
    where click_time is not null
    group by user_id),
    
    
    cohort2 as (
    select user_id,
    date(click_time) as 'activity_day'
    from ab_test_cleaned
    where click_time is not null),
    
    
    
    cohort3 as (
    select c.cohort_day,
    d.activity_day,
    timestampdiff(day,c.cohort_day,d.activity_day) as "cohort_index"
    from cohort1 c join cohort2 d
    on c.user_id=d.user_id)

    select cohort_day,
    cohort_index,
    count(*) as "Session" from
    cohort3
    group by cohort_day,cohort_index
    order by cohort_day,cohort_index;
    
    
    
    
    
    
# Cohort Anlaysis based on Total Clicks

WITH cohort1 AS (
  SELECT user_id,
    DATE(MIN(click_time)) AS 'cohort_day'
    from ab_test_cleaned
    where click_time is not null
    group by user_id),
    
    
    cohort2 as (
    select user_id,
    date(click_time) as 'activity_day',
    click
    from ab_test_cleaned
    where click_time is not null),
    
    
    
    cohort3 as (
    select c.cohort_day,
    d.activity_day,
    timestampdiff(day,c.cohort_day,d.activity_day) as "cohort_index",
    click
    from cohort1 c join cohort2 d
    on c.user_id=d.user_id)

    select cohort_day,
    cohort_index,
    sum(click=1) as "Total Clicks" from
    cohort3
    group by cohort_day,cohort_index
    order by cohort_day,cohort_index;
  
  

  
  
 # 6 - Finding Retention Rate 
  
WITH cohort1 AS (
  SELECT user_id,
         DATE(MIN(click_time)) AS cohort_day
  FROM ab_test_cleaned
  WHERE click_time IS NOT NULL
  GROUP BY user_id
),

cohort2 AS (
  SELECT user_id,
         DATE(click_time) AS activity_day,
         click
  FROM ab_test_cleaned
  WHERE click_time IS NOT NULL
),

cohort3 AS (
  SELECT c.cohort_day,
         d.activity_day,
         TIMESTAMPDIFF(DAY, c.cohort_day, d.activity_day) AS cohort_index,
         d.user_id
  FROM cohort1 c
  JOIN cohort2 d ON c.user_id = d.user_id
),

cohort4 AS (
  SELECT cohort_day,
         COUNT(DISTINCT user_id) AS counts
  FROM cohort1
  GROUP BY cohort_day
),

cohort_analysis AS (
  SELECT 
    c.cohort_day,
    c.cohort_index,
    COUNT(DISTINCT c.user_id) AS sessions,
    d.counts,
    ROUND(COUNT(DISTINCT c.user_id) * 100.0 / d.counts, 2) AS retention_rate
  FROM cohort3 c
  JOIN cohort4 d ON c.cohort_day = d.cohort_day
  GROUP BY c.cohort_day, c.cohort_index, d.counts
)

SELECT * FROM cohort_analysis
ORDER BY cohort_day, cohort_index;

    
    
#7 - FInding Retention Rate based A/B test cohort performance analysis.


WITH cohort1 AS (
  SELECT groups_exp, user_id,
         DATE(MIN(click_time)) AS cohort_day
  FROM ab_test_cleaned
  WHERE click_time IS NOT NULL
  GROUP BY groups_exp, user_id
),

cohort2 AS (
  SELECT user_id,
         DATE(click_time) AS activity_day
  FROM ab_test_cleaned
  WHERE click_time IS NOT NULL
),

cohort3 AS (
  SELECT c.groups_exp,
         c.cohort_day,
         d.activity_day,
         TIMESTAMPDIFF(DAY, c.cohort_day, d.activity_day) AS cohort_index,
         d.user_id
  FROM cohort1 c
  JOIN cohort2 d ON c.user_id = d.user_id
),

cohort4 AS (
  SELECT groups_exp, cohort_day,
         COUNT(DISTINCT user_id) AS cohort_users
  FROM cohort1
  GROUP BY groups_exp, cohort_day
),

cohort_analysis AS (
  SELECT 
    c.groups_exp,
    c.cohort_day,
    c.cohort_index,
    COUNT(DISTINCT c.user_id) AS active_users,
    d.cohort_users,
    ROUND(COUNT(DISTINCT c.user_id) * 100.0 / d.cohort_users, 2) AS retention_rate
  FROM cohort3 c
  JOIN cohort4 d 
    ON c.groups_exp = d.groups_exp AND c.cohort_day = d.cohort_day
  GROUP BY c.groups_exp, c.cohort_day, c.cohort_index, d.cohort_users
)

SELECT * FROM cohort_analysis
ORDER BY groups_exp, cohort_day, cohort_index;


 
















