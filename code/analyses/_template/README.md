# Analiz şablonu

Yeni analiz: bu klasörü `A0X_<isim>/` olarak kopyalayın, dosya adlarındaki `aXX` önekini değiştirin.

Her analiz iki aşamada yazılır:

1. **`aXX_single.m`**: tek denek üzerinde geliştirme (`P.dev_subject`).
   Bölüm bölüm (`%%`) çalıştırılır, ara figürler ve kontroller burada yapılır. Analiz önce burada çalışır hale getirilir.
2. Tek denekte çalışınca:
   - **`aXX_subject.m`**: single script'teki hesaplama kısmı bir fonksiyona taşınır: `res = aXX_subject(P, sub)`.
     Bu fonksiyon figür çizmez, sonucu `data/results/A0X_<isim>/` altına kaydeder.
   - **`aXX_all.m`**: tüm deneklerde `aXX_subject` fonksiyonunu çağırır, ardından grup düzeyindeki analizleri ve istatistikleri yapar.

`aXX_single.m` hesaplamayı da `aXX_subject` üzerinden yapar. Böylece tek denekte test edilen kod ile tüm deneklerde çalışan kod aynı kalır. Single script kontrol ve figürler için kullanılmaya devam eder.
