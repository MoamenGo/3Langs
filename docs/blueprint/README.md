# 3Lang blueprint: تعلم الألماني والهولندي والإسباني معًا من A0 إلى C1

ملفات تركيب مقترحة للمراجعة قبل البرمجة. مفيش أي حاجة هنا اتطبقت على الكود لسه.
وثيقة التصميم الكاملة: https://claude.ai/artifact/WocUbyCTwK6az7Qgaf5nmy

| الملف | المحتوى |
| --- | --- |
| STRUCTURE.txt | شجرة المجلدات المقترحة للتطبيق والمحتوى |
| config/languages.json | إعداد اللغات الثلاث (لون، صوت، ترتيب البداية، التشابه) |
| content/schema/concept.schema.json | شكل المفهوم المشترك والوحدة المشتركة |
| content/schema/lang_pack.schema.json | شكل حزمة لغة ومستوى (de/a1.json مثلًا) |
| content/schema/contrast.schema.json | شكل أزواج المقارنة والأصدقاء المزيفين |
| content/examples/ | مثال كامل: وحدة "البيت" بالثلاث لغات |
| supabase/002_multilang.sql | مسودة migration لبيانات المتعلم متعددة اللغات |
| app_sketch/ | واجهات Dart مختصرة للكيانات الأساسية والمخطط اليومي |
