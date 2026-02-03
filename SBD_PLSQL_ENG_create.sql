alter session set nls_date_format = 'DD-MM-YYYY';

-- tables
-- Table: T_Category
CREATE TABLE T_Category (
    Id integer  NOT NULL,
    Name varchar2(50)  NOT NULL,
    CONSTRAINT T_Category_pk PRIMARY KEY (Id)
) ;

-- Table: T_Employee
CREATE TABLE T_Employee (
    Id integer  NOT NULL,
    Salary number(8,2)  NOT NULL,
    IdBoss integer  NULL,
    CONSTRAINT T_Employee_pk PRIMARY KEY (Id)
) ;

-- Table: T_Employment
CREATE TABLE T_Employment (
    IdJob integer  NOT NULL,
    IdEmployee integer  NOT NULL,
    "From" date  NOT NULL,
    "To" date  NULL,
    CONSTRAINT T_Employment_pk PRIMARY KEY ("From",IdJob,IdEmployee)
) ;

-- Table: T_Job
CREATE TABLE T_Job (
    Id integer  NOT NULL,
    Name varchar2(40)  NOT NULL,
    CONSTRAINT T_Job_pk PRIMARY KEY (Id)
) ;

-- Table: T_Person
CREATE TABLE T_Person (
    Id integer  NOT NULL,
    Name varchar2(50)  NOT NULL,
    Surname varchar2(50)  NOT NULL,
    CONSTRAINT T_Person_pk PRIMARY KEY (Id)
) ;

-- Table: T_Product
CREATE TABLE T_Product (
    Id integer  NOT NULL,
    Name varchar2(50)  NOT NULL,
    Price number(8,2)  NOT NULL,
    IdCategory integer  NOT NULL,
    CONSTRAINT T_Product_pk PRIMARY KEY (Id)
) ;

-- Table: T_ProductList
CREATE TABLE T_ProductList (
    IdPurchase integer  NOT NULL,
    IdProduct integer  NOT NULL,
    Quantity integer  NOT NULL,
    CONSTRAINT T_ProductList_pk PRIMARY KEY (IdProduct,IdPurchase)
) ;

-- Table: T_Purchase
CREATE TABLE T_Purchase (
    Id integer GENERATED ALWAYS AS IDENTITY,
    "Date" date  NOT NULL,
    IdClient integer  NOT NULL,
    CONSTRAINT T_Purchase_pk PRIMARY KEY (Id)
) ;

-- Table: T_Supply
CREATE TABLE T_Supply (
    Id integer  GENERATED ALWAYS AS IDENTITY,
    "Date" date  NOT NULL,
    CONSTRAINT T_Supply_pk PRIMARY KEY (Id)
) ;

-- Table: T_SupplyProduct
CREATE TABLE T_SupplyProduct (
    IdSupply integer  NOT NULL,
    IdProduct integer  NOT NULL,
    Quantity integer  NOT NULL,
    CONSTRAINT T_SupplyProduct_pk PRIMARY KEY (IdSupply,IdProduct)
) ;

-- foreign keys
-- Reference: T_Employee_T_Employee (table: T_Employee)
ALTER TABLE T_Employee ADD CONSTRAINT T_Employee_T_Employee
    FOREIGN KEY (IdBoss)
    REFERENCES T_Employee (Id);

-- Reference: T_Employee_T_Person (table: T_Employee)
ALTER TABLE T_Employee ADD CONSTRAINT T_Employee_T_Person
    FOREIGN KEY (Id)
    REFERENCES T_Person (Id);

-- Reference: T_Employment_T_Employee (table: T_Employment)
ALTER TABLE T_Employment ADD CONSTRAINT T_Employment_T_Employee
    FOREIGN KEY (IdEmployee)
    REFERENCES T_Employee (Id);

-- Reference: T_Employment_T_Job (table: T_Employment)
ALTER TABLE T_Employment ADD CONSTRAINT T_Employment_T_Job
    FOREIGN KEY (IdJob)
    REFERENCES T_Job (Id);

-- Reference: T_ProductList_T_Product (table: T_ProductList)
ALTER TABLE T_ProductList ADD CONSTRAINT T_ProductList_T_Product
    FOREIGN KEY (IdProduct)
    REFERENCES T_Product (Id);

-- Reference: T_ProductList_T_Purchase (table: T_ProductList)
ALTER TABLE T_ProductList ADD CONSTRAINT T_ProductList_T_Purchase
    FOREIGN KEY (IdPurchase)
    REFERENCES T_Purchase (Id);

-- Reference: T_Product_T_Category (table: T_Product)
ALTER TABLE T_Product ADD CONSTRAINT T_Product_T_Category
    FOREIGN KEY (IdCategory)
    REFERENCES T_Category (Id);

-- Reference: T_Purchase_T_Person (table: T_Purchase)
ALTER TABLE T_Purchase ADD CONSTRAINT T_Purchase_T_Person
    FOREIGN KEY (IdClient)
    REFERENCES T_Person (Id);

-- Reference: T_SupplyProduct_T_Product (table: T_SupplyProduct)
ALTER TABLE T_SupplyProduct ADD CONSTRAINT T_SupplyProduct_T_Product
    FOREIGN KEY (IdProduct)
    REFERENCES T_Product (Id);

-- Reference: T_SupplyProduct_T_Supply (table: T_SupplyProduct)
ALTER TABLE T_SupplyProduct ADD CONSTRAINT T_SupplyProduct_T_Supply
    FOREIGN KEY (IdSupply)
    REFERENCES T_Supply (Id);

--Osoba wartości
INSERT ALL
    INTO T_Person (Id, Name, Surname) VALUES (1, 'Thomas', 'Theramenes')
    INTO T_Person (Id, Name, Surname) VALUES (2, 'Mark', 'Clearchus')
    INTO T_Person (Id, Name, Surname) VALUES (3, 'John', 'Cheirisophus')
    INTO T_Person (Id, Name, Surname) VALUES (4, 'Ethan', 'Ephialtes')
    INTO T_Person (Id, Name, Surname) VALUES (5, 'Peter', 'Phrynichus')
    INTO T_Person (Id, Name, Surname) VALUES (6, 'Liam', 'Letodorus')
    INTO T_Person (Id, Name, Surname) VALUES (7, 'Richard', 'Sitalces')
    INTO T_Person (Id, Name, Surname) VALUES (8, 'Paul', 'Prothytes')
    INTO T_Person (Id, Name, Surname) VALUES (9, 'Chris', 'Charitimides')
    INTO T_Person (Id, Name, Surname) VALUES (10, 'Paul', 'Prepelaus')
SELECT 1 FROM dual;

--Pracownik wartości
INSERT ALL
    INTO T_Employee (Id, Salary, IdBoss) VALUES (1, 9888.65, null)
    INTO T_Employee (Id, Salary, IdBoss) VALUES (2, 9655.47, null)
    INTO T_Employee (Id, Salary, IdBoss) VALUES (3, 3225.34, 2)
    INTO T_Employee (Id, Salary, IdBoss) VALUES (4, 2775.75, 2)
    INTO T_Employee (Id, Salary, IdBoss) VALUES (5, 2655.25, 2)
    INTO T_Employee (Id, Salary, IdBoss) VALUES (6, 2715, 2)
SELECT 1 FROM dual;
INSERT ALL
INTO T_Employee (Id, Salary, IdBoss) VALUES (7, 1000, 2)
SELECT 1 FROM dual;

--Stanowisko wartosci
INSERT ALL
    INTO T_Job (Id, Name) VALUES (1, 'manager')
    INTO T_Job (Id, Name) VALUES (2, 'cashier')
    INTO T_Job (Id, Name) VALUES (3, 'janitor')
SELECT 1 FROM dual;

--Zatrudnienie wartości
INSERT ALL
    INTO T_Employment (IdJob, IdEmployee, "From", "To") VALUES (1, 1, '01-12-2020', '14-09-2022')
    INTO T_Employment (IdJob, IdEmployee, "From", "To") VALUES (1, 2, '01-12-2020', '15-09-2022')
    INTO T_Employment (IdJob, IdEmployee, "From", "To") VALUES (2, 2, '15-09-2022', null)
    INTO T_Employment (IdJob, IdEmployee, "From", "To") VALUES (3, 3, '01-12-2020', null)
    INTO T_Employment (IdJob, IdEmployee, "From", "To") VALUES (2, 4, '07-03-2021', '29-08-2021')
    INTO T_Employment (IdJob, IdEmployee, "From", "To") VALUES (2, 5, '30-08-2021', null)
    INTO T_Employment (IdJob, IdEmployee, "From", "To") VALUES (2, 6, '11-09-2022', null)
SELECT 1 FROM dual;
INSERT ALL
    INTO T_Employment (IdJob, IdEmployee, "From", "To")
VALUES (2, 7, TO_DATE('11-11-2024', 'DD-MM-YYYY'), NULL)
SELECT 1 FROM dual;

--Kategoria wartości
INSERT ALL
    INTO T_Category (Id, Name) VALUES (1, 'fish')
    INTO T_Category (Id, Name) VALUES (2, 'vegetable')
    INTO T_Category (Id, Name) VALUES (3, 'fruit')
SELECT 1 FROM dual;

--Produkt wartości
INSERT ALL
    INTO T_Product (Id, Name, Price, IdCategory) VALUES(1, 'cod', 2.20, 1)
    INTO T_Product (Id, Name, Price, IdCategory) VALUES(2, 'herring', 2.75, 1)
    INTO T_Product (Id, Name, Price, IdCategory) VALUES(3, 'garlic', 0.19, 2)
    INTO T_Product (Id, Name, Price, IdCategory) VALUES(4, 'potato', 0.05, 2)
    INTO T_Product (Id, Name, Price, IdCategory) VALUES(5, 'kiwi', 1.15, 3)
    INTO T_Product (Id, Name, Price, IdCategory) VALUES(6, 'mango', 0.99, 3)
    INTO T_Product (Id, Name, Price, IdCategory) VALUES(7, 'grapefruit', 0.39, 3)
    INTO T_Product (Id, Name, Price, IdCategory) VALUES(8, 'trout', 2.20, 1)
    INTO T_Product (Id, Name, Price, IdCategory) VALUES(9, 'haddock', 3.45, 1)
    INTO T_Product (Id, Name, Price, IdCategory) VALUES(10, 'pumpkin', 1.99, 2)
SELECT 1 FROM dual;

--Zakup wartości
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('1-12-2020', 7);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('2-12-2020', 8);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('2-12-2020', 9);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('4-12-2020', 3);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('1-12-2020', 10);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('7-12-2020', 10);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('9-12-2020', 2);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('1-12-2020', 2);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('3-12-2020', 3);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('23-12-2020', 4);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('25-01-2021', 6);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('12-03-2021', 4);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('08-05-2021', 2);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('19-07-2021', 5);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('02-09-2021', 9);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('14-11-2021', 7);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('06-01-2021', 3);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('18-02-2021', 4);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('30-04-2021', 5);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('27-06-2021', 10);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('25-03-2021', 9);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('12-05-2021', 4);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('03-07-2021', 2);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('28-09-2021', 3);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('09-11-2021', 6);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('14-01-2021', 4);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('08-03-2021', 9);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('01-05-2021', 7);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('11-07-2021', 10);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('22-09-2021', 5);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('25-01-2022', 7);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('12-03-2022', 3);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('08-05-2022', 5);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('19-07-2022', 6);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('02-09-2022', 9);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('14-11-2022', 7);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('06-01-2022', 2);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('18-02-2022', 4);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('30-04-2022', 5);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('27-06-2022', 10);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('14-01-2022', 4);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('08-03-2022', 9);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('01-05-2022', 7);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('11-07-2022', 10);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('22-09-2022', 5);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('09-08-2022', 2);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('03-10-2022', 7);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('22-12-2022', 6);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('09-12-2022', 3);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('04-12-2022', 9);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('14-12-2022', 10);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('05-12-2022', 2);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('17-12-2022', 3);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('07-12-2022', 6);
INSERT INTO T_Purchase ("Date", IdClient) VALUES ('31-01-2022', 5);

--ListaProduktow wartości
INSERT ALL
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (1, 7, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (2, 6, 7)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (2, 8, 1)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (2, 3, 4)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (2, 10, 5)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (3, 5, 9)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (3, 4, 8)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (3, 7, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (3, 1, 6)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (4, 2, 3)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (4, 7, 8)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (4, 10, 5)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (4, 9, 1)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (5, 6, 10)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (5, 3, 4)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (5, 2, 7)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (5, 1, 9)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (6, 5, 1)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (6, 8, 3)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (6, 2, 7)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (7, 1, 4)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (7, 5, 6)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (8, 3, 9)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (8, 6, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (9, 10, 8)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (10, 7, 4)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (11, 4, 8)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (11, 9, 1)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (11, 2, 7)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (11, 7, 6)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (12, 5, 6)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (12, 7, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (12, 6, 5)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (12, 8, 1)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (13, 1, 7)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (13, 9, 10)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (13, 3, 4)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (13, 10, 5)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (14, 2, 6)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (14, 7, 8)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (14, 6, 1)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (14, 3, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (15, 1, 4)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (15, 10, 9)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (15, 3, 7)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (15, 7, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (16, 4, 3)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (16, 8, 6)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (16, 7, 8)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (17, 1, 9)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (17, 6, 5)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (17, 9, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (18, 5, 7)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (18, 9, 3)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (18, 7, 1)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (18, 8, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (19, 4, 8)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (19, 3, 5)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (19, 2, 7)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (19, 9, 1)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (20, 10, 12)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (20, 5, 1)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (20, 3, 6)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (21, 5, 4)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (21, 3, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (22, 6, 8)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (23, 1, 6)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (23, 10, 4)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (24, 6, 1)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (24, 4, 7)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (24, 10, 3)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (24, 2, 8)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (25, 3, 9)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (25, 7, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (25, 4, 10)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (26, 1, 4)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (26, 9, 5)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (26, 6, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (27, 5, 7)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (27, 9, 3)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (28, 7, 1)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (29, 3, 8)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (29, 10, 4)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (29, 6, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (29, 5, 7)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (30, 2, 8)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (30, 5, 4)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (31, 1, 3)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (31, 4, 9)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (31, 7, 6)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (31, 2, 8)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (32, 2, 8)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (32, 10, 5)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (33, 1, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (33, 8, 10)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (33, 5, 9)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (34, 5, 7)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (34, 8, 6)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (34, 10, 3)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (35, 6, 10)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (35, 1, 4)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (36, 7, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (37, 1, 4)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (37, 9, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (37, 8, 6)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (38, 8, 4)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (38, 2, 1)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (38, 7, 10)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (38, 6, 9)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (38, 5, 3)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (39, 9, 7)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (39, 1, 8)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (40, 4, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (40, 7, 10)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (41, 9, 5)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (42, 1, 3)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (43, 6, 8)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (44, 7, 6)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (44, 2, 8)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (45, 8, 10)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (45, 5, 9)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (46, 2, 4)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (47, 1, 4)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (47, 3, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (48, 7, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (49, 9, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (49, 8, 6)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (50, 8, 4)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (50, 2, 1)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (50, 7, 10)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (50, 6, 9)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (50, 5, 3)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (51, 2, 4)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (51, 9, 7)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (52, 6, 5)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (52, 2, 10)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (53, 9, 10)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (53, 5, 3)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (54, 1, 4)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (54, 7, 10)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (54, 8, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (54, 9, 5)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (55, 3, 9)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (55, 5, 7)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (55, 1, 2)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (55, 10, 8)
    INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (55, 4, 6)
SELECT 1 FROM DUAL;

commit;


-- End of file.



-- Ensure environment is set up for output
SET SERVEROUTPUT ON;

-- Clean up existing test data to ensure a fresh start
DELETE FROM T_SupplyProduct WHERE IdSupply IN (SELECT Id FROM T_Supply WHERE TRUNC("Date") = TRUNC(SYSDATE));
DELETE FROM T_Purchase WHERE Id > 500;
DELETE FROM T_Product WHERE Id > 100;
DELETE FROM T_Category WHERE Id > 100;

-- Optional: Insert a category and a person if they don't exist
INSERT INTO T_Category (Id, Name) VALUES (101, 'Office Supplies');
INSERT INTO T_Person (Id, Name, Surname) VALUES (501, 'Test', 'Client');

-- A. Insert Test Products (IDs 101, 102, 103)
INSERT INTO T_Product (Id, Name, Price, IdCategory) VALUES (101, 'Pencil', 0.50, 101); -- Sold 6 total (Skip)
INSERT INTO T_Product (Id, Name, Price, IdCategory) VALUES (102, 'Notebook', 2.00, 101); -- Sold 11 total (Order 22)
INSERT INTO T_Product (Id, Name, Price, IdCategory) VALUES (103, 'Eraser', 0.25, 101); -- Sold 15 total (Order 30)

-- B. Insert Purchase Records in December 2022
-- Purchase 501: Dec 5, 2022
INSERT INTO T_Purchase (Id, "Date", IdClient) VALUES (501, DATE '2022-12-05', 501);

-- Purchase 502: Dec 20, 2022
INSERT INTO T_Purchase (Id, "Date", IdClient) VALUES (502, DATE '2022-12-20', 501);

-- C. Insert Product List (Sales data for December 2022)

-- Product 101 (Pencil) - Total Sold: 6 (Fails the >10 criteria)
INSERT INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (501, 101, 6);

-- Product 102 (Notebook) - Total Sold: 11 (PASSES -> Order 22)
INSERT INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (501, 102, 8);
INSERT INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (502, 102, 3); -- 8 + 3 = 11

-- Product 103 (Eraser) - Total Sold: 15 (PASSES -> Order 30)
INSERT INTO T_ProductList (IdPurchase, IdProduct, Quantity) VALUES (502, 103, 15);

COMMIT;

DBMS_OUTPUT.PUT_LINE('Test data inserted for Products 101, 102, 103 and Purchases 501, 502.');