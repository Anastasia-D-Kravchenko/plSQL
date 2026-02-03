-- =================================================================
-- PHASE I: Data Definition Language (DDL) - CREATE TABLES
-- REVISED: Adjusted column names (single word) and data types (VARCHAR instead of TEXT)
-- to resolve parsing issues and improve robustness.
-- =================================================================

-- 1. Property Table
CREATE TABLE Property (
                          PropertyID INT PRIMARY KEY,
                          Address VARCHAR(255) NOT NULL,
                          City VARCHAR(100),
                          StateProvince CHAR(2),
                          ZipCode VARCHAR(10),
                          PropertyType VARCHAR(50), -- e.g., 'Single-Family', 'Condo'
                          YearBuilt INT
);

-- 2. Unit Table
CREATE TABLE Unit (
                      UnitID INT PRIMARY KEY,
                      PropertyID INT NOT NULL,
                      UnitNumber VARCHAR(20) NOT NULL, -- e.g., '101', 'A'
                      Bedrooms INT,
                      Bathrooms INT,
                      Status VARCHAR(50), -- e.g., 'Occupied', 'Vacant'
                      FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID)
);

-- 3. Tenant Table
CREATE TABLE Tenant (
                        TenantID INT PRIMARY KEY,
                        FirstName VARCHAR(50) NOT NULL,
                        LastName VARCHAR(50) NOT NULL,
                        PhoneContact VARCHAR(20),
                        EmailContact VARCHAR(100) UNIQUE
);

-- 4. Inspector/Staff Table
CREATE TABLE Inspector (
                           InspectorID INT PRIMARY KEY,
                           FirstName VARCHAR(50) NOT NULL,
                           LastName VARCHAR(50) NOT NULL,
                           Specialty VARCHAR(100) -- e.g., 'General', 'HVAC'
);

-- 5. Inspection Type Table
CREATE TABLE Inspection_Type (
                                 TypeID INT PRIMARY KEY,
                                 TypeName VARCHAR(100) NOT NULL UNIQUE, -- e.g., 'Move-In', 'Quarterly'
                                 Description VARCHAR(500) -- Was TEXT, now VARCHAR
);

-- 6. Inspection Checklist Item Table
CREATE TABLE Checklist_Item (
                                ItemID INT PRIMARY KEY,
                                ItemText VARCHAR(255) NOT NULL,
                                RatingScale VARCHAR(50) -- e.g., '1-5', 'Pass/Fail/NA'
);

-- Bridge Table: Defines which Checklist Items belong to which Inspection Type (Many-to-Many)
CREATE TABLE Inspection_Type_Checklist (
                                           TypeID INT,
                                           ItemID INT,
                                           PRIMARY KEY (TypeID, ItemID),
                                           FOREIGN KEY (TypeID) REFERENCES Inspection_Type(TypeID),
                                           FOREIGN KEY (ItemID) REFERENCES Checklist_Item(ItemID)
);

-- 7. Scheduled Inspection Table (Links Unit, Tenant, Inspector, and Type)
CREATE TABLE Scheduled_Inspection (
                                      InspectionID INT PRIMARY KEY,
                                      UnitID INT NOT NULL,
                                      TenantID INT, -- Optional, if inspection is scheduled for a vacant unit
                                      InspectorID INT NOT NULL,
                                      TypeID INT NOT NULL,
                                      ScheduledDate DATE NOT NULL,
                                      ScheduledTime TIME,
                                      Status VARCHAR(50) NOT NULL, -- e.g., 'Scheduled', 'Completed', 'Canceled'
                                      FOREIGN KEY (UnitID) REFERENCES Unit(UnitID),
                                      FOREIGN KEY (TenantID) REFERENCES Tenant(TenantID),
                                      FOREIGN KEY (InspectorID) REFERENCES Inspector(InspectorID),
                                      FOREIGN KEY (TypeID) REFERENCES Inspection_Type(TypeID)
);

-- 8. Inspection Report Table
CREATE TABLE Inspection_Report (
                                   ReportID INT PRIMARY KEY,
                                   InspectionID INT UNIQUE NOT NULL, -- 1-to-1 relationship with Scheduled_Inspection
                                   ReportDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                   OverallConditionStatus VARCHAR(50), -- e.g., 'Excellent', 'Satisfactory', 'Poor'
                                   Summary VARCHAR(1000), -- Was TEXT, now VARCHAR
                                   FOREIGN KEY (InspectionID) REFERENCES Scheduled_Inspection(InspectionID)
);

-- 9. Checklist Item Response Table
CREATE TABLE Checklist_Item_Response (
                                         ResponseID INT PRIMARY KEY,
                                         ReportID INT NOT NULL,
                                         ItemID INT NOT NULL,
                                         InspectorRating INT, -- Based on the Rating_Scale defined in Checklist_Item
                                         InspectorNotes VARCHAR(500), -- Was TEXT, now VARCHAR
                                         MaintenanceStatus VARCHAR(50), -- e.g., 'Pass', 'Fail', 'Needs Repair'
                                         FOREIGN KEY (ReportID) REFERENCES Inspection_Report(ReportID),
                                         FOREIGN KEY (ItemID) REFERENCES Checklist_Item(ItemID)
);

-- 10. Photo/Document Table
CREATE TABLE Photo_Document (
                                PhotoID INT PRIMARY KEY,
                                ResponseID INT NOT NULL,
                                FilePath VARCHAR(255) NOT NULL,
                                Description VARCHAR(255),
                                FOREIGN KEY (ResponseID) REFERENCES Checklist_Item_Response(ResponseID)
);

-- 11. Repair Vendor Table
CREATE TABLE Repair_Vendor (
                               VendorID INT PRIMARY KEY,
                               CompanyName VARCHAR(100) NOT NULL,
                               ContactPhone VARCHAR(20),
                               Specialty VARCHAR(100) -- e.g., 'Plumbing', 'Electrical'
);

-- 12. Maintenance Request Table
CREATE TABLE Maintenance_Request (
                                     RequestID INT PRIMARY KEY,
                                     UnitID INT NOT NULL,
                                     SourceReportID INT, -- Optional: links to the inspection that created the request
                                     TenantID INT, -- Optional: links to the tenant who submitted the request
                                     DateSubmitted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     Description VARCHAR(1000) NOT NULL, -- Was TEXT, now VARCHAR
                                     Priority VARCHAR(50), -- e.g., 'Urgent', 'Routine'
                                     Status VARCHAR(50), -- e.g., 'Open', 'In Progress', 'Closed'
                                     FOREIGN KEY (UnitID) REFERENCES Unit(UnitID),
                                     FOREIGN KEY (SourceReportID) REFERENCES Inspection_Report(ReportID),
                                     FOREIGN KEY (TenantID) REFERENCES Tenant(TenantID)
);

-- Bridge Table: Links Maintenance Requests to multiple Vendors (Many-to-Many)
CREATE TABLE Request_Vendor_Assignment (
                                           RequestID INT,
                                           VendorID INT,
                                           DateAssigned DATE,
                                           EstimatedCost DECIMAL(10, 2),
                                           PRIMARY KEY (RequestID, VendorID),
                                           FOREIGN KEY (RequestID) REFERENCES Maintenance_Request(RequestID),
                                           FOREIGN KEY (VendorID) REFERENCES Repair_Vendor(VendorID)
);


-- =================================================================
-- PHASE I: Data Manipulation Language (DML) - INSERT STATEMENTS
-- UPDATED: Insert statements adjusted to match new column names.
-- =================================================================

-- 1. Insert Sample Data into Property
INSERT INTO Property (PropertyID, Address, City, StateProvince, ZipCode, PropertyType, YearBuilt) VALUES
                                                                                                      (1001, '4509 Ocean View Ave', 'Santa Monica', 'CA', '90401', 'Apartment Complex', 1985),
                                                                                                      (1002, '123 River Rd', 'Palo Alto', 'CA', '94301', 'Single-Family Home', 2010);

-- 2. Insert Sample Data into Unit
INSERT INTO Unit (UnitID, PropertyID, UnitNumber, Bedrooms, Bathrooms, Status) VALUES
                                                                                   (2001, 1001, 'A', 1, 1, 'Occupied'),
                                                                                   (2002, 1001, 'B', 2, 2, 'Occupied'),
                                                                                   (2003, 1002, 'Main', 4, 3, 'Vacant');

-- 3. Insert Sample Data into Tenant
INSERT INTO Tenant (TenantID, FirstName, LastName, PhoneContact, EmailContact) VALUES
                                                                                   (3001, 'Alice', 'Johnson', '555-1234', 'alice.j@email.com'),
                                                                                   (3002, 'Bob', 'Smith', '555-5678', 'bob.s@email.com');

-- 4. Insert Sample Data into Inspector
INSERT INTO Inspector (InspectorID, FirstName, LastName, Specialty) VALUES
                                                                        (4001, 'Chad', 'Wallace', 'Lead Inspector/HVAC'),
                                                                        (4002, 'Dana', 'Myers', 'General Property');

-- 5. Insert Sample Data into Inspection_Type
INSERT INTO Inspection_Type (TypeID, TypeName, Description) VALUES
                                                                (5001, 'Move-In', 'Initial inspection prior to tenant occupancy.'),
                                                                (5002, 'Quarterly', 'Routine inspection to check property condition and safety.'),
                                                                (5003, 'Move-Out', 'Final inspection after tenant vacates.');

-- 6. Insert Sample Data into Checklist_Item
INSERT INTO Checklist_Item (ItemID, ItemText, RatingScale) VALUES
                                                               (6001, 'Smoke detector functional and tested?', 'Pass/Fail/NA'),
                                                               (6002, 'Wall condition (scuffs, holes, marks)?', '1-5 (1=Poor, 5=Excellent)'),
                                                               (6003, 'HVAC filter cleanliness and function.', 'Pass/Fail/NA'),
                                                               (6004, 'Plumbing leaks under sinks/toilets?', 'Pass/Fail/NA');

-- Bridge Table Population: Inspection_Type_Checklist (Many-to-Many)
INSERT INTO Inspection_Type_Checklist (TypeID, ItemID) VALUES
                                                           (5001, 6001), -- Move-In needs smoke detector check
                                                           (5001, 6002), -- Move-In needs wall check
                                                           (5002, 6001), -- Quarterly needs smoke detector check
                                                           (5002, 6003), -- Quarterly needs HVAC check
                                                           (5003, 6002), -- Move-Out needs wall check
                                                           (5003, 6004); -- Move-Out needs plumbing check

-- 7. Insert Sample Data into Scheduled_Inspection (Alice's Quarterly Inspection)
INSERT INTO Scheduled_Inspection (InspectionID, UnitID, TenantID, InspectorID, TypeID, ScheduledDate, ScheduledTime, Status) VALUES
    (7001, 2001, 3001, 4002, 5002, '2025-11-15', '10:00:00', 'Completed');

-- 8. Insert Sample Data into Inspection_Report
INSERT INTO Inspection_Report (ReportID, InspectionID, OverallConditionStatus, Summary) VALUES
    (8001, 7001, 'Satisfactory', 'Overall good condition, minor wear found in the kitchen area. Maintenance required for HVAC filter and a small plumbing drip.');

-- 9. Insert Sample Data into Checklist_Item_Response
INSERT INTO Checklist_Item_Response (ResponseID, ReportID, ItemID, InspectorRating, InspectorNotes, MaintenanceStatus) VALUES
                                                                                                                           (9001, 8001, 6001, NULL, 'Passed test.', 'Pass'), -- Smoke detector
                                                                                                                           (9002, 8001, 6002, 4, 'Minor scuff on living room wall.', 'Pass'), -- Wall condition
                                                                                                                           (9003, 8001, 6003, NULL, 'Filter needs immediate replacement.', 'Needs Repair'), -- HVAC
                                                                                                                           (9004, 8001, 6004, NULL, 'Slow drip found under kitchen sink.', 'Needs Repair'); -- Plumbing

-- 10. Insert Sample Data into Photo_Document (Evidence for the HVAC issue)
INSERT INTO Photo_Document (PhotoID, ResponseID, FilePath, Description) VALUES
                                                                            (10001, 9003, '/photos/unit_a_111525_hvac_filter.jpg', 'Close-up of dirty HVAC filter.'),
                                                                            (10002, 9004, '/photos/unit_a_111525_sink_drip.jpg', 'Photo of slow drip under kitchen sink pipe.');

-- 11. Insert Sample Data into Repair_Vendor
INSERT INTO Repair_Vendor (VendorID, CompanyName, ContactPhone, Specialty) VALUES
                                                                               (11001, 'Rapid Plumbers Inc.', '555-4444', 'Plumbing'),
                                                                               (11002, 'Quality HVAC Services', '555-8888', 'HVAC');

-- 12. Insert Sample Data into Maintenance_Request (Triggered by the inspection report)
INSERT INTO Maintenance_Request (RequestID, UnitID, SourceReportID, DateSubmitted, Description, Priority, Status) VALUES
    (12001, 2001, 8001, '2025-11-15 14:30:00', 'HVAC filter replacement and minor plumbing leak fix required in kitchen.', 'Routine', 'Open');

-- Bridge Table Population: Request_Vendor_Assignment (Assigning the request)
INSERT INTO Request_Vendor_Assignment (RequestID, VendorID, DateAssigned, EstimatedCost) VALUES
                                                                                             (12001, 11001, '2025-11-16', 150.00), -- Plumbing assigned
                                                                                             (12001, 11002, '2025-11-16', 85.00);  -- HVAC assigned