SELECT * FROM dbms2.mlb_payrolls;


##1. **Rank all teams by total payroll in descending order.**
select 	`Team Name`, `Total Payroll Allocations`, rank () over ( order by `Total Payroll Allocations` desc) as Payroll_rank 
from dbms2.mlb_payrolls;

##2. **Assign a row number to each team based on their number of wins, highest to lowest.**
Select 	`Team Name`,wins , row_number () over( order by wins desc ) as Team_rank 
from dbms2.mlb_payrolls;

#3. **For each team, show the difference in total payroll from the previous team in the ranking.**
select `Team Name`, `Total Payroll Allocations`, Abs(`Total Payroll Allocations` - lag(`Total Payroll Allocations`) over ( order by `Total Payroll Allocations` desc)) as payroll_difference
from dbms2.mlb_payrolls;

#4. **Calculate the cumulative total of payroll allocations as you go from the highest to the lowest.**
select `Team Name`, `Total Payroll Allocations`, sum(`Total Payroll Allocations`) over ( order by `Total Payroll Allocations` desc ) as Cummulative_payroll
from dbms2.mlb_payrolls;

#5. **For each team, find the next team’s number of wins.**
select `Team Name`, `wins`, lead(wins) over (order by wins desc) as next_team_wins
from dbms2.mlb_payrolls;

#6. **Partition the teams by postseason result and rank them by total payroll within each group.**
select `Team Name`, Postseason,`Total Payroll Allocations`,
rank () over( partition by postseason order by `Total Payroll Allocations` desc) as payroll_rank_within_postseason 
from dbms2.mlb_payrolls;

#7. **Divide the teams into 4 groups based on number of wins using NTILE.**
select  `Team Name`,wins,
ntile(4) over( order by wins desc) as quartile_wins
from dbms2.mlb_payrolls;

#8. **Find the percentage rank of each team based on payroll allocations.**
select 	`Team Name`, `Total Payroll Allocations`, percent_rank () over ( order by `Total Payroll Allocations` ) as payroll_percent_rank 
from dbms2.mlb_payrolls;

#9. **For each team, calculate the running total of wins ordered by team name alphabetically.**
select 	`Team Name`, wins, sum(wins) over ( order by `Team Name`) as running_total_wins
from dbms2.mlb_payrolls;

#10. **List the top 2 teams with the highest active 26-man payroll in each postseason category.**
select * from (select `Team Name`,`Active 26-Man`,Postseason, row_number() over ( partition by Postseason order by `Active 26-Man` desc) as team_rank 
from dbms2.mlb_payrolls) as ranked
where team_rank  <= 2 ;

#11. **For each team, show the difference between their wins and the average wins across all teams.**
select `Team Name`, wins,wins - avg(wins) over () as Win_avg_diff
from dbms2.mlb_payrolls;

#12. **Within each postseason category, assign a rank to teams based on the lowest number of losses.**
select `Team Name`, postseason, losses, rank () over(partition by postseason order by losses) as team_rank
from dbms2.mlb_payrolls;


#13. **Which team has the largest difference between active 26-man payroll and injured payroll compared to the others?**
select `Team Name`, `Active 26-Man`,Injured, abs(`Active 26-Man` - Injured) as diff,
rank() over( order by abs(`Active 26-Man` - Injured) desc) as diff_rank
from dbms2.mlb_payrolls ;


#14. **Show the name of each team and the previous team’s win total ordered by total payroll descending.**
select `Team Name`, `Total Payroll Allocations`, wins, lag(wins) over(order by `Total Payroll Allocations` desc ) as Prev_teams_win
from dbms2.mlb_payrolls ;

#15. **Calculate the average team age per postseason category and assign a rank based on the youngest teams.**
select `Team Name`, postseason ,`average age` , rank () over(partition by  postseason order by `average age` )
from dbms2.mlb_payrolls ;

