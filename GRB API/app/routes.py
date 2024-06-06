from flask import request, jsonify, abort
from app import app
from app.db import get_db
import psycopg2

from flask import request, jsonify, abort
from app import app
from app.db import get_db

@app.route('/search_books', methods=['GET'])
def search_books():
    search_term = request.args.get('search_term')

    if not search_term:
        abort(400, description='Search term is required.')

    db = get_db()
    cur = db.cursor()

    try:
        cur.execute("""
            SELECT b.ISBN, b.Title, a.FName AS AuthorFirstName, p.PubName AS PublisherName
            FROM Book b
            JOIN Author_Book ab ON b.ISBN = ab.ISBN
            JOIN Author a ON ab.AuthorID = a.AuthorID
            JOIN Book_Pub bp ON b.ISBN = bp.ISBN
            JOIN Publisher p ON bp.PubID = p.PubID
            WHERE b.Title LIKE %s
            OR a.FName LIKE %s
            OR p.PubName LIKE %s
        """, ('%' + search_term + '%', '%' + search_term + '%', '%' + search_term + '%'))
        
        books = cur.fetchall()

        # Format the results
        formatted_books = [{
            'ISBN': item[0],
            'Title': item[1],
            'AuthorFirstName': item[2],
            'PublisherName': item[3]
        } for item in books]

        cur.close()
        return jsonify(formatted_books), 200

    except Exception as e:
        cur.close()
        return jsonify({'error': str(e)}), 400

@app.route('/manager_branch', methods=['GET'])
def get_manager_branch_info():
    db = get_db()
    cur = db.cursor()


    cur.execute("""
        SELECT m.ManagerID, m.Fname, m.LName, b.BranchNo, l.Street, l.District, c.City, c.Province
        FROM Manager m
        JOIN Branch b ON m.ManagerID = b.ManagerID
        JOIN Locations l ON b.LocationID = l.LocationID
        JOIN City c ON l.CityID = c.CityID
    """)
        
    manager_branch_info = cur.fetchall()

    # Format the results
    formatted_data = [{
        'ManagerID': item[0],
        'FirstName': item[1],
        'LastName': item[2],
        'BranchNo': item[3],
        'Street': item[4],
        'District': item[5],
        'City': item[6],
        'Province': item[7]
    } for item in manager_branch_info]

    cur.close()
    return jsonify(formatted_data), 200

@app.route('/branch/revenue', methods=['GET'])
def get_branch_revenue():
    db = get_db()
    cur = db.cursor()


    cur.execute("SELECT * FROM BranchRevenue")
    branch_revenue = cur.fetchall()

    # Format the results
    branch_revenue_data = [{
        'branch_no': item[0],
        'total_revenue': item[1]
    } for item in branch_revenue]

    cur.close()
    return jsonify(branch_revenue_data), 200

@app.route('/branch/stock', methods=['GET'])
def get_branch_stock():
    db = get_db()
    cur = db.cursor()


    cur.execute("SELECT * FROM BranchBookStock")
    branch_revenue = cur.fetchall()

    # Format the results
    branch_revenue_data = [{
        'branch_no': item[0],
        'total_stock': item[1]
    } for item in branch_revenue]

    cur.close()
    return jsonify(branch_revenue_data), 200

@app.route('/user/<int:user_id>', methods=['PUT'])
def change_password(user_id):
    data = request.get_json()
    new_pass = data['new_pass']
    db = get_db()
    cur = db.cursor()
    cur.execute("UPDATE users SET user_password = %s WHERE userid = %s", (new_pass, user_id))
    db.commit()
    cur.close()
    return jsonify({'id': user_id, 'password': new_pass})

@app.route('/user/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    db = get_db()
    cur = db.cursor()
    cur.execute("DELETE FROM users WHERE userid = %s", (user_id,))
    db.commit()
    cur.close()
    return '', 204

@app.route('/wishlist', methods=['POST'])
def add_wishlist():
    data = request.get_json()
    user_id = data['user_id']
    isbn = data['isbn']
    db = get_db()
    cur = db.cursor()
    cur.execute("INSERT INTO wishlist (userid, isbn) VALUES (%s, %s) RETURNING wishid", (user_id, isbn))
    wish_id = cur.fetchone()[0]
    db.commit()
    cur.close()
    return jsonify({'id': wish_id, 'user_id': user_id, 'isbn': isbn}), 201

@app.route('/wishlist/<int:user_id>', methods=['PUT'])
def change_wishlist(user_id):
    data = request.get_json()
    isbn = data['isbn']
    db = get_db()
    cur = db.cursor()
    cur.execute("UPDATE wishlist SET isbn = %s WHERE userid = %s", (isbn, user_id))
    db.commit()
    cur.close()
    return jsonify({'user_id': user_id, 'isbn': isbn})

@app.route('/order', methods=['POST'])
def make_order():
    data = request.get_json()
    isbn = data['isbn']

    db = get_db()
    cur = db.cursor()

    try:
        # Start the transaction
        cur.execute("BEGIN")

        # Insert Into ORDER Table
        cur.execute("INSERT INTO Orders (isbn, branchid, price) SELECT %s AS isbn, inv.branchid AS branch_id, bk.price AS price FROM Inventory inv JOIN Book bk ON inv.inventoryid = bk.inventoryid WHERE bk.isbn = %s", (isbn, isbn))

        # Update Branch Revenue
        cur.execute("UPDATE branch SET revenue = revenue + (SELECT price FROM book WHERE isbn = %s) WHERE branchno = (SELECT branchid FROM inventory i WHERE i.inventoryid = (SELECT inventoryid FROM book WHERE isbn = %s))", (isbn, isbn))

        # Update Book Stock
        cur.execute("UPDATE book SET stock = stock - 1 WHERE isbn = %s;", (isbn,))

        # Commit the transaction
        db.commit()
        cur.close()

        return jsonify({'status': 'success', 'message': 'Transfer completed successfully.'}), 200

    except psycopg2.IntegrityError as e:
        db.rollback()
        cur.close()
        abort(400, description='Integrity constraint violation: {}'.format(e))

    except psycopg2.Error as e:
        db.rollback()
        cur.close()
        abort(400, description='Database error: {}'.format(e))

    except Exception as e:
        db.rollback()
        cur.close()
        abort(400, description='An unexpected error occurred: {}'.format(e))