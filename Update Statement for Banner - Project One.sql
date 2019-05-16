/*

LOGIC
All below get added to the course on SCADETL if not already present AND to the ACTIVE sections on SSADETL for all terms 201430-201910 if not already present
Add attribute 'RPS' to
Any course with subject code SRVC OR
Any course with number X89X 

*/

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

declare 
type subjectsarray IS VARRAY(3) OF VARCHAR2(10); 
subjects subjectsarray;
 total integer; 

begin
    subjects := subjectsarray('ASTR 1100', 'EBIO 4310', 'PHYS 1010', 'PHYS 1210', 'PHYS 1310', 'PHYS 1320', 'PSYC 3130', 'PSYC 3775 CELL 1010', 'CELL 2115', 'CELL 1030', 'CELL 1035', 'CHEM 1070', 'CHEM 1075', 'CHEM 1080', 'CHEM 1085', 'EENS 1110', 'EENS 1115', 'EENS 1120', 'EENS 1125', 'EENS 1300', 'EENS 1305', 'EBIO 1010', 'EBIO 1015', 'EBIO 2330', 'EBIO 2335', 'EBIO 3180', 'EBIO 3185');
    total := subjects.count; 
    for i in 1 .. total loop
       update (
            select scrattr_subj_code, scrattr_eff_term, scrattr_attr_code, scbcrse_csta_code
            from scrattr
            inner join scbcrse
            on scrattr.scrattr_crse_numb like scbcrse.scbcrse_crse_numb 
            where  (scrattr.scrattr_subj_code = subjects(i)) and (scrattr_crse_numb like '%89%') and (scrattr_eff_term between '201430' and '201910')  and (scbcrse_csta_code = 'A')
    )   
        set scrattr_attr_code = 'RSL' ;
    end loop;
end;



