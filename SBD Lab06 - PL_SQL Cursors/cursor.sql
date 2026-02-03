SET SERVEROUTPUT ON;

-- --- TASK 1 ---
declare
    cursor products is
        select id, name, price
        from T_PRODUCT
        for update of price;
    new_price T_PRODUCT.price%type;
begin
    for product in products loop
        new_price:=product.price;
        if product.price > 2 then
            new_price:=new_price*0.9;
        elsif product.price < 1 then
            new_price:=new_price*1.05;
        end if;

        if product.price != new_price then
            new_price:=round(new_price,2);
            update T_PRODUCT
                set price=new_price
                where current of products;
            dbms_output.put_line('Price of ' || product.name || ' was changed to: ' || new_price || '$');
        end if;
    end loop;
    commit;
end;

-- --- TASK 2 ---
create or replace procedure modifier(decrease in number,
increase in number) is
    cursor products is
        select id, name, price
        from T_PRODUCT
            for update of price;
    new_price T_PRODUCT.price%type;
begin
    for product in products loop
            new_price:=product.price;
            case
                when product.price > 2 then
                    new_price:=new_price*(1-decrease);
                when product.price < 1 then
                    new_price:=new_price*(1+increase);
                else
                    null;
            end case;

            if product.price != new_price then
                new_price:=round(new_price,2);
                update T_PRODUCT
                set price=new_price
                where current of products;
                dbms_output.put_line('Price of ' || product.name || ' was changed to: ' || new_price || '$');
            end if;
        end loop;
    commit;
exception
    when others then
        dbms_output.put_line('Error during price update: ' || sqlerrm);
        rollback;
end modifier;
begin modifier(0.2,0.2); end;

-- --- TASK 3 ---
declare
    cursor products is
        select pl.IDPRODUCT, sum(pl.QUANTITY) as totQua
        from T_PRODUCTLIST pl
        join T_PURCHASE p on pl.IDPURCHASE = p.ID
        where p."Date" >= TO_DATE('01-12-2022', 'DD-MM-YYYY') and p."Date" <= TO_DATE('31-12-2022', 'DD-MM-YYYY')
        group by pl.IDPRODUCT
        having sum(pl.QUANTITY) > 10;
    totalSupply T_SUPPLYPRODUCT.QUANTITY%type;
    supId T_SUPPLY.Id%type;
begin
    insert into T_SUPPLY("Date")
        values (trunc(sysdate))
    returning Id into supId;
    for product in products loop
        totalSupply:=product.totQua*2;
        insert into T_SUPPLYPRODUCT (IDSUPPLY, IDPRODUCT, QUANTITY)
        values (supId,product.IDPRODUCT, totalSupply);
        dbms_output.put_line('The product with ID = ' || product.IdProduct ||
                             ' in quantity = ' || totalSupply ||
                             ' was ordered.');
    end loop;
    commit;
end;

-- --- TASK 4 ---
ALTER TABLE T_Employee
    ADD Bonus Number(8,2) NULL;
create or replace view seniority as
    select e.id, trunc(months_between(sysdate, min(t."From"))) as months
    from T_EMPLOYEE e
    join T_EMPLOYMENT t on e.Id = t.IDEMPLOYEE
    group by e.id;
declare
    cursor employees is
    select e.Id, e.SALARY, s.months
    from T_EMPLOYEE e
    join seniority s on e.ID = s.ID
    where e.ID in (select distinct IDEMPLOYEE
                   from T_EMPLOYMENT
                   where "To" is null)
    for update of bonus;
    rate number(5,2);
    max_rate constant number := 0.3;
    bonus T_EMPLOYEE.bonus%type;
begin
    for employee in employees loop
        rate:=employee.months/100;
        if employee.months < 6 then
            bonus:=0;
            rate:=0;
        else
            if rate > max_rate then
                rate:=max_rate;
            end if;
            bonus:=round(rate*employee.SALARY,2);
        end if;
        update T_EMPLOYEE e
            set e.BONUS = bonus
            where current of employees;
        dbms_output.put_line('Employee from id= ' || employee.Id ||
                             ' has been assigned a bonus in the amount of= ' ||
                             rate * 100 || ' % of salary.');
    end loop;
    commit;
end;

-- --- TASK 5 ---
ALTER TABLE T_Person
    ADD Favourite_product integer null;
ALTER TABLE T_Person
    ADD CONSTRAINT FK_Person_Product FOREIGN KEY (Favourite_product)
        REFERENCES T_Product (Id);
declare
    cursor people is
        select Id
        from T_Person
        where Id in (select IdClient from T_Purchase)
        for update of Favourite_product;
    fdId T_Product.Id%type;
begin
    for person in people loop
            begin
                select IdProduct into fdId
                from (
                select pl.IdProduct, SUM(pl.Quantity) as totQua
                from T_Purchase p
                join T_ProductList pl on p.Id = pl.IdPurchase
                where p.IdClient = person.Id
                group by pl.IdProduct
                order by totQua desc, pl.IdProduct)
                where rownum = 1;
                update T_Person
                set Favourite_product = fdId
                where current of people;
                dbms_output.put_line('Favorite product with id= ' || fdId ||
                                     ' has been assigned to a person with id= ' || person.Id || '.');
            exception
                when NO_DATA_FOUND then
                    dbms_output.put_line('Person with id= ' || person.Id || ' has no purchase history.');
                when others then
                    raise;
            end;
        end loop;
    commit;
end;