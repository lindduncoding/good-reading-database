# The Good Reading Bookstore Database

![Bookstore](https://github.com/lindduncoding/good-reading-database/assets/114661943/8aa603ba-32f3-4da7-9711-78926db40a93)

Good database for a good reading bookstore 👍. Built using PostgreSQL. To make your own instance of the database, simply copy the queries I provided. Made to be as normal as possible, inspired by the Sakila Database.

## API

API is also available to use. Built using Python and Flask. \
Deatils of the API include:
| Business Case                                               | URL                                     | Method | Arguments              |
|-------------------------------------------------------------|-----------------------------------------|--------|------------------------|
| Add book order information (using TCL)                      | localhost:5000/order                    | POST   | isbn                   |
| Aggregate branch revenue                                    | localhost:5000/branch/revenue           | GET    | -                      |
| Aggregate book stock per branch                             | localhost:5000/branch/stock             | GET    | -                      |
| See information about manager for each branch location      | localhost:5000/manager_branch           | GET    | -                      |
| Add a book to a user’s wishlist                             | localhost:5000/wishlist                 | POST   | isbn, userid           |
| Change book or user information about a wishlist            | localhost:5000/wishlist/[userid]        | PUT    | isbn, userid           |
| Change user’s password (forgot password usecase)            | localhost:5000/user/[userid]            | PUT    | new_pass, userid       |
| Delete a user (users have the rights to be forgotten)       | localhost:5000/user/[userid]            | DELETE | userid                |
| Search books, authors, or publishers by keywords            | localhost:5000/search_books?search_term=[keyword] | GET    | keyword               |

To test the API using curl:
```bash
curl -X GET [GET ENDPOINTS]
curl -X POST -H "Content-Type: application/json" -d '{"data_1" : "value_1"}' [POST ENDPOINTS]
curl -X PUT -H "Content-Type: application/json" -d '{"data_1" : "value_1"}' [POST ENDPOINTS]
curl -X DELETE [DELETE ENDPOINTS]
```

## Disclaimer

Yes this is a class project.
