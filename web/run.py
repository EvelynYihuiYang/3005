from flask import Flask, render_template, request, redirect, session
from dao import *


app = Flask(__name__)
app.secret_key = '123456'


@app.route('/', methods=['GET', 'POST'])
def run():
    if 'name_info' in session:
        name_info = session['name_info']
        type = name_info['type']
        if type == 'user':
            return redirect('/book_search')
        elif type == 'owner':
            return redirect('/book_manage')
    else:
        return redirect('/login')


@app.route('/login', methods=['GET', 'POST'])
def login():
    name_dic = query_name()
    error = None
    if request.method == 'POST':
        # check user table
        if request.form.get('name') in name_dic:
            name = request.form.get('name')
            password = request.form.get('password')
            if password == name_dic[name][0]:
                type = name_dic[name][1]
                name_info = {
                    "name": name,
                    "type": type
                }
                session['name_info'] = name_info
                if type == 'user':
                    return redirect('/book_search')
                elif type == 'owner':
                    return redirect('/book_manage')
            else:
                error = 'Invalid username/password'
    return render_template('login.html', error=error)


@app.route('/register', methods=['GET', 'POST'])
def register():
    if 'name_info'not in session:
        return redirect('/login')
    if request.method == 'GET':
        return render_template('register.html')
    if request.method == 'POST':
        name = request.form.get('name')
        password = request.form.get('password')
        creditcard = request.form.get('creditcard')
        if name is not None and name != '':
            if password is not None and password != '':
                if creditcard is not None and creditcard != '':
                    insert_user(name, password, creditcard)
                    return render_template('login.html')
        error = "Register Failed!"
        return render_template('register.html', errror=error)


@app.route('/book_search', methods=['GET', 'POST'])
def book_search():
    if 'name_info'not in session:
        return redirect('/login')
    book_name = ''
    if request.method == "POST":
        book_name = request.form.get("book_name")
    rows = query_book(book_name)
    table = []
    for row in rows:
        r_book_name = row[0]
        author_rows = query_book_write(r_book_name)
        author = ''
        for author_row in author_rows:
            author += author_row[0] + ';'
        genre_rows = query_book_type(r_book_name)
        genre = ''
        for genre_row in genre_rows:
            genre += genre_row[0] + ';'
        table.append([row[0], row[1], row[2], row[3], row[4], row[5], author, genre])
    label = ['BookName', 'ISBN', 'PublisherName', 'NumberOfPage', 'Price', 'Stock', 'AuthorName', 'GenreName']
    return render_template('book_search.html', table=table, label=label)


@app.route('/add_basket', methods=['POST'])
def add_basket():
    if 'name_info'not in session:
        return redirect('/login')
    book_name = request.form.get('book_name')
    user_name = session['name_info']['name']
    insert_basket(user_name, book_name)
    return 'success'


@app.route('/basket_search', methods=['GET', 'POST'])
def basket_search():
    if 'name_info'not in session:
        return redirect('/login')
    user_name = session['name_info']['name']
    table = query_basket(user_name)
    label = ['BookName', 'AddTime']
    return render_template('basket_search.html', table=table, label=label)


@app.route('/basket_delete', methods=['POST'])
def basket_delete():
    if 'name_info'not in session:
        return redirect('/login')
    user_name = session['name_info']['name']
    book_name = request.form.get('book_name')
    createTime = request.form.get('createTime')
    delete_basket(user_name, book_name, createTime)
    return 'success'


@app.route('/checkout', methods=['GET', 'POST'])
def checkout():
    if 'name_info'not in session:
        return redirect('/login')
    user_name = session['name_info']['name']
    table = query_basket(user_name)
    label = ['BookName', 'AddTime']
    price = calc_order_price(user_name)[0][0]
    return render_template('checkout.html', table=table, label=label, price=price)


@app.route('/order_add', methods=['POST'])
def order_add():
    if 'name_info'not in session:
        return redirect('/login')
    credit_card = request.form.get("credit_card")
    phone_number = request.form.get("phone_number")
    address = request.form.get("address")
    user_name = session['name_info']['name']
    user_order_number = user_name + time.strftime('%Y%m%d%H%M%S', time.localtime(time.time()))
    user_order = {
        'user_order_number': user_order_number,
        'user_name': user_name,
        "credit_card": credit_card,
        "phone_number": phone_number,
        "address": address,
    }
    add_order(user_order)
    return 'success'


@app.route('/order_search', methods=['GET', 'POST'])
def order_search():
    if 'name_info'not in session:
        return redirect('/login')
    user_name = session['name_info']['name']
    order_num = ''
    if request.method == "POST":
        order_num = request.form.get("order_num")
    table = query_order(user_name, order_num)
    label = ['Order Number', 'Loation', 'TrackTime']
    return render_template('order_search.html', table=table, label=label)


@app.route('/book_manage', methods=['GET', 'POST'])
def book_manage():
    book_name = ''
    rows = query_book(book_name)
    table = []
    for row in rows:
        r_book_name = row[0]
        author_rows = query_book_write(r_book_name)
        author = ''
        for author_row in author_rows:
            author += author_row[0] + ';'
        genre_rows = query_book_type(r_book_name)
        genre = ''
        for genre_row in genre_rows:
            genre += genre_row[0] + ';'
        table.append([row[0], row[1], row[2], row[3], row[4], row[5], author, genre])
    label = ['BookName', 'ISBN', 'PublisherName', 'NumberOfPage', 'Price', 'Stock', 'AuthorName', 'GenreName']
    return render_template('book_manage.html', table=table, label=label)


@app.route('/book_manage_add', methods=['GET', 'POST'])
def book_manage_add():
    publisher = query_publisher()
    author = query_autor()
    genre = query_genre()
    return render_template('book_manage_add.html', publisher=publisher, author=author, genre=genre)


@app.route('/book_add', methods=['POST'])
def book_add():
    book_name = request.form.get('book_name')
    isbn = request.form.get('isbn')
    publisher = request.form.get('publisher')
    number_of_page = request.form.get('number_of_page')
    price = request.form.get('price')
    author = request.form.get('author')
    genre = request.form.get('genre')
    transfer_percentage = request.form.get('transfer_percentage')
    book_info = {
        'book_name': book_name,
        'isbn': isbn,
        'publisher': publisher,
        'number_of_page': number_of_page,
        'price': price,
        'author': author,
        'genre': genre,
        "transfer_percentage": transfer_percentage,
    }
    add_book(book_info)
    return 'success'


@app.route('/book_delete', methods=['POST'])
def book_delete():
    book_name = request.form.get('book_name')
    delete_book(book_name)
    return 'success'


@app.route('/report', methods=['GET', 'POST'])
def report():
    sales_total = query_sales_total()
    sales_genre = query_sales_genre()
    sales_author = query_sales_author()
    sales_cost = query_sales_cost()
    return render_template('report.html', sales_total=sales_total, sales_genre=sales_genre,
        sales_author=sales_author, sales_cost=sales_cost)


@app.route('/place_order', methods=['GET', 'POST'])
def place_order():
    book_stocks = query_book_stock()
    for book_stock in book_stocks:
        book = book_stock[0]
        publisher = book_stock[1]
        stock = book_stock[2]
        if stock < 10:
            count = 20 - stock
            email_content = "Please send me " + str(count) + " " + book + " books."
            add_place_order(book, publisher, str(count), email_content)
    table = query_place_order()
    label = ['Publisher', 'Book Name', 'Order Count', 'Email Content', 'Create Time']
    return render_template('place_order.html', table=table, label=label)


app.run(host='127.0.0.1', port=8080)
