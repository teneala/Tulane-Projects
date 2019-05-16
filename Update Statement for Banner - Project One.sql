/*

The block of code below satisifies the first logic set:

LOGIC SET ONE
All below get added to the course on SCADETL if not already present AND to the ACTIVE sections on SSADETL for all terms 201430-201910 if not already present
Add attribute 'RPS' to
Any course with subject code SRVC OR
Any course with number X89X 

*/

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Looks for courses whose subject code and course number match, whose numbers have x89x, are currently listed as active, whose effective term is between 201430 and 201910, and whose attribute is missing "RPS"
update (
    select scrattr_subj_code, scrattr_eff_term, scrattr_attr_code, scbcrse_csta_code
    from scrattr
    inner join scbcrse
    on scrattr.scrattr_crse_numb like scbcrse.scbcrse_crse_numb 
    where  (scrattr.scrattr_subj_code = scbcrse.scbcrse_subj_code) and (scrattr_crse_numb like '%89%') and (scrattr_eff_term between '201430' and '201910') and (scrattr_attr_code != 'RPS') and (scbcrse_csta_code = 'A')
    )   
set scrattr_attr_code = 'RPS';

-- Separate update statement for courses whose subject code  is "SRVC" because the above statement is under the condition that the subject code and course number be the same. Condition would never be met because the logic is disjointed.
update (
   select scrattr_attr_code
    from scrattr
    inner join scbcrse
    on scrattr.scrattr_crse_numb like scbcrse.scbcrse_crse_numb 
    where (scrattr_subj_code = 'SRVC') and (scbcrse_csta_code = 'A') and (scrattr_attr_code != 'RPS') and (scrattr_crse_numb like '%89%') 
    )   
set scrattr_attr_code = 'RPS';

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



-- The code below satisifes this requirement
-- Add attribute 'RSL' to
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Update statement for the list of specified courses. Adds the 'RSL' attribute to the courses listed in the array as outlined in the logic on the Trello Board
-- Used an array to iterate through the course list to avoid the same set stament over and over
declare 
type subjectsarray IS VARRAY(20) OF VARCHAR2(10); 
subjects subjectsarray;
type numbersarray IS VARRAY(20) OF VARCHAR2(10); 
crsenumber numbersarray;
total integer; 

begin
    subjects := subjectsarray('ASTR', 'EBIO', 'PHYS', 'PHYS', 'PHYS', 'PHYS', 'PSYC', 'PSYC',' CELL', 'CELL', 'CELL', 'CELL', 'CHEM', 'CHEM', 'CHEM', 'CHEM', 'EENS', 'EENS', 'EENS', 'EENS', 'EENS', 'EENS', 'EBIO', 'EBIO', 'EBIO', 'EBIO', 'EBIO', 'EBIO');
    crsenumber := numbersarray('1100', '4310', '1010', '1210','1310','1320', '3130', '3775', '1010', '2115', '1030', '1035', ' 1070', '1075', '1080', '1085', '1110', '1115', '1120', '1125', '1300', '1305',  '1010', '1015', '2330', '2335', '3180', '3185' );
    total := subjects.count; 
    for i in 1 .. total loop
       update (
            select scrattr_subj_code, scrattr_eff_term, scrattr_attr_code, scbcrse_csta_code
            from scrattr
            inner join scbcrse
            on scrattr.scrattr_crse_numb like scbcrse.scbcrse_crse_numb 
            where  (scrattr.scrattr_subj_code = subjects(i)) and (scrattr_crse_numb= crsenumber(i)) and (scrattr_eff_term between '201430' and '201910')  and (scbcrse_csta_code = 'A')
    )   
        set scrattr_attr_code = 'RSL' ;
    end loop;
end;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--The following code satisifies this requirement:
--Add attribute RMNS to
--CHEM 1070, CHEM 1080

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

update (
            select scrattr_subj_code, scrattr_eff_term, scrattr_attr_code, scbcrse_csta_code, scrattr_crse_numb
            from scrattr
            inner join scbcrse
            on scrattr.scrattr_crse_numb like scbcrse.scbcrse_crse_numb 
            where  (scrattr.scrattr_subj_code = 'CHEM') and (scrattr_crse_numb = '1070' or scrattr_crse_numb = '1080' ) and (scrattr_eff_term between '201430' and '201910')  and (scbcrse_csta_code = 'A')
    )   
        set scrattr_attr_code = ' RMNS' ;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





