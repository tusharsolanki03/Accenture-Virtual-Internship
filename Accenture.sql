create database Accenture;
use accenture;

#data cleaning content table
select * from content;
desc content;

# removing " from category column as some duplicate categories contains "
UPDATE content SET category = replace(category, '"', "");

desc content;
select * from content;
alter table content 
    drop column URL,
    drop column `user id`,
    change column type `Content Type` varchar(10),
    modify column `Content ID` varchar(50),
	modify column `Category` varchar(20);


#cleaning data reaction
select * from reactions;
desc reactions;

# count of rows where type is blank
select count(*) from reactions
where `Type` is null or `Type`="";

# deleting rows where type is blank
delete from reactions
where `Type` is null or `Type`="";

alter table reactions modify column `datetime` datetime;
alter table reactions
    drop column	`user ID`,
    modify column `Content ID` varchar(50),
    change column `Type` `Reaction Type` varchar(20);

#cleaning data reaction type
select * from reactiontypes;
desc reactiontypes;

# renaming column "type" and "score" and changing data type of column "type"
alter table reactiontypes
    change column Type `Reaction Type` varchar(20),
    change column Score `Reaction score` int;
    
    
select a.`Content ID`,b.Category,b.`Content Type`,a.`Reaction Type`,c.sentiment,c.`Reaction Score`,a.`datetime`
from reactions as a left join content as b
on a.`content id`=b.`content id`
left join reactiontypes as c 
on a.`reaction type`=c.`reaction type`
order by category ;


select b.Category,sum(c.`Reaction Score`)`Total Score`
from reactions as a left join content as b
on a.`content id`=b.`content id`
left join reactiontypes as c 
on a.`reaction type`=c.`reaction type`
group by b.Category
order by `total score` desc;


select category,`Total Score` from (select b.Category,sum(c.`Reaction Score`)`Total Score`, dense_rank() over(order by sum(`Reaction score`)desc)`Rank`
from reactions as a left join content as b
on a.`content id`=b.`content id`
left join reactiontypes as c 
on a.`reaction type`=c.`reaction type`
group by b.Category)ABC
where `rank`<=5;

