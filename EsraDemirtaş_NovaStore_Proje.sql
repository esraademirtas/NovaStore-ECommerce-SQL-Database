-- PROJE: NovaStore E-Ticaret Veri Yönetim Sistemi
-- HAZIRLAYAN: ESRA DEMÝRTAÞ


-- BÖLÜM 1: Veri Tabaný Tasarýmý (Logical Design ve DDL)

-- 1. Veri Tabaný Oluþturma
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'NovaStoreDB')
BEGIN
    CREATE DATABASE NovaStoreDB;
END
GO

USE NovaStoreDB;
GO

-- 2. Tablo Gereksinimleri

-- Tablo: Categories (Kategoriler)
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);
GO

-- Tablo: Customers (Müþteriler)
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    City VARCHAR(20),
    Email VARCHAR(100) UNIQUE NOT NULL
);
GO

-- Tablo: Shippers (Kargo Firmalarý)
CREATE TABLE Shippers (
    ShipperID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyName VARCHAR(50) NOT NULL,
    ContactPhone VARCHAR(15)
);
GO

-- Tablo: Products (Ürünler)
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    Stock INT DEFAULT 0 CHECK (Stock >= 0),
    CategoryID INT,
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
GO

-- Tablo: Orders (Sipariþler)
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    ShipperID INT, -- Kargoya baðlandý
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2) CHECK (TotalAmount >= 0),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Orders_Shippers FOREIGN KEY (ShipperID) REFERENCES Shippers(ShipperID)
);
GO

-- Tablo: OrderDetails (Sipariþ Detaylarý)
CREATE TABLE OrderDetails (
    DetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- Tablo: Payments (Ödemeler)
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT UNIQUE, 
    PaymentMethod VARCHAR(50) NOT NULL, 
    IsSuccessful BIT DEFAULT 1, 
    PaymentDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Payments_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
GO

-- Tablo: ProductReviews (Ürün Yorumlarý)
CREATE TABLE ProductReviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5), 
    Comment VARCHAR(500),
    ReviewDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Reviews_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Reviews_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO


-- BÖLÜM 2: Veri Giriþi (DML - Insert)

-- Görev 1: Kategori Ekleme
INSERT INTO Categories (CategoryName)
VALUES ('Elektronik'), ('Giyim'), ('Kitap'), ('Kozmetik'), ('Ev ve Yaþam');
GO

-- Kargo Firmalarýný Ekleme
INSERT INTO Shippers (CompanyName, ContactPhone)
VALUES ('Hýzlý Kargo', '0850 123 45 67'), ('Güvenli Lojistik', '0850 987 65 43');
GO

-- Görev 2: Ürün Ekleme
INSERT INTO Products (ProductName, Price, Stock, CategoryID)
VALUES 
    ('Geliþtirici Laptop', 35000.00, 15, 1), 
    ('Akýllý Telefon', 22000.00, 30, 1), 
    ('Kablosuz Kulaklýk', 2500.00, 50, 1), 
    ('Kýþlýk Kaþe Mont', 3200.00, 20, 2), 
    ('Spor Ayakkabý', 1800.00, 40, 2), 
    ('Veri Bilimi ve Makine Öðrenmesi', 450.00, 100, 3), 
    ('Algoritma Tasarýmý', 350.00, 80, 3), 
    ('Nemlendirici Yüz Kremi', 600.00, 60, 4), 
    ('Erkek Parfüm 100ml', 1500.00, 25, 4), 
    ('Ergonomik Çalýþma Sandalyesi', 4500.00, 10, 5),
    ('LED Masa Lambasý', 850.00, 35, 5);
GO

-- Görev 3: Müþteri Ekleme
INSERT INTO Customers (FullName, City, Email)
VALUES 
    ('Ahmet Yýlmaz', 'Ýstanbul', 'ahmet.yilmaz@email.com'), 
    ('Ayþe Kaya', 'Ankara', 'ayse.kaya@email.com'), 
    ('Mehmet Demir', 'Ýzmir', 'mehmet.demir@email.com'), 
    ('Fatma Çelik', 'Bursa', 'fatma.celik@email.com'), 
    ('Caner Þahin', 'Antalya', 'caner.sahin@email.com'), 
    ('Zeynep Yýldýz', 'Ýstanbul', 'zeynep.yildiz@email.com');
GO

-- Görev 4: Sipariþler ve Sipariþ Detaylarý
INSERT INTO Orders (CustomerID, ShipperID, OrderDate, TotalAmount)
VALUES 
    (1, 1, DATEADD(day, -10, GETDATE()), 36500.00), 
    (2, 1, DATEADD(day, -5, GETDATE()), 4500.00),   
    (3, 1, DATEADD(day, -2, GETDATE()), 5000.00),   
    (1, 1, DATEADD(day, -1, GETDATE()), 1250.00),   
    (4, 2, DATEADD(day, -15, GETDATE()), 3200.00),  
    (5, 2, DATEADD(day, -8, GETDATE()), 22000.00),  
    (6, 2, DATEADD(day, -20, GETDATE()), 3600.00),  
    (2, 2, GETDATE(), 600.00);                      
GO

INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
VALUES 
    (1, 1, 1), (1, 9, 1),
    (2, 10, 1),
    (3, 3, 2),
    (4, 6, 1), (4, 11, 1),
    (5, 4, 1),
    (6, 2, 1),
    (7, 5, 2),
    (8, 8, 1);
GO

-- Ödemeleri Ekleme
INSERT INTO Payments (OrderID, PaymentMethod, IsSuccessful)
VALUES 
    (1, 'Kredi Kartý', 1), (2, 'Banka Havalesi', 1), (3, 'Kredi Kartý', 1),
    (4, 'Kredi Kartý', 0), (5, 'Kapýda Ödeme', 1), (6, 'Kredi Kartý', 1),
    (7, 'Banka Havalesi', 1), (8, 'Kredi Kartý', 1);
GO

-- Ürün Yorumlarý Ekleme
INSERT INTO ProductReviews (CustomerID, ProductID, Rating, Comment, ReviewDate)
VALUES 
    (1, 1, 5, 'Laptop yazýlým geliþtirme için harika, kesinlikle tavsiye ederim.', DATEADD(day, -8, GETDATE())),
    (2, 10, 4, 'Sandalye çok rahat ama kurulumu biraz zor.', DATEADD(day, -3, GETDATE())),
    (4, 4, 5, 'Kýþlýk mont çok sýcak tutuyor, bedeni tam oldu.', DATEADD(day, -10, GETDATE())),
    (3, 3, 2, 'Kulaklýðýn þarjý çabuk bitiyor, pek memnun kalmadým.', DATEADD(day, -1, GETDATE()));
GO


-- BÖLÜM 3: Sorgulama ve Analiz (DQL - Select ve Joins)

-- 1. Temel Listeleme
SELECT ProductName AS 'Ürün Adý', Stock AS 'Kalan Stok'
FROM Products
WHERE Stock < 20
ORDER BY Stock DESC;
GO

-- 2. Veri Birleþtirme (JOIN)
SELECT 
    c.FullName AS 'Müþteri Adý', 
    c.City AS 'Þehir', 
    FORMAT(o.OrderDate, 'dd.MM.yyyy HH:mm') AS 'Sipariþ Tarihi', 
    o.TotalAmount AS 'Toplam Tutar (TL)'
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;
GO

-- 3. Çoklu Birleþtirme ve Detay Raporu
SELECT 
    c.FullName AS 'Müþteri Adý', 
    cat.CategoryName AS 'Kategori', 
    p.ProductName AS 'Ürün Adý', 
    p.Price AS 'Birim Fiyat (TL)', 
    od.Quantity AS 'Adet',
    (p.Price * od.Quantity) AS 'Kalem Ara Toplam (TL)'
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories cat ON p.CategoryID = cat.CategoryID
WHERE c.FullName = 'Ahmet Yýlmaz';
GO

-- 4. Gruplama ve Aggregate Fonksiyonlar
SELECT 
    cat.CategoryName AS 'Kategori', 
    COUNT(p.ProductID) AS 'Kayýtlý Ürün Çeþidi Sayýsý'
FROM Categories cat
LEFT JOIN Products p ON cat.CategoryID = p.CategoryID
GROUP BY cat.CategoryName;
GO

-- 5. Ciro Analizi 
SELECT 
    c.FullName AS 'Müþteri Adý', 
    SUM(o.TotalAmount) AS 'Toplam Kazanç (TL)'
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FullName
ORDER BY SUM(o.TotalAmount) DESC;
GO

-- 6. Zaman Analizi (Feature Engineering)
SELECT 
    o.OrderID AS 'Sipariþ No',
    c.FullName AS 'Müþteri',
    FORMAT(o.OrderDate, 'dd.MM.yyyy') AS 'Sipariþ Tarihi',
    DATEDIFF(day, o.OrderDate, GETDATE()) AS 'Geçen Gün Sayýsý',
    CASE 
        WHEN DATEDIFF(day, o.OrderDate, GETDATE()) = 0 THEN 'Bugün Verildi'
        WHEN DATEDIFF(day, o.OrderDate, GETDATE()) <= 3 THEN 'Yeni Sipariþ'
        WHEN DATEDIFF(day, o.OrderDate, GETDATE()) <= 14 THEN 'Normal'
        ELSE 'Eski Sipariþ'
    END AS 'Sipariþ Etiketi'
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID;
GO

-- EK ANALÝZ 7: Ürün Performans ve Müþteri Memnuniyeti Raporu
SELECT 
    p.ProductName AS 'Ürün Adý',
    cat.CategoryName AS 'Kategori',
    ISNULL(CAST(AVG(CAST(pr.Rating AS DECIMAL(10,2))) AS DECIMAL(10,1)), 0) AS 'Ortalama Puan (Yýldýz)',
    COUNT(pr.ReviewID) AS 'Yorum Sayýsý',
    ISNULL(SUM(CASE WHEN pay.IsSuccessful = 1 THEN (od.Quantity * p.Price) ELSE 0 END), 0) AS 'Gerçekleþen Ciro (TL)'
FROM Products p
LEFT JOIN Categories cat ON p.CategoryID = cat.CategoryID
LEFT JOIN ProductReviews pr ON p.ProductID = pr.ProductID
LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
LEFT JOIN Orders o ON od.OrderID = o.OrderID
LEFT JOIN Payments pay ON o.OrderID = pay.OrderID
GROUP BY p.ProductName, cat.CategoryName
ORDER BY 'Ortalama Puan (Yýldýz)' DESC, 'Gerçekleþen Ciro (TL)' DESC;
GO


-- BÖLÜM 4: Ýleri Seviye Veri Tabaný Nesneleri

-- 1. View Oluþturma
CREATE VIEW vw_SiparisOzet 
AS
SELECT 
    c.FullName AS MusteriAdi, 
    FORMAT(o.OrderDate, 'dd.MM.yyyy HH:mm') AS SiparisTarihi, 
    p.ProductName AS UrunAdi, 
    od.Quantity AS Adet
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID;
GO

-- 2. Yedekleme (Backup)
BACKUP DATABASE NovaStoreDB
TO DISK = 'C:\Yedek\NovaStoreDB.bak'
WITH FORMAT,
     INIT,
     NAME = 'NovaStoreDB Tam Yedek (Full Backup)',
     STATS = 10;
GO