-- create or replace procedure check_client_status(
--     p_client_id in T_PERSON.id%type,
--     p_total_spent out T_PRODUCT.price%type
-- ) is
-- begin
--     select id from T_PERSON where id=p_client_id;
--     exception when no_data_found then raise_application_error(-20001, 'Client ID [id] not found.');
--
--     for i in (select pl.quantity as qua, p.price as pri from T_PRODUCT p join S32802.T_PRODUCTLIST pl on p.ID = pl.IDPRODUCT)
-- end;


-- Task 1
-- Write a simple program in PL/SQL. Declare a variable, assign the number of records from the _Person
-- table to this variable and print the result using DBMS_OUTPUT. The output should look like this:
--                        "There are 99 records in the T_Person table".
declare
    records int;
    begin
    select count(id) into records from T_Person;
    dbms_output.put_line('There are ' || records || ' records in the T_person table');
end;

-- Task 2
-- Count the number of records in the T_Person table. If there are less than 11 records then sert a new
-- person and print a message "Added Name Surname with id= idNumber". If there are already 11
-- records or more then simply print a message stating that no data was inserted. Let the new person's
-- Id take the value of the largest existing id + 1 from T_Person table.
declare
    records int;
    maximum int;
    begin
    select count(*) INTO RECORDS FROM T_PERSON;
    select max(id) into maximum from T_PERSON;
    if records < 12 then
        maximum:=maximum+1;
        insert into T_PERSON values (maximum, 'No_name', 'No_suraname');
        dbms_output.put_line('Added Name Surname with id=' || maximum || ' idNumber');
    else
        dbms_output.put_line('No data was added');
    end if;
end;

-- Task 3
-- In the anonymous block, handle errors (in EXCEPTION) such as no_data_found, too_many_rows, dup_val_on_index
-- including all other errors. Depending on the type of error list "Record not found", "More than one record
-- found", "PK constraints violated" and "Other error" respectively. Declare a variable v_name of type
-- Varchar2 in order to test errors on it. Then try the following operations one at a time:
-- -Assign the product name with id = 15 to the v_name variable (no_data_found error)
-- -Assign product names with id IN (1,2,3) to the v_name variable (too_many_rows error)
-- -Add a new product with id=1 (dup_val_
-- _on_index error)
-- -Assign 10/0 to the v_name variable (other error)
declare
    v_name varchar2(50);
    begin
--         select name into v_name from T_PRODUCT where id=13;
--         select name into v_name from T_PRODUCT where id in (1,2,3);
--         insert into T_PRODUCT values (1, 'no', 12.3, 1);
        v_name := 10/0;
exception
    when no_data_found then
        dbms_output.put_line('Record not found');
    when too_many_rows then
        dbms_output.put_line('More than one record found');
    when dup_val_on_index then
        dbms_output.put_line('PK constraints violated');
    when others then
        dbms_output.put_line('Other errors');
end;

-- Task 4
-- Create a procedure called "UpdatePrice" that will increase the price of all products by the
-- value given in the parameter. If the value is not provided then it should be increased by 0.01
-- (using the DEFAULT parameter). Additionally we want to print a message with information by
-- how much price was increased and how many records were modified (using the
-- SQL%ROWCOUNT system variable).
create or replace procedure UpdatePrice(
    increse in number default 0.01
) is
    numb int;
begin
    update T_PRODUCT set price=price*increse;
    numb:=sql%rowcount;
        dbms_output.put_line('Price was increased by: ' || increse || '. ' || numb || ' records was modified');
end;

begin
    UpdatePrice(1.0);
end;

-- Task 5
-- Write the "EmployeeData" procedure that will accept the employee's ID and return his First Vame and Last
-- Name using the OUT parameter. If the employee with the given ID does not xist, we should return information:
-- "The employee with the given ID does not exist."
create or replace procedure EmployeeData(
    e_id in T_EMPLOYEE.id%type,
    e_name out T_PERSON.name%type,
    e_lastname out T_PERSON.name%type
) is
begin
    select p.name, p.surname into e_name, e_lastname from T_EMPLOYEE e join T_PERSON p on e.ID = p.ID where p.id=e_id;
    exception
    when no_data_found then dbms_output.put_line('The employee with the given ID does not exist.');
end;

declare
    name T_PERSON.name%type;
    surname T_PERSON.name%type;
begin
    EmployeeData(12, name, surname);
    dbms_output.put_line(name || ' ' || surname);
end;

-- Task 6
-- Write a procedure called "NewPurchase" that will create a new purchase for a given customer with
-- today's date. The procedure should take the customer's ID as a parameter and return the ID of the created
-- purchase in the OUT parameter. The primary key "id" in the T_Purchase table has the IDENTITY property,
-- that means the id is generated automatically thus we do not provide this value. Inside the procedure
-- we want to print the information "New purchase has been registered with id: [id!". We also want to be
-- able to capture the Id of a newly created purchase and print it outside of the procedure (using OUT
-- parameter).
-- TIP: for a date of the new purchase you can use: to_date(current_date, 'YYYY-MM-DD').
create or replace procedure NewPurchase(
    idC in integer,
    idP out int
) is
begin
    insert into T_PURCHASE ("Date", IDCLIENT) values(trunc(sysdate), idC) returning id into idP;
    dbms_output.put_line('New purchase has been registered with id: ' || idP);
end;

declare
    id int;
begin
    NewPurchase(1,id);
    dbms_output.put_line('New purchase has been registered with id: ' || id);
end;

-- Task 7
-- Create a procedure called "AddProductToPurchase" which will add the product to a given purchase. As
-- parameters the procedure should take IdProduct, Quantity and IdPurchase, which we receive from the
-- "NewPurchase" procedure (from Task 6) via the OUT parameter.
-- You should check whether the product and purchase with the given ID exist and whether the quantity is
-- greater than O, if not, print an appropriate message and cancel the procedure (you can use RETURN statement).
-- If a given product is already assigned to a given purchase, we simply increase its quantity in UPDATE and
-- print "Product [id] increased in purchase [id] by:
-- [quantity]"
-- ". Otherwise, we add the product to the purchase and print: "Product [id] added to
-- purchase [id], quantity: [quantity]"
-- Using these procedures, create a new purchase for a client with id=1, capture purchase id and add to it
-- a product with id=1 in quantity of 1. Do it twice for the same purchase, so that you get 1 insert and 1
-- update.
create or replace procedure AddProductToPurchase(
    v_productid T_Product.id%type, v_quantity int, v_purchaseid T_Purchase.id%type
) is
    pro_count int;
    pur_count int;
    qua_count int;
begin
    select count(*) into pro_count from T_PRODUCT where id=v_productid;
    select count(*) into pur_count from T_PURCHASE where id=v_purchaseid;
    select count(*) into qua_count from T_PRODUCTLIST where v_purchaseid=IDPURCHASE and v_productid=IDPRODUCT;
    if v_quantity <= 0 then
        dbms_output.put_line('Qua no no');
    ELSIF pro_count <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Product does not exist');
    ELSIF pur_count <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Purchase does not exist');
    ELSIF qua_count > 0 THEN
        UPDATE T_ProductList
        SET quantity= quantity + v_quantity
        WHERE idpurchase= v_purchaseid AND idproduct= v_productid;
        DBMS_OUTPUT.PUT_LINE('Product ' || v_productid
            ||' increased in purchase ' || v_purchaseid ||' by ' || v_quantity);
    ELSE
        INSERT INTO T_ProductList(idpurchase, idproduct, quantity)
        VALUES(v_purchaseid, v_productid, v_quantity);
        DBMS_OUTPUT.PUT_LINE('Product ' || v_productid
            ||' added to purchase' || v_purchaseid || ', quantity: ' || v_quantity);
    end if;
end;
DECLARE
    v_id int;
BEGIN
    NewPurchase(1,v_id);
    AddProductToPurchase(1, 1,v_id);
    AddProductToPurchase(1, 1,v_id);
END;

-- Task 8
-- Write a procedure that will update the job of a given employee. The procedure is to assign the employee
-- to a new job with today's date (you can use: to_char(sysdate, 'YYYY-MM-DD')) and at the same time ' ||
-- 'remove him from the old job also with today's date ("To" column in the _Employment table). The
-- procedure should accept v_Employeeld and v_Jobld as arguments. If the employee is currently assigned
-- to the given job, we do not add him again but instead print the message "The employee is already assigned
-- to this job". If the employee or job with the given id does not exist, we print the appropriate message
-- "Employee/Job does not exist" and cancel the procedure (you can use the RETURN statement). The job for
-- a given employee can be changed only once a day, if today's date already exists in the "To" column in
-- the _Employment table for a given employee, then we do not update his job and print the information:
-- "Changes have not been saved, the job can only be updated once a day for a given employee."
create or replace procedure UpdateEmployeeJob(
    id_emp in T_Employee.Id%type,
    id_job in T_Job.Id%type
)
    is
    emp_exist number;
    job_exist number;
    current_job_id T_Employment.IdJob%type;
    today_to_count number;
begin
    select count(*) into emp_exist from T_Employee where Id = id_emp;
    select count(*) into job_exist from T_Job where Id = id_job;

    if emp_exist = 0 or job_exist = 0 then
        dbms_output.put_line('Employee/Job does not exist.');
        return;
    end if;

    begin
        select IdJob into current_job_id from T_Employment
        where IdEmployee = id_emp
          and "To" is null;

        if current_job_id = id_job then
            dbms_output.put_line('The employee is already assigned to this job.');
            return;
        end if;
    exception
        when no_data_found then
            null;
    end;

    select count(*) into today_to_count from T_Employment
    where IdEmployee = id_emp and TRUNC("To") = TRUNC(SYSDATE);

    if today_to_count > 0 then
        dbms_output.put_line('Changes have not been saved, the job can only be updated once a day for a given employee.');
        return;
    end if;

    update T_Employment
    set "To" = TRUNC(SYSDATE)
    where IdEmployee = id_emp and "To" is null;

    insert into T_Employment (IdJob, IdEmployee, "From")
    values (id_job, id_emp, TRUNC(SYSDATE));

    dbms_output.put_line('Employee ' || id_emp || ' job updated to ' || id_job || ' on ' || to_char(sysdate, 'YYYY-MM-DD'));

    commit;
exception
    when others then
        dbms_output.put_line('Error updating employee job: ' || sqlerrm);
        rollback;
end UpdateEmployeeJob;
declare
    e_id constant T_Employee.Id%type := 1;
    j_id_new constant T_Job.Id%type := 2;
    j_id_same constant T_Job.Id%type := 1;
begin
    UpdateEmployeeJob(e_id, j_id_new);

        UpdateEmployeeJob(e_id, j_id_same);

    UpdateEmployeeJob(999, j_id_new);
end;




-- Task 1
-- Using a cursor go through all products (T_Product table) and modify prices in the following way:
-- products cheaper than $2 should be discounted by 10% and products cheaper than $1
-- should have their price raised by 5%. For every modified record print: Price of {product_name} was
--     changed to: {new_price}$". Use LOOP and IF. Round the price to 2 digits after the decimal point.
declare
    cursor nameC is
    select name, price from T_PRODUCT;
    c_name T_PRODUCT.name%type;
    c_price T_PRODUCT.price%type;
begin
    open nameC;
    loop
        fetch nameC into c_name, c_price;
        exit when nameC%notfound;
        if c_price < 2 then
            c_price:=round(c_price-c_price*0.1,2);
            update T_Product set price=c_price where name=c_name;
        elsif c_price<1 then
            c_price:=round(c_price+c_price*0.05,2);
            update T_Product set price=c_price where name=c_name;
        end if;
        dbms_output.put_line('Price of ' || c_name || ' was changed to: ' || c_price || '$.');
    end loop;
    close nameC;
    commit;
end;

-- Task 2
-- Rewrite the code from task 1 into a procedure that uses a cursor so that the values for price
--     increase/decrease are not constants but parameters instead. Use CASE instead of IF.
CREATE OR REPLACE PROCEDURE PriceChange (v_LowValue T_Product.price%type,
                                         v_HighValue T_Product.price%type) IS
cursor nameC is
select name,
       case
           when price < v_LowValue then round(price*1.05,2)
            when price > v_HighValue then round(price*0.9,2)
            else price
        end
    from T_Product WHERE price NOT BETWEEN v_LowValue AND v_HighValue;
    v_productname T_Product.name%type;
    v_productprice T_Product.price%type;
    begin
        open nameC;
        loop
            fetch nameC into v_productname, v_productprice;
            exit when nameC%notfound;
            update T_PRODUCT set price=v_productprice where name=v_productname;
            DBMS_OUTPUT.PUT_LINE('Price of ' || v_productname
                ||' was changed to: ' || v_productprice || '$');
        end loop;
        close nameC;
    end;
    ALTER TRIGGER INUPDEL DISABLE;
CALL PriceChange(1,2);

-- Task 3
-- Create a new supply order (table T_Supply) with today's date. Then, using the cursor, assign to this
-- supply order (by creating a record in T_
-- _SupplyProduct table) all products that sold
-- more than 10 pieces in December 2022, quantity should be twice the amount sold. After
-- adding each product to the supply order print the information: "The product with ID = {id} in
-- quantity = {quantity} was ordered". Do not use IF.
-- ip: First you need to create a new record in the T_Supply table and capture the generated id
-- (PK has the Identity property). Then, using a cursor, you need to create records in T_SupplyProduct
-- table for each product.
declare
    cursor products is
    select sp.idsupply, sum(sp.QUANTITY) from T_SUPPLYPRODUCT sp
        join T_SUPPLY s on sp.IDSUPPLY = s.ID
            where s."Date" between
                to_date('30-11-2022', 'DD-MM-YYYY') and to_date('01-01-2023', 'DD-MM-YYYY')
    group by sp.idsupply
    having sum(sp.QUANTITY)>10;
    idP int;
    v_IdProduct T_Product.id%type;
    v_ProductQuantity T_productList.quantity%type;
begin
    insert into T_SUPPLY ("Date") values (trunc(sysdate)) returning id into idP;
    open products;
    loop
        fetch products into v_IdProduct, v_ProductQuantity;
        exit when products%notfound;
        INSERT INTO T_SupplyProduct VALUES (idP, v_IdProduct,
                                            v_ProductQuantity);
        DBMS_OUTPUT.PUT_LINE('The product with ID= ' || v_IdProduct ||
                             ' was ordered in quantity= ' || v_ProductQuantity);
    end loop;
    close products;
end;

-- Task 4
-- Add an extra nullable column called "Bonus" with Number (8,2) type to the T_Employee table.
-- Then, using the cursor, assign a bonus value to each currently employed employee. The bonus is calculated
-- based on how many months they had worked, use the following formula: salary * number_of_months/100.
-- It is granted only to employees who have worked for at least 6 months and cannot amount to more than
-- 30% of the salary. Create a View that stores employee's ID and his/her seniority in months, which ' ||
-- 'will be used by the cursor. After adding the bonus print: "Employee from id= {id} has been assigned a ' ||
-- 'bonus in the amount of= {bonus} % of salary."
-- For example:
-- - the bonus for an employee who has worked for 35 months will amount to 30% of the salary
-- - the bonus for an employee who has worked for 27 months will amount to 27% of the salary
-- - an employee who has only worked for 3 months will not receive a bonus
-- Hint:
-- To calculate the seniority in months, use the months_between() function. Currently employed employees ' ||
-- 'have at least one NULL in the "To" column in the _Employment table. To determine how long the given ' ||
-- 'employee had been employed you should consider the earliest
-- "From" date in _Employment table, taking into account all of his jobs and subtract it from today's
--     date (current_date).
ALTER TABLE T_Employee
    ADD Bonus Number(8,2) NULL;
create view EmployeeSeniority(Employee, Seniority) as
    select IDEMPLOYEE, abs(months_between(trunc(sysdate), min("From")))
    from T_EMPLOYMENT where IdEmployee IN (SELECT IdEmployee
                                          FROM T_Employment
                                          WHERE "To" IS NULL)
                           GROUP BY IdEmployee;


-- Task 5
-- Add an extra nullable column called "Favorite_product" with integer type to the T_Person
-- table. Then, using the cursor, assign the ID of a product given person bought in the greatest
-- quantity in all his purchases as his favorite product. After adding the product, write the
-- information: "Favorite product with id= {id} has been assigned to a person with id= fid}."
ALTER TABLE T_Person
    ADD Favourite_product integer null;
ALTER TABLE T_Person
    ADD CONSTRAINT FK_Person_Product FOREIGN KEY (Favourite_product)
        REFERENCES T_Product (Id);




-- Task 1
-- Create a simple trigger that will not allow us to delete records from the ProductList table.
-- Use raise_application _error to print "You cannot delete records from T_ProductList"
-- Delete a record prior to creating a trigger as a test, it will work:
-- DELETE FROM T_Productlist
-- WHERE IdPurchase = 55 AND IdProduct = 4;
-- Then, after creating the trigger, try deleting another record:
-- DELETE FROM T_Productlist
-- WHERE IdPurchase = 55 AND IdProduct = 5;
create or replace trigger Deletiing
    before delete on T_PRODUCTLIST
    begin
        raise_application_error(-200001, 'You cannot delete records from T_ProductList');
    end;
DELETE FROM T_ProductList
WHERE IdPurchase = 55 AND IdProduct = 5;

-- Task 2
-- Transform the trigger from task 1 so that it also prints the following information: "Failed to delete
-- record for purchase=(IdPurchase) and product={ldProduct}." Use the : OLD reference for this purpose
-- (the trigger must be FOR EACH ROW in order for this to work).
-- After updating the trigger, try deleting the record from the table again:
-- DELETE FROM T ProductList
-- WHERE IdPurchase = 55 AND IdProduct = 5;
create or replace trigger Deletiing
    before delete on T_PRODUCTLIST
for each row
begin
    raise_application_error(-20001, 'You cannot delete records from T_ProductList ' || :old.IDPRODUCT || ' ' || :old.IDPURCHASE);
end;
DELETE FROM T_ProductList
WHERE IdPurchase = 55 AND IdProduct = 5;

-- Task 3
-- Drop the trigger from task 1 & 2, and then write an AFTER DELETE trigger for the T_Purchase table that
--     will delete all records from T_ProductList associated with the purchase
-- being deleted. Additionally, print the information: "Purchase with id = {id} was deleted"
-- Before creating the trigger, try deleting the purchase with id = 1, this will raise an error;
-- DELETE FROM T_Purchase WHERE id = 1;
drop trigger Deletiing;


-- Task 4
-- Create a BEFORE trigger for the T_Employee table which will check whether the new salary (inserted or
-- updated) is greater or less than 10,000. If it's greater than 10,000 then the trigger should report an ' ||
--  'error via raise_application_error and prevent the record from being inserted or updated.
-- Note: In this task, we use the trigger only for training purposes, because such functionality would be ' ||
--  'best implemented by creating a CHECK constraint on the salary column as follows:
-- ALTER TABLE T_Employee
-- ADD CONSTRAINT CHK_Salary CHECK (Salary <10000)
-- After creating the trigger, try updating the employee's salary to be greater than 10,000:
UPDATE T_Employee
SET salary = 5000
WHERE id =2;
-- ALTER TABLE T_Employee ADD CONSTRAINT CHK_Salary CHECK (Salary <10000);
create or replace trigger insertiing
    before insert or update
    on T_EMPLOYEE
    for each row
    begin
        if :new.salary > 10000 then
            raise_application_error(-20001,
                                    'Salary exceeds the limit, DMI
                                    operation failed.');
        end if;
    end;


-- Task 5
-- Create a "BEFORE UPDATE OF price" trigger for T_Product table that will not allow you to lower the price.
-- When we try to reduce the price we get an error: "The price cannot be reduced"
-- Once you've created your trigger, try reducing the price of one of your products
-- UPDATE T_Product
-- SET price = 0.01
-- WHERE id = 2;


-- Task 6
-- Drop the trigger from task 5, then write one trigger for T_Product that:
-- - will not allow adding a product with a price greater than 100 (in INSERT)
-- - will not allow the product price to be increased (in UPDATE)
-- - when deleting a product, it will delete all records for a given product from the T_ProductList table.


-- Task 7
-- Create a BEFORE INSERT trigger for the T_Person table that will not allow adding a new person if there is already a person with the same surname. If such a surname does not exist yet, then we add a new person with the information: "'name} has been successfully added."
-- After creating the trigger, try adding a person whose name already exists in T Person:
-- INSERT INTO T Person
-- (11,
-- (id, name, surname) VALUES (11, 'Tim',
-- "Theramenes') ;


-- Task 8
-- Create a BEFORE UPDATE trigger for the T_Employment table that will not allow you to update the values
-- of any of the columns except the To column. Additionally, the To column can only be updated if its value
-- is NULL and cannot be assigned a To date earlier than the
-- From date.
-- Hint: use IF UPDATING ('IdEmployee') OR UPDATING('IdJob') OR
-- UPDATING ('From') THEN


-- Task 9
-- eate a table T_SoldProducts with one "Total Value" column that will store the value of all products
-- sold and will always contain only one row. Create one trigger that will ensure that the value in
-- the T_SoldProducts table is always up to date. For all operations updating the
-- T_ ProductList table (INSERT, UPDATE, DELETE), the trigger should update the value in the T_SoldProducts table.
-- Creating the T_SoldProducts table and assigning values to the "TotalValue" column:
-- CREATE TABLE T SoldProducts (
-- TotalValue number (8,2) not null
-- DECLARE
-- v_value number (8, 2) ;
--     BEGIN
--     SELECT SUM(price * quantity) INTO v_
--     _value FROM T_Productlist pI JOIN
--     T_Product p ON pI. idproduct = p.id;
--     INSERT INTO T
--     SoldProducts VALUES
-- (V
--  value) ;
--     END;


-- Task 10
-- Create a View that includes the employee's name, salary and job. Then create an INSTEAD OF trigger for ' ||
--  'this View that will add a record to the database. If a person with the given name and surname does not ' ||
--  'exist, we add him to the _Person table and proceed in the same way with the employee. If the employee ' ||
--  'already exists, we update his salary. If the position does not exist, we create a new position. If the ' ||
--  'employee is not currently employed in a given position, we assign it to him, having previously removed ' ||
--  'him from his previous position with today's date (if he has previously held any position).
-- Creating a View:
-- CREATE VIEW V_Employee (Name, Surname, Salary, Job)
-- AS
-- SELECT p.name, p.surname, e.salary, j. name
-- FROM T Person p JOIN T Employee e ON p.id = e.id
-- JOIN T_Employment em ON em. idemployee = e.id
-- JOIN T Job j ON j.id = em.idjob
-- WHERE em. "To" IS NULL;


create or replace procedure AdjustProductPriceByCategory(
p_category_id in T_Product.IdCategory%type,
p_adjustment_percentage number) is
count int;
begin
update T_product set price =  round(price + price*p_adjustment_percentage,2) where IdCategory= p_category_id;
count:=sql%rowcount;
dbms_output.put_line(count);
end;


declare
cursor neverIncl is
select id from T_Product;
idP int; count int;
begin
open neverIncl;
loop
fetch neverIncl into idP;
exit when neverIncl%notfound;
select count(*) into count from T_ProductList where IdProduct = idP;
if count < 1 then
update T_Product set name = '[DISCONTINUED]' || :old.name, price = null where id = idP;
dbms_output.put_line('Product ' || idP || ' was discontinued due to zero sales.');
end if;
end loop;
close neverIncl;
end;
