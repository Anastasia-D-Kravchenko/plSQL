-- --- TASK 1 ---
DELETE FROM T_ProductList
WHERE IdPurchase = 55 AND IdProduct = 4;

create or replace trigger deleteRecords
    before delete on T_PRODUCTLIST
    begin
        raise_application_error(-20001, 'You cannot delete records from T_ProductList');
    end;


-- --- TASK 2 ---
DELETE FROM T_ProductList
WHERE IdPurchase = 55 AND IdProduct = 5;

create or replace trigger deleteRecords
    before delete on T_PRODUCTLIST
for each row
begin
        raise_application_error(-20001,
                               'You cannot delete records from T_ProductList.Failed to delete record for purchase=' || :OLD.IDPURCHASE || ' and product=' || :OLD.IDPRODUCT);
end;


-- --- TASK 3 ---
drop trigger deleteRecords;

DELETE FROM T_Purchase WHERE id = 1;
create or replace trigger afterDelete
    after delete on T_PURCHASE
    for each row
    begin
        delete from T_PRODUCTLIST
            where IDPURCHASE=:OLD.id;
        dbms_output.put_line('Purchase with id=' || :OLD.Id || ' was deleted');
    end;
DELETE FROM T_Purchase WHERE id = 1;


-- --- TASK 4 ---
ALTER TABLE T_Employee
    ADD CONSTRAINT CHK_Salary CHECK (Salary <10000);

create or replace trigger beforeInserting
    before insert or update of salary on T_EMPLOYEE
    for each row
    begin
        if :NEW.Salary > 10000 then
            raise_application_error(-20001, 'Salary exceeds the limit, DML operation failed.');
        end if;
    end;
UPDATE T_Employee
SET salary = 40000
WHERE id =2;
INSERT INTO T_Employee(Id, salary) VALUES (7, 40000);


-- --- TASK 5 ---
create or replace trigger beforeUpdating
    before update of Price on T_Product
    for each row
    begin
        if :NEW.Price < :OLD.Price then
            raise_application_error(-20001, 'The price cannot be reduced');
        end if;
    end;
UPDATE T_Product
SET price = 0.01
WHERE id = 2;


-- --- TASK 6 ---
drop trigger beforeUpdating;
create or replace trigger inUpDel
    before update or insert or delete on T_PRODUCT
    for each row
    begin
        if inserting then
            if :NEW.price > 100 then
                raise_application_error(-20001, 'Cannot add a product with a price greater than 100.');
            end if;
        elsif updating then
            if :NEW.Price > :OLD.Price THEN
                raise_application_error(-20001, 'The price cannot be increased.');
            end if;
        elsif deleting then
            delete from T_PRODUCTLIST
                where IDPRODUCT=:OLD.id;
        end if;
    end;


-- --- TASK 7 ---
INSERT INTO T_Person (id, name, surname) VALUES (11, 'Tim',
                                                 'Theramenes');
create or replace trigger surnameExist
before insert on T_Person
    for each row
    declare
        count integer;
    begin
        select COUNT(*)
        into count
        from T_Person
        where Surname = :NEW.Surname;

        if count > 0 then
            raise_application_error(-20001, 'Person with the given surname already exists');
        else
            dbms_output.put_line(:NEW.Surname || ' was succesfully inserted.');
        end if;
    end;
INSERT INTO T_Person (id, name, surname) VALUES (11, 'Tim',
                                                 'Thrasybulus');
INSERT ALL
    INTO T_Person (id, name, surname) VALUES (12, 'Liam', 'Thrasyllus')
INTO T_Person (id, name, surname) VALUES (13, 'Keith', 'Conon')
INTO T_Person (id, name, surname) VALUES (14, 'Reece',
                                          'Callicratidas')
SELECT 1 FROM DUAL;


-- --- TASK 8 ---
create or replace trigger updatingUpdate
    before update on T_Employment
    for each row
    begin
        if updating('IdEmployee') OR updating('IdJob') OR updating('From') then
            raise_application_error(-20001, 'Only the "To" column can be updated for T_Employment records.');
        end if;

        if updating('To') then
            if :OLD."To" IS NOT NULL then
                raise_application_error(-20001, 'The "To" date has already been set and cannot be changed.');
            end if;
            if :NEW."To" < :OLD."From" then
                raise_application_error(-20001, 'The "To" date cannot be earlier than the "From" date.');
            end if;
        end if;
    end;



-- --- TASK 9 ---
CREATE TABLE T_SoldProducts(
                               TotalValue number(8,2) not null
);
DECLARE
    v_value number(8,2);
BEGIN
    SELECT SUM(price * quantity) INTO v_value FROM T_ProductList pl JOIN
                                                   T_Product p ON pl.idproduct = p.id;
    INSERT INTO T_SoldProducts VALUES (v_value);
END;

create or replace trigger changingPrice
    after insert or update or delete on t_productlist
    for each row
declare
    newChange number(8,2) := 0;
    price number(8,2);
begin
    select price into price
    from t_product
    where id = nvl(:new.idproduct, :old.idproduct);

    if inserting then
        newChange := :new.quantity * price;
    elsif updating('quantity') then
        newChange := (:new.quantity - :old.quantity) * price;
    elsif deleting then
        newChange := -(:old.quantity * price);
    end if;

    update t_soldproducts
    set totalvalue = totalvalue + newChange;
end;



-- --- TASK 10 ---
CREATE VIEW V_Employee (Name, Surname, Salary, Job)
AS
SELECT p.name, p.surname, e.salary, j.name
FROM T_Person p JOIN T_Employee e ON p.id = e.id
                JOIN T_Employment em ON em.idemployee = e.id
                JOIN T_Job j ON j.id = em.idjob
WHERE em."To" IS NULL;

create or replace trigger employeeId
    instead of insert on v_employee
    for each row
declare
    personId t_person.id%type;
    jobId t_job.id%type;
    empExist boolean := false;
begin
    begin
        select id into personId
        from t_person
        where name = :new.name and surname = :new.surname;
    exception
        when no_data_found then
            select nvl(max(id), 0) + 1 into personId from t_person;

            insert into t_person (id, name, surname)
            values (personId, :new.name, :new.surname);
    end;

    begin
        select id into personId
        from t_employee
        where id = personId;

        empExist := true;

        update t_employee
        set salary = :new.salary
        where id = personId;

    exception
        when no_data_found then
            insert into t_employee (id, salary, idboss)
            values (personId, :new.salary, null);
    end;

    begin
        select id into jobId
        from t_job
        where name = :new.job;
    exception
        when no_data_found then
            select nvl(max(id), 0) + 1 into jobId from t_job;

            insert into t_job (id, name)
            values (jobId, :new.job);
    end;

    if empExist = true or not empExist then
        update t_employment
        set "to" = trunc(sysdate)
        where idemployee = personId
          and "to" is null;
    end if;

    insert into t_employment (idjob, idemployee, "from", "to")
    values (jobId, personId, trunc(sysdate), null);
end;
