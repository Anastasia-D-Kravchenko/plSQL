-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-11-28 19:37:22.703

-- foreign keys
ALTER TABLE T_Employee
DROP CONSTRAINT T_Employee_T_Employee;

ALTER TABLE T_Employee
DROP CONSTRAINT T_Employee_T_Person;

ALTER TABLE T_Employment
DROP CONSTRAINT T_Employment_T_Employee;

ALTER TABLE T_Employment
DROP CONSTRAINT T_Employment_T_Job;

ALTER TABLE T_ProductList
DROP CONSTRAINT T_ProductList_T_Product;

ALTER TABLE T_ProductList
DROP CONSTRAINT T_ProductList_T_Purchase;

ALTER TABLE T_Product
DROP CONSTRAINT T_Product_T_Category;

ALTER TABLE T_Purchase
DROP CONSTRAINT T_Purchase_T_Person;

ALTER TABLE T_SupplyProduct
DROP CONSTRAINT T_SupplyProduct_T_Product;

ALTER TABLE T_SupplyProduct
DROP CONSTRAINT T_SupplyProduct_T_Supply;

-- tables
DROP TABLE T_Category;

DROP TABLE T_Employee;

DROP TABLE T_Employment;

DROP TABLE T_Job;

DROP TABLE T_Person;

DROP TABLE T_Product;

DROP TABLE T_ProductList;

DROP TABLE T_Purchase;

DROP TABLE T_Supply;

DROP TABLE T_SupplyProduct;

-- End of file.