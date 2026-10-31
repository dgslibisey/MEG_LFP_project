# MEG + LFP projesi

Bir ana makale etrafında kurulmuş MEG ve LFP analiz projesi. Zamanla yeni makaleler ve
analizler eklenir; hepsi **aynı preprocessing çıktılarını** kullanır.
Kullanıcıyla Türkçe konuşulur.

## Araçlar
- MATLAB R2025b (`/Applications/MATLAB_R2025b.app/bin/matlab -batch "..."`)
- FieldTrip **sabit sürüm**: `/Users/dsabur/Documents/MATLAB/fieldtrip-20240110`
  - Projeye kopyalanmaz, içindeki dosyalar **değiştirilmez**.
  - `code/setup_paths.m` ile eklenir (`addpath` + `ft_defaults`, asla `genpath` değil).
- `~/Documents/MATLAB/` kök klasöründe FieldTrip'ten kopyalanmış mex/.m dosyaları ve
  başka bir veri seti (ds002778, EEG) var — bu projeyle ilgisi yok, MATLAB'ı oradan çalıştırma.

## Yapı
- `config/project_config.m` — tüm path'ler ve parametrelerin TEK kaynağı. Scriptlere sabit değer gömme.
- `config/subjects.tsv` — denek listesi (`include` = 1 olanlar işlenir), ham dosya yolları, notlar.
- `code/run_preprocessing.m` — `pp01_import → pp02_filter → pp03_epoch → pp04_clean`.
  Her adım `cfg.inputfile`/`cfg.outputfile` kullanır, `data/derivatives/<asama>/<sub>_meglfp.mat` yazar.
  `pp04_clean` interaktiftir (`ft_rejectvisual`).
- `code/functions/` — `stage_file`, `load_subject`, `needs_run` gibi ortak yardımcılar.
- `code/analyses/A0X_<isim>/` — her analiz/makale için ayrı klasör; `04_clean`'den okur,
  `data/results/A0X_<isim>/` altına yazar. Preprocessing'i analiz klasöründe tekrar yapma.
  Yeni analiz `code/analyses/_template/` kopyalanarak açılır.

## Analiz iş akışı (her zaman bu sırayla)
1. **`a0X_single.m`** — önce SADECE tek denekte (`P.dev_subject`) geliştirilir, `%%` bölümleri + kontrol figürleri.
2. Kullanıcı tek denekte çalıştığını onaylayınca:
   - **`a0X_subject.m`** — hesaplama fonksiyona taşınır: `res = a0X_subject(P, sub)` (figür yok, sonucu kaydeder).
     `a0X_single.m` de hesaplamayı bu fonksiyon üzerinden yapacak şekilde güncellenir.
   - **`a0X_all.m`** — tüm deneklerde `a0X_subject` döngüsü + grup düzeyi analiz.
- Tek denek onaylanmadan `_all` script'i yazılmaz.
- Preprocessing'de de aynı mantık: önce `run_preprocessing(steps, 'dev')`, sonra tüm denekler.
- `literature/main_paper/notes.md` — ana makalenin yöntem ve parametreleri.
- `literature/related/YYYY_Yazar_konu/notes.md` — sonradan eklenen makaleler.
- `docs/analysis_log.md` — yapılan analizlerin günlüğü.
- Kişisel proje, işyeriyle (TEB) ilgisi yok. Git kimliği bu repoda kişisel hesaba ayarlıdır;
  global git ayarı (iş e-postası) kullanılmaz. Uzak depo: kullanıcının kendi GitHub'ı.
- `data/`, `.mat` dosyaları ve makale PDF'leri `.gitignore` ile dışarıda; hasta verisi asla commit edilmez.
- Commit/push sadece kullanıcı isteyince.

## Kurallar
- Her script `P = setup_paths();` ile başlar.
- Yeni parametre → `project_config.m`'e eklenir, kaynağı yorumla yazılır.
- Preprocessing değişirse sadece etkilenen adımdan sonrası yeniden üretilir.
- Yeni makale → `literature/related/` + yeni `A0X` klasörü + `analysis_log.md` satırı.
