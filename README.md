# 🛒 NovaStore E-Commerce Database Management System

Bu proje, "NovaStore" adlı kurgusal bir e-ticaret platformu için sıfırdan tasarlanmış, veri bütünlüğüne (Data Integrity) ve analitik raporlamaya odaklanan kapsamlı bir ilişkisel veri tabanı (RDBMS) mimarisidir. 

Veri analizi ve makine öğrenmesi projeleri için temiz veri seti oluşturma (Data Wrangling / Feature Engineering) süreçlerine uygun olarak, gerçek dünya üretim (production) standartları gözetilerek geliştirilmiştir.

## 🚀 Proje Öne Çıkan Özellikleri
- **Genişletilmiş Mimari:** Temel e-ticaret tablolarına (Müşteri, Ürün, Sipariş) ek olarak Kargo (Shippers), Ödeme Başarı Durumları (Payments) ve Müşteri Değerlendirmeleri (ProductReviews) entegre edilmiştir.
- **Veri Bütünlüğü (Data Integrity):** Negatif stok, geçersiz fiyat veya mantıksız sipariş adetlerini engelleyen `CHECK` kısıtlamaları (constraints) kullanılmıştır.
- **Feature Engineering:** Sipariş tarihleri `DATEDIFF` ve `CASE WHEN` yapıları ile analiz edilerek siparişler sınıflandırılmıştır ("Yeni Sipariş", "Eski Sipariş" vb.).
- **Kalite ve Performans Analizi:** İptal olan ödemeler filtrelenerek **Net Ciro** hesaplanmış, eksik veriler (Null Handling) `ISNULL` ile yönetilmiş ve ürün bazlı yıldız puanı ortalamaları çıkarılmıştır.
- **Veri Güvenliği ve Optimizasyon:** Sık kullanılan karmaşık çoklu `JOIN` sorguları için `VIEW` oluşturulmuş, veri tabanı için `STATS=10` parametreli `FULL BACKUP` senaryosu yazılmıştır.

## 📊 Veri Tabanı Şeması (ERD)
![NovaStore ER Diagram](EsraDemirtas_NovaStore_Proje.png)

*(Not: Eğer PNG dosyanın adını farklı kaydettiysen, yukarıdaki parantez içindeki dosya adını kendi dosya adınla değiştirmeyi unutma.)*

## 🛠️ Kullanılan Teknolojiler
- **Microsoft SQL Server (T-SQL)**
- **Veri Tabanı Nesneleri:** DDL, DML, DQL, Constraints (PK, FK, Check, Unique), Aggregate Functions, Subqueries, Joins, Views.

## 📂 Dosya Yapısı
- `EsraDemirtas_NovaStore_Proje.sql` : Veri tabanını oluşturan, verileri giren, analiz sorgularını çalıştıran ve yedekleme yapan tüm işlemlerin bulunduğu tek parça SQL scripti.
- `EsraDemirtas_NovaStore_Proje.docx` : İş zekası (BI) perspektifiyle hazırlanmış, sorgu çıktılarının ve yönetsel açıklamaların bulunduğu proje raporu.

## 💻 Nasıl Çalıştırılır?
1. `EsraDemirtas_NovaStore_Proje.sql` dosyasını SQL Server Management Studio (SSMS) üzerinde açın.
2. Tüm kod bloğunu seçip `Execute` (F5) tuşuna basarak çalıştırın. Script, `NovaStoreDB` adında bir veri tabanı oluşturacak ve gerekli tüm tabloları verilerle dolduracaktır.
