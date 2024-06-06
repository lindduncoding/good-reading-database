BEGIN TRANSACTION;

SAVEPOINT order_saved;

-- Populate Order Table

INSERT INTO Orders (isbn, branchid, price)
SELECT
    8 AS isbn, 
    inv.branchid AS branch_id,
    bk.price AS price
FROM
    Inventory inv
JOIN
    Book bk ON inv.inventoryid = bk.inventoryid
WHERE
    bk.isbn = 8;

-- Update Branch Revenue

UPDATE branch
SET revenue = revenue + (SELECT price FROM book WHERE isbn = 8)
WHERE branchno = (SELECT branchid FROM inventory i WHERE i.inventoryid = 
				(SELECT inventoryid FROM book WHERE isbn = 8));

-- Update Book Stock

UPDATE book
SET stock = stock - 1
WHERE isbn = 8;

ROLLBACK TO order_saved;
COMMIT;