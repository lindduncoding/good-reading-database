from app import app
from app.db import init_app

if __name__ == '__main__':
    init_app(app)
    app.run(debug=True)