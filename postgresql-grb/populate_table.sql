-- Populate Author
INSERT INTO Author (FName, LName)
SELECT
    (ARRAY['asd', 'fgh', 'hij'])[(random() * 2 + 1)::int],
    (ARRAY['zxcv', 'nop', 'pwn'])[(random() * 2 + 1)::int]
FROM generate_series(1, 20, 1);

-- Populate Publisher
INSERT INTO Publisher (PubName)
SELECT
    (ARRAY['penerbit', 'jokopub', 'bambangpub', 'ugm'])[(random() * 3 + 1)::int],
FROM generate_series(1, 20, 1);

-- Populate Users

FOR i IN 1..20 LOOP
    INSERT INTO Users (Username, Password, Email)
    VALUES ( -- generates a random hash as password
            'user' || i,
            md5(random()::text),
            'user' || i || '@protonmail.com');

-- Populate City (INSERT INTO manually)

-- Populate Manager

INSERT INTO manager (fname, lname, salary)
SELECT (ARRAY['abc','efg','hij'])[(random()*2+1)::int],
       (ARRAY['klm','nop','qvw'])[(random()*2+1)::int],
       (ARRAY[50, 60, 80, 100, 200])[(random()*4+1)::int]
FROM generate_series(1, 20, 1);

-- Populate Staff

INSERT INTO staff (fname, lname, managerid,salary)
SELECT (ARRAY['abc','efg','hij'])[(random()*2+1)::int],
       (ARRAY['klm','nop','qvw'])[(random()*2+1)::int],
	   (floor(random() * 20) + 1)::int,
       (ARRAY[
            9.99, 12.50, 15.00, 18.75, 20.00, 22.50, 25.00, 27.99, 30.00, 32.50, 
            35.00, 37.50, 40.00, 42.99, 45.00, 47.50, 50.00, 52.99, 55.00, 57.50
        ])[(random() * 19 + 1)::int]
FROM generate_series(1, 20, 1);

-- Populate Location

INSERT INTO Locations (Street, District, CityID)
SELECT
    (ARRAY['Jl. Kaliurang', 'Jl. Nusa', 'Jl. Skibidi Sigma Rizz', 'Jl. Damai', 'Jl. Jalan'])[(random() * 4 + 1)::int],
    (ARRAY['Cibaduyut', 'Ciomas', 'Jajar Sujajar', 'Poki', 'District 5'])[(random() * 4 + 1)::int],
    (floor(random() * 20) + 1)::int
FROM generate_series(1, 20, 1);

-- Populate Branch

INSERT INTO Branch (ManagerID, LocationID)
SELECT m.ManagerID, l.LocationID
FROM (
    SELECT ManagerID, ROW_NUMBER() OVER () AS row_num
    FROM Manager
    LIMIT 20
) AS m
JOIN (
    SELECT LocationID, ROW_NUMBER() OVER () AS row_num
    FROM Locations
    LIMIT 20
) AS l
ON m.row_num = l.row_num;

-- Populate Inventory

INSERT INTO inventory (branchID)
SELECT
    (floor(random() * 20) + 1)::int
FROM generate_series(1, 20, 1);

-- Populate Book

WITH book_data AS (
    SELECT
   (ARRAY[
        'Ayah Mengapa Pacarku Ketua Geng Motor?', 'Identity Reboot', 'Journey to the Unknown', 
        'The Last Kingdom', 'The Making of eveGPT', 'The Future of Us', 'The Lost World', 
        'How To Legally Disappear', 'The PROX Transmissions', 'The Silent Whisper', 'Brave New World', 
        'Shadow of the Moon', 'Legends of the Fall', 'The SEKI Project', 'Into the Wild', 
        'The Final Frontier', 'A Brief History of The Future', 'Waves of Time', 'Kalkulus Variabel Jamak Untuk Pemula', 
        'Practical Social Engineering'
    ])[row_number() OVER ()] AS Title,
        (floor(random() * 20) + 1)::int AS InventoryID,
        (floor(random() * (2024 - 1980 + 1)) + 1980)::int AS PublicationYear,
        (floor(random() * (1000 - 100 + 1)) + 100)::int AS Pages,
        (ARRAY[
            9.99, 12.50, 15.00, 18.75, 20.00, 22.50, 25.00, 27.99, 30.00, 32.50, 
            35.00, 37.50, 40.00, 42.99, 45.00, 47.50, 50.00, 52.99, 55.00, 57.50
        ])[(random() * 19 + 1)::int] AS Price,
        (floor(random() * 50) + 1)::int AS Stock
    FROM generate_series(1, 20)
)
INSERT INTO Book (InventoryID, Title, PublicationYear, Pages, Price, Stock)
SELECT InventoryID, Title, PublicationYear, Pages, Price, Stock
FROM book_data;

-- Populate Wishlist

INSERT INTO wishlist (userid, isbn)
SELECT
    (floor(random() * 20) + 1)::int,
	(floor(random() * 20) + 1)::int
FROM generate_series(1, 20, 1);

-- Populate Many-to-many Tables

INSERT INTO Author_Book (AuthorID, ISBN)
SELECT DISTINCT
    (floor(random() * 20) + 1)::int AS AuthorID,
    (floor(random() * 20) + 1)::int AS ISBN 
FROM generate_series(1, 20);

INSERT INTO Book_Pub (ISBN, PubID)
SELECT DISTINCT
    (floor(random() * 20) + 1)::int AS ISBN, 
    (floor(random() * 20) + 1)::int AS PubID     
FROM generate_series(1, 20);

INSERT INTO Author_Pub (AuthorID, PubID)
SELECT DISTINCT
    (floor(random() * 20) + 1)::int AS AuthorID, 
    (floor(random() * 20) + 1)::int AS PubID      
FROM generate_series(1, 20);