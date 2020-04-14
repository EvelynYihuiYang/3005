import pymysql
import time


def execute_query(sql):
    print(sql)
    conn = pymysql.connect(host='127.0.0.1', user='root', password='root',
                           database='bookstore', charset='utf8')
    cursor = conn.cursor()
    cursor.execute(sql)
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return rows


def execute_update(sql):
    print(sql)
    conn = pymysql.connect(host='127.0.0.1', user='root', password='root',
                           database='bookstore', charset='utf8')
    cursor = conn.cursor()
    cursor.execute(sql)
    conn.commit()
    cursor.close()
    conn.close()


def query_name():
    name_dic = {}
    sql = """
        select username as username, password, 'user' as type from user
        union all 
        select ownername  as username, password, 'owner' as type from owner
    """
    rows = execute_query(sql)
    for row in rows:
        name_dic[row[0]] = [row[1], row[2]]
    return name_dic


def insert_user(name, password, creditcard):
    sql = "insert into user values('" + name + "', '" + password + "', '" + creditcard + "');"
    execute_update(sql)


def query_book(name):
    sql = """
        SELECT b.BookName,
        b.ISBN,
        b.PublisherName,
        b.NumberOfPage,
        b.Price,
        b.stock        
        FROM 
        book b 
    """
    if name is not None and name != '':
        sql += "and b.BookName like '%" + name + "%' "
    sql += "order by b.BookName;"
    rows = execute_query(sql)
    return rows


def query_book_write(name):
    sql = "select authorname from bookwrite where bookname='" + name + "';"
    rows = execute_query(sql)
    return rows


def query_book_type(name):
    sql = "SELECT g.GenreName FROM booktype b, genre g where b.GenreNumber = g.GenreNumber and b.BookName="
    sql += "'" + name + "';"
    rows = execute_query(sql)
    return rows


def insert_basket(user_name, book_name):
    sql = "insert into basket(UserName, BookName, CreateTime) values('" + user_name + "', '" + book_name + "', now());"
    execute_update(sql)


def query_basket(user_name):
    sql = "select BookName, CreateTime from basket where UserName ='" + user_name + "'"
    rows = execute_query(sql)
    return rows


def delete_basket(user_name, book_name, createTime):
    sql = "delete from basket where UserName ='" + user_name + "' and BookName = '" + book_name + "' "
    sql += "and createTime='" + createTime + "';"
    execute_update(sql)


def calc_order_price(user_name):
    sql = "SELECT sum(bo.Price) FROM basket ba, book bo where ba.BookName = bo.BookName and ba.UserName = '" \
          + user_name + "'"
    rows = execute_query(sql)
    return rows


def add_order(user_order):
    sql = "insert into userorder(UserOrderNumber, UserName, createTime, CreditCard, PhoneNumber, Address) values("
    sql += "'" + user_order['user_order_number'] + "',"
    sql += "'" + user_order['user_name'] + "',"
    sql += "now(),"
    sql += "'" + user_order['credit_card'] + "',"
    sql += "'" + user_order['phone_number'] + "',"
    sql += "'" + user_order['address'] + "');"
    execute_update(sql)
    query_sql = "select BookName from basket where UserName='" + user_order['user_name'] + "';"
    book_names = execute_query(query_sql)
    for book_name in book_names:
        insert_sql = "insert into userorderitem(UserOrderNumber, BookName) values("
        insert_sql += "'" + user_order['user_order_number'] + "',"
        insert_sql += "'" + book_name[0] + "');"
        execute_update(insert_sql)
        update_sql = "update book set stock = stock -1 where bookname ='" + book_name[0] + "';"
        execute_update(update_sql)
    delete_sql = "delete from basket where UserName = '" + user_order['user_name'] + "'"
    execute_update(delete_sql)


def query_order(user_name, order_num):
    sql = """
        select u.UserOrderNumber, t.location, t.createTime 
        from userorder u
        left join trackinfo t
        on u.UserOrderNumber = t.UserOrderNumber 
        where 1=1 
    """
    if user_name is not None and user_name != '':
        sql += "and u.UserName like '%" + user_name + "%' "
    if order_num is not None and order_num != '':
        sql += "and u.UserOrderNumber like '%" + order_num + "%';"
    rows = execute_query(sql)
    return rows


def query_publisher():
    sql = "select publishername from publisher"
    rows = execute_query(sql)
    return rows


def query_autor():
    sql = "select authorname from author"
    rows = execute_query(sql)
    return rows


def query_genre():
    sql = "select genrenumber,genrename from genre"
    rows = execute_query(sql)
    return rows

def add_book(book_info):
    sql = "insert into book(bookname, isbn, publisherName, numberofpage, price, transferpercentage)"
    sql += "values( "
    sql += "'" + book_info['book_name'] + "',"
    sql += "'" + book_info['isbn'] + "',"
    sql += "'" + book_info['publisher'] + "',"
    sql += "'" + book_info['number_of_page'] + "',"
    sql += "'" + book_info['price'] + "',"
    sql += "'" + book_info['transfer_percentage'] + "');"
    execute_update(sql)
    authors = book_info['author'].split(',')
    for author in authors:
        author_sql = "insert into bookwrite(bookname, authorname) values("
        author_sql += "'" + book_info['book_name'] + "',"
        author_sql += "'" + author + "');"
        execute_update(author_sql)
    genres = book_info['genre'].split(',')
    for genre in genres:
        genre_sql = "insert into booktype(bookname, genrenumber) values("
        genre_sql += "'" + book_info['book_name'] + "',"
        genre_sql += "'" + genre + "');"
        execute_update(genre_sql)


def delete_book(book_name):
    sql1 = "delete from booktype where bookname='" + book_name + "'"
    execute_update(sql1)
    sql2 = "delete from bookwrite where bookname='" + book_name + "'"
    execute_update(sql2)
    sql3 = "delete from book where bookname='" + book_name + "'"
    execute_update(sql3)


def query_sales_total():
    sql = "SELECT sum(price) FROM userorderitem u, book b where u.BookName = b.BookName"
    rows = execute_query(sql)
    return rows


def query_sales_author():
    sql = """
        SELECT bw.AuthorName, sum(b.price) FROM 
        userorderitem u, book b, bookwrite bw 
        where u.BookName = b.BookName
        and b.BookName = bw.BookName
        group by bw.AuthorName
    """
    rows = execute_query(sql)
    return rows


def query_sales_genre():
    sql = """
        SELECT g.GenreName, sum(b.price) FROM 
        userorderitem u, book b, booktype bt , genre g
        where u.BookName = b.BookName
        and b.BookName = bt.BookName
        and bt.GenreNumber = g.GenreNumber
        group by g.GenreName
    """
    rows = execute_query(sql)
    return rows


def query_sales_cost():
    sql = "SELECT ROUND(sum(price * TransferPercentage), 2) FROM userorderitem u, book b where u.BookName = b.BookName"
    rows = execute_query(sql)
    return rows


def query_book_stock():
    sql = "select bookname, publishername, stock from book where placed=false"
    rows = execute_query(sql)
    return rows


def add_place_order(book, publisher, count, email_content):
    sql = "insert into ownerorder(publishername, bookname, bookcount, emailcontent, createTime)"
    sql += "values("
    sql += "'" + publisher + "',"
    sql += "'" + book + "',"
    sql += "'" + count + "',"
    sql += "'" + email_content + "',"
    sql += "now());"
    execute_update(sql)
    update_sql = "update book set placed=true where bookname = '" + book + "';"
    execute_update(update_sql)


def query_place_order():
    sql = "select PublisherName, bookname, bookcount, emailcontent, createtime from ownerorder"
    rows = execute_query(sql)
    return rows


