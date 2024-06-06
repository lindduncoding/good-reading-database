CREATE TABLE City (
    CityID SERIAL PRIMARY KEY,
    City VARCHAR(50),
    Province VARCHAR(50)
);

CREATE TABLE Locations (
    LocationID SERIAL PRIMARY KEY,
    Street VARCHAR(100),
    District VARCHAR(100),
    CityID INT,
    FOREIGN KEY (CityID) REFERENCES City(CityID)
);

CREATE TABLE Manager (
    ManagerID SERIAL PRIMARY KEY,
    Fname VARCHAR(40),
    LName VARCHAR(40),
    Salary FLOAT
);

CREATE TABLE Branch (
    BranchNo SERIAL PRIMARY KEY,
    ManagerID INT,
    LocationID INT,
    FOREIGN KEY (ManagerID) REFERENCES Manager(ManagerID),
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
);

CREATE TABLE Inventory (
    InventoryID SERIAL PRIMARY KEY,
    BranchID INT,
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchNo)
);

CREATE TABLE Book (
    ISBN SERIAL PRIMARY KEY,
    InventoryID INT,
    Title VARCHAR(200),
    PublicationYear INT,
    Pages INT,
    Price FLOAT,
    Stock INT,
    CONSTRAINT stock_non_negative CHECK (stock >= 0),
    FOREIGN KEY (InventoryID) REFERENCES Inventory(InventoryID)
);

CREATE TABLE Author (
    AuthorID SERIAL PRIMARY KEY,
    FName VARCHAR(40),
    LName VARCHAR(40)
);

CREATE TABLE Publisher (
    PubID SERIAL PRIMARY KEY,
    PubName VARCHAR(40)
);

CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY,
    ISBN INT,
    BranchNo INT,
    Price FLOAT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (ISBN) REFERENCES Book(ISBN),
    FOREIGN KEY (BranchNo) REFERENCES Branch(BranchNo)
);

CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY,
    Username VARCHAR(50),
    User_Password CHAR(64),
    Email VARCHAR(50)
);

CREATE TABLE Wishlist (
    WishID SERIAL PRIMARY KEY,
    UserID INT,
    ISBN INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ISBN) REFERENCES Book(ISBN)
);

CREATE TABLE Staff (
    StaffID SERIAL PRIMARY KEY,
    ManagerID INT,
    Fname VARCHAR(40),
    LName VARCHAR(40),
    Salary FLOAT,
    FOREIGN KEY (ManagerID) REFERENCES Manager(ManagerID)
);

CREATE TABLE Author_Book (
    AuthorID INT,
    ISBN INT,
    PRIMARY KEY (AuthorID, ISBN),
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID),
    FOREIGN KEY (ISBN) REFERENCES Book(ISBN)
);

CREATE TABLE Author_Pub (
    AuthorID INT,
    PubID INT,
    PRIMARY KEY (AuthorID, PubID),
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID),
    FOREIGN KEY (PubID) REFERENCES Publisher(PubID)
);

CREATE TABLE Book_Pub (
    ISBN INT,
    PubID INT,
    PRIMARY KEY (ISBN, PubID),
    FOREIGN KEY (ISBN) REFERENCES Book(ISBN),
    FOREIGN KEY (PubID) REFERENCES Publisher(PubID)
);
