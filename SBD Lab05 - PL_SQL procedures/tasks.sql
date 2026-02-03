SET SERVEROUTPUT ON;

-- --- TASK 1 ---
declare
    num number;
begin
    select count(*) into num from T_Person;
    dbms_output.put_line('There are ' || num || ' records in the T_person table');
end;
/

-- --- TASK 2 ---
declare
    num integer;
    maxId integer;
    name varchar2(20) := 'SomeName';
    surname varchar2(20) := 'SomeSurname';
begin
    select count(*) into num from T_PERSON;
    -- Use NVL in case T_PERSON is empty
    select nvl(max(id), 0) into maxId from T_PERSON;
    maxId:=maxId+1;
    if num<11 then
        insert into T_PERSON (ID, NAME, SURNAME) values (maxId, name, surname);
        dbms_output.put_line('Added ' || name || ' ' || surname || ' with id=' || maxId);
    else
        dbms_output.put_line('No data was inserted');
    end if;
end;
/

-- --- TASK 3 ---
declare
    v_name varchar2(50);
begin

    -- dbms_output.put_line('-- Testing No found data exception');
    -- select name into v_name from T_PRODUCT where id=15; 

    -- dbms_output.put_line('-- Testing Too many rows exception');
    -- select name into v_name from T_PRODUCT where id in (1,2,3) and rownum < 10;

    -- dbms_output.put_line('-- Testing Dup value on index exception');
    -- insert into T_PRODUCT (ID, NAME, PRICE, IDCATEGORY) values (1,'some',10,1);

    dbms_output.put_line('-- Testing Other exception (Division by zero)');
    v_name:=10/0;
exception
    when no_data_found then
        dbms_output.put_line('Record not found');
    when too_many_rows then
        dbms_output.put_line('More than one record found');
    when dup_val_on_index then
        dbms_output.put_line('PK constraints violated');
    when others then
        dbms_output.put_line('Other error');
end;
/

-- --- TASK 4 ---
create or replace procedure UpdatePrice(incr in number default 0.01) is
    rows_mod number;
begin
    update T_PRODUCT set PRICE = PRICE * (1 + incr);
    rows_mod := sql%rowcount;

    dbms_output.put_line('Price was increased by ' || (incr * 100) || '%');
    dbms_output.put_line('This many rows were modified: ' || rows_mod);
    commit;
exception
    when others then
        dbms_output.put_line('Error during price update: ' || sqlerrm);
        rollback;
end UpdatePrice;
/

-- Task 4 Calls
begin UpdatePrice(0.25); end;
/
begin UpdatePrice(); end;
/

-- --- TASK 5 ---
create or replace procedure EmployeeData(id_in in T_EMPLOYEE.id%type,
                                         name_out out T_Person.Name%TYPE,
                                         surname_out out T_Person.surname%TYPE)
    is
begin
    select p.name, p.surname into name_out, surname_out from T_PERSON p
                                                                 join T_EMPLOYEE e on p.ID = e.ID
    where e.ID=id_in;
exception
    when no_data_found then
        name_out:=null;
        surname_out:=null;
        dbms_output.put_line('The employee with the given ID does not exist.');
    when others then
        dbms_output.put_line('Error getting employee data: ' || sqlerrm);
        name_out:=null;
        surname_out:=null;
end EmployeeData;
/

-- Task 5 Call
declare
    v_name T_Person.Name%TYPE;
    v_surname T_Person.Surname%TYPE;
begin
    EmployeeData(2, v_name, v_surname);
    if v_name is not null then
        dbms_output.put_line('Employee ID 2: ' || v_name || ' ' || v_surname);
    end if;
end;
/

-- --- TASK 6 ---
create or replace procedure NewPurchase(id_c in T_Purchase.IdClient%TYPE,
                                        id_p OUT T_Purchase.Id%TYPE)
    is
    cnt number;
begin
    select count(*) into cnt from T_Person where Id = id_c;
    if cnt = 0 then
        dbms_output.put_line('Error: Client with ID ' || id_c || ' does not exist.');
        id_p := null;
        return;
    end if;

    insert into T_Purchase ("Date", IdClient) values (trunc(sysdate), id_c)
    returning Id into id_p;

    dbms_output.put_line('New purchase has been registered with id: ' || id_p);
    commit;
exception
    when others then
        dbms_output.put_line('Error creating new purchase: ' || sqlerrm);
        id_p := null;
        rollback;
end NewPurchase;
/

-- Task 6 Call
declare
    v_id T_Purchase.Id%type;
begin
    NewPurchase(1, v_id);
    if v_id is not null then
        dbms_output.put_line('Captured purchase ID outside procedure: ' || v_id);
    end if;
end;
/

-- --- TASK 7 ---
create or replace procedure AddProductToPurchase(
    id_p in T_ProductList.IdProduct%type,
    qty in T_ProductList.Quantity%type,
    id_pur in T_ProductList.IdPurchase%type
)
    is
    p_exist number;
    pur_exist number;
    list_exist number;
begin
    if qty <= 0 then
        dbms_output.put_line('Error: Quantity must be greater than 0.');
        return;
    end if;

    select count(*) into p_exist from T_Product where Id = id_p;
    select count(*) into pur_exist from T_Purchase where Id = id_pur;

    if p_exist = 0 or pur_exist = 0 then
        dbms_output.put_line('Error: Product (' || id_p || ') or Purchase (' || id_pur || ') does not exist.');
        return;
    end if;

    select count(*) into list_exist from T_ProductList
    where IdPurchase = id_pur and IdProduct = id_p;

    if list_exist > 0 then
        update T_ProductList
        set Quantity = Quantity + qty
        where IdPurchase = id_pur and IdProduct = id_p;

        dbms_output.put_line('Product ' || id_p || ' increased in purchase ' || id_pur || ' by: ' || qty);
    else
        insert into T_ProductList (IdPurchase, IdProduct, Quantity)
        values (id_pur, id_p, qty);

        dbms_output.put_line('Product ' || id_p || ' added to purchase ' || id_pur || ', quantity: ' || qty);
    end if;

    commit;
exception
    when others then
        dbms_output.put_line('Error adding product to purchase: ' || sqlerrm);
        rollback;
end AddProductToPurchase;
/

-- Task 7 Call
declare
    v_pur_id T_Purchase.Id%type;
begin
    NewPurchase(1, v_pur_id);

    if v_pur_id is not null then
        AddProductToPurchase(1, 1, v_pur_id);
        AddProductToPurchase(1, 1, v_pur_id);
    end if;
end;
/

-- --- TASK 8 ---
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
/

-- Task 8 Call
declare
    e_id constant T_Employee.Id%type := 1;
    j_id_new constant T_Job.Id%type := 2;
    j_id_same constant T_Job.Id%type := 1;
begin
    UpdateEmployeeJob(e_id, j_id_new);x

    UpdateEmployeeJob(e_id, j_id_same);

    UpdateEmployeeJob(999, j_id_new);
end;
/
