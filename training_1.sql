-- declare
--     i number;
-- begin
--     i:=0;
--     loop
--         dbms_output.put_line(i);
--         i:=i+1;
--         exit when i>5;
--     end loop;
-- end;

declare
    numRec number;
    begin
    select count(*) into numRec from T_Person;
    dbms_output.put_line('There are ' || numRec || ' records in the T_person table');
end;

declare
    num integer;
    maxId integer;
    name varchar2(20) := 'SomeName';
    surname varchar2(20);
    begin
    select count(*) into num from T_PERSON;
    select max(id) into maxId from T_PERSON;
    maxId:=maxId+1;
    surname:='SomeSurname';
    if num<11 then
        insert into T_PERSON (ID, NAME, SURNAME) values (maxId, name, surname);
        dbms_output.put_line('Added ' || name || ' ' || surname || ' with id=' || maxId);
    else
        dbms_output.put_line('No data was inserted');
        end if;
end;

declare
    v_name varchar2(50);
begin
--     dbms_output.put_line('-- No found data exception');
--     select name into v_name from T_PRODUCT where id=15;
--     dbms_output.put_line('-- Too many rows exception');
--     select name into v_name from T_PRODUCT where id in (1,2,3);
--     dbms_output.put_line('-- Dup value on index exeption');
--     insert into T_PRODUCT (ID, NAME, PRICE, IDCATEGORY) values (1,'some',10,1);
    dbms_output.put_line('-- Other exeption');
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

create or replace procedure UpdatePrice(incr in number default 0.01) is
    i integer:=1;
    maxI integer;
    var_rows number:=0;
begin
    --     update T_PRODUCT set PRICE=PRICE*incr;
    --
    select count(*) into maxI from T_PRODUCT;
    loop
        update T_PRODUCT set PRICE=PRICE*incr where id=i;
        var_rows:=var_rows+sql%rowcount;
        i:=i+1;
        exit when i>maxI;
    end loop;
    --
    dbms_output.put_line('Price was increased by ' || incr);
    dbms_output.put_line('This many rows were modified: ' || var_rows);
    commit;
exception
    WHEN OTHERS THEN
        dbms_output.put_line('Error during price update: ' || sqlerrm);
        ROLLBACK;
end UpdatePrice;

begin UpdatePrice(0.25); end;
begin UpdatePrice(); end;

create or replace procedure EmployeeData(ida in T_EMPLOYEE.id%type,
                                         namea out T_Person.Name%TYPE,
                                         surnamea out T_Person.surname%TYPE)
is
begin
    select p.name, p.surname into namea, surnamea from T_PERSON p
        join T_EMPLOYEE e on p.ID = e.ID
    where e.ID=ida;
exception
    when no_data_found then
        namea:=null;
        surnamea:=null;
        dbms_output.put_line('The employee with the given ID does not exist.');
    when others then
        dbms_output.put_line('Error during price update: ' || sqlerrm);
        namea:=null;
        surnamea:=null;
end EmployeeData;

declare
    name T_Person.Name%TYPE;
    surname T_Person.Surname%TYPE;
begin
    EmployeeData(2, name, surname);
    if name is not null then
        dbms_output.put_line('Employee ID 2: ' || name || ' ' || surname);
    end if;
end;

create or replace procedure NewPurchase(id_k in T_Purchase.IdClient%TYPE,
                                          id_p OUT T_Purchase.Id%TYPE)
is
exist number;
begin
select count(*) into exist from T_Person where Id = id_k;
if exist = 0 then
        dbms_output.put_line('Error: Client with ID ' || id_k || ' does not exist.');
        id_p := null;
        return;
end if;
insert into T_Purchase ("Date", IdClient) values (trunc(sysdate), id_k)
    returning Id into id_p;
dbms_output.put_line('New purchase has been registered with id: ' || id_p);
commit;
exception
   when others then
        dbms_output.put_line('Error creating new purchase: ' || sqlerrm);
        id_p := null;
rollback;
end NewPurchase;

declare
id_p T_Purchase.Id%type;
begin
    NewPurchase(1, id_p);
    if id_p is not null then
        dbms_output.put_line('Captured purchase ID outside procedure: ' || id_p);
    end if;
end;

create or replace procedure AddProductToPurchase(
       pid in T_ProductList.IdProduct%type,
    pq in T_ProductList.Quantity%type,
    ppid in T_ProductList.IdPurchase%type
)