#!/usr/bin/env python3
"""
Add the home-screen-widget string keys to every lib/l10n/app_*.arb.

Keys are inserted in a stable position (after `heroNet`, which is the closest
existing neighbour semantically) and existing values are never overwritten, so
this is safe to re-run.

Run from repo root:  python3 tool/add_widget_l10n_keys.py
"""
from __future__ import annotations

import json
from collections import OrderedDict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
L10N = ROOT / "lib/l10n"
ANCHOR = "heroNet"  # new keys are inserted right after this one

# Metadata for the template ARB only (app_en.arb).
DESCRIPTIONS = {
    "widgetLowestPoint": "Home-screen widget: metric name for the projected trough",
    "widgetProjected": "Home-screen widget: metric name for a projected value",
    "widgetHorizonIn7Days": "Home-screen widget: projection horizon, one week out",
    "widgetHorizonEndOfMonth": "Home-screen widget: projection horizon, end of month",
    "widgetMetricAccount": "Home-screen widget: metric name for a single account balance",
    "widgetQuickAdd": "Home-screen widget: name of the quick-add widget",
    "widgetStale": "Home-screen widget: footnote when the snapshot is older than its series",
    "widgetOpenToStart": "Home-screen widget: empty state before any accounts exist",
    "widgetDueToday": "Home-screen widget: header for planned items due today",
    "widgetDescQuickAdd": "Widget gallery: description of the quick-add widget",
    "widgetNameNumbers": "Widget gallery: name of the configurable numbers widget",
    "widgetDescNumbers": "Widget gallery: description of the configurable numbers widget",
    "widgetConfigMetric": "Widget configuration sheet: metric picker label",
    "widgetConfigHorizon": "Widget configuration sheet: horizon picker label",
    "widgetSiriAddTransaction": "Siri phrase for adding a tracked transaction. {appName} is replaced by the app name by the OS.",
    "widgetSiriAddPlanned": "Siri phrase for adding a planned transaction. {appName} is replaced by the app name by the OS.",
    "settingsWidgetAmountsTitle": "Settings: toggle for showing real amounts in home-screen widgets",
    "settingsWidgetAmountsSubtitle": "Settings: explanation of the widget amounts toggle",
}

PLACEHOLDERS = {
    "widgetSiriAddTransaction": {"appName": {"type": "String"}},
    "widgetSiriAddPlanned": {"appName": {"type": "String"}},
}

T: dict[str, dict[str, str]] = {
    "en": {
        "widgetLowestPoint": "Lowest point",
        "widgetProjected": "Projected",
        "widgetHorizonIn7Days": "In 7 days",
        "widgetHorizonEndOfMonth": "End of month",
        "widgetMetricAccount": "Account balance",
        "widgetQuickAdd": "Quick add",
        "widgetStale": "May be out of date",
        "widgetOpenToStart": "Open Platrare to add accounts",
        "widgetDueToday": "Due today",
        "widgetDescQuickAdd": "Add a transaction or a plan in one tap.",
        "widgetNameNumbers": "Balance",
        "widgetDescNumbers": "Show one figure: spendable, net worth, or your lowest point this month.",
        "widgetConfigMetric": "Metric",
        "widgetConfigHorizon": "Horizon",
        "widgetSiriAddTransaction": "Add a transaction in {appName}",
        "widgetSiriAddPlanned": "Add a planned transaction in {appName}",
        "settingsWidgetAmountsTitle": "Show amounts in widgets",
        "settingsWidgetAmountsSubtitle": "Home-screen widgets are visible without unlocking the app. While app lock is on, amounts stay masked unless you turn this on.",
    },
    "es": {
        "widgetLowestPoint": "Punto más bajo",
        "widgetProjected": "Proyectado",
        "widgetHorizonIn7Days": "En 7 días",
        "widgetHorizonEndOfMonth": "Fin de mes",
        "widgetMetricAccount": "Saldo de la cuenta",
        "widgetQuickAdd": "Añadir rápido",
        "widgetStale": "Puede estar desactualizado",
        "widgetOpenToStart": "Abre Platrare para añadir cuentas",
        "widgetDueToday": "Vence hoy",
        "widgetDescQuickAdd": "Añade una transacción o un plan con un toque.",
        "widgetNameNumbers": "Saldo",
        "widgetDescNumbers": "Muestra una cifra: disponible, patrimonio neto o tu punto más bajo del mes.",
        "widgetConfigMetric": "Métrica",
        "widgetConfigHorizon": "Horizonte",
        "widgetSiriAddTransaction": "Añadir una transacción en {appName}",
        "widgetSiriAddPlanned": "Añadir una transacción planificada en {appName}",
        "settingsWidgetAmountsTitle": "Mostrar importes en los widgets",
        "settingsWidgetAmountsSubtitle": "Los widgets de la pantalla de inicio se ven sin desbloquear la app. Con el bloqueo activado, los importes se ocultan salvo que actives esta opción.",
    },
    "fr": {
        "widgetLowestPoint": "Point le plus bas",
        "widgetProjected": "Projeté",
        "widgetHorizonIn7Days": "Dans 7 jours",
        "widgetHorizonEndOfMonth": "Fin du mois",
        "widgetMetricAccount": "Solde du compte",
        "widgetQuickAdd": "Ajout rapide",
        "widgetStale": "Peut être obsolète",
        "widgetOpenToStart": "Ouvrez Platrare pour ajouter des comptes",
        "widgetDueToday": "Échéance aujourd’hui",
        "widgetDescQuickAdd": "Ajoutez une transaction ou un plan en un geste.",
        "widgetNameNumbers": "Solde",
        "widgetDescNumbers": "Affichez un chiffre : disponible, patrimoine net ou votre point le plus bas du mois.",
        "widgetConfigMetric": "Indicateur",
        "widgetConfigHorizon": "Horizon",
        "widgetSiriAddTransaction": "Ajouter une transaction dans {appName}",
        "widgetSiriAddPlanned": "Ajouter une transaction planifiée dans {appName}",
        "settingsWidgetAmountsTitle": "Afficher les montants dans les widgets",
        "settingsWidgetAmountsSubtitle": "Les widgets de l’écran d’accueil sont visibles sans déverrouiller l’app. Lorsque le verrouillage est actif, les montants restent masqués sauf si vous activez cette option.",
    },
    "de": {
        "widgetLowestPoint": "Tiefstand",
        "widgetProjected": "Prognose",
        "widgetHorizonIn7Days": "In 7 Tagen",
        "widgetHorizonEndOfMonth": "Monatsende",
        "widgetMetricAccount": "Kontostand",
        "widgetQuickAdd": "Schnell erfassen",
        "widgetStale": "Möglicherweise veraltet",
        "widgetOpenToStart": "Platrare öffnen, um Konten anzulegen",
        "widgetDueToday": "Heute fällig",
        "widgetDescQuickAdd": "Buchung oder Plan mit einem Tipp hinzufügen.",
        "widgetNameNumbers": "Saldo",
        "widgetDescNumbers": "Eine Kennzahl anzeigen: verfügbar, Nettovermögen oder dein Tiefstand im Monat.",
        "widgetConfigMetric": "Kennzahl",
        "widgetConfigHorizon": "Zeithorizont",
        "widgetSiriAddTransaction": "Eine Buchung in {appName} hinzufügen",
        "widgetSiriAddPlanned": "Eine geplante Buchung in {appName} hinzufügen",
        "settingsWidgetAmountsTitle": "Beträge in Widgets anzeigen",
        "settingsWidgetAmountsSubtitle": "Widgets auf dem Home-Bildschirm sind ohne Entsperren sichtbar. Bei aktivierter App-Sperre bleiben Beträge verborgen, sofern du dies nicht einschaltest.",
    },
    "pt": {
        "widgetLowestPoint": "Ponto mais baixo",
        "widgetProjected": "Projetado",
        "widgetHorizonIn7Days": "Em 7 dias",
        "widgetHorizonEndOfMonth": "Fim do mês",
        "widgetMetricAccount": "Saldo da conta",
        "widgetQuickAdd": "Adição rápida",
        "widgetStale": "Pode estar desatualizado",
        "widgetOpenToStart": "Abra o Platrare para adicionar contas",
        "widgetDueToday": "Vence hoje",
        "widgetDescQuickAdd": "Adicione uma transação ou um plano num toque.",
        "widgetNameNumbers": "Saldo",
        "widgetDescNumbers": "Mostre um número: disponível, património líquido ou o seu ponto mais baixo do mês.",
        "widgetConfigMetric": "Métrica",
        "widgetConfigHorizon": "Horizonte",
        "widgetSiriAddTransaction": "Adicionar uma transação no {appName}",
        "widgetSiriAddPlanned": "Adicionar uma transação planeada no {appName}",
        "settingsWidgetAmountsTitle": "Mostrar valores nos widgets",
        "settingsWidgetAmountsSubtitle": "Os widgets do ecrã principal são visíveis sem desbloquear a app. Com o bloqueio ativo, os valores ficam ocultos a não ser que ative esta opção.",
    },
    "pt_BR": {
        "widgetLowestPoint": "Ponto mais baixo",
        "widgetProjected": "Projetado",
        "widgetHorizonIn7Days": "Em 7 dias",
        "widgetHorizonEndOfMonth": "Fim do mês",
        "widgetMetricAccount": "Saldo da conta",
        "widgetQuickAdd": "Adição rápida",
        "widgetStale": "Pode estar desatualizado",
        "widgetOpenToStart": "Abra o Platrare para adicionar contas",
        "widgetDueToday": "Vence hoje",
        "widgetDescQuickAdd": "Adicione uma transação ou um plano com um toque.",
        "widgetNameNumbers": "Saldo",
        "widgetDescNumbers": "Mostre um número: disponível, patrimônio líquido ou seu ponto mais baixo do mês.",
        "widgetConfigMetric": "Métrica",
        "widgetConfigHorizon": "Horizonte",
        "widgetSiriAddTransaction": "Adicionar uma transação no {appName}",
        "widgetSiriAddPlanned": "Adicionar uma transação planejada no {appName}",
        "settingsWidgetAmountsTitle": "Mostrar valores nos widgets",
        "settingsWidgetAmountsSubtitle": "Os widgets da tela de início ficam visíveis sem desbloquear o app. Com o bloqueio ativo, os valores ficam ocultos a menos que você ative esta opção.",
    },
    "it": {
        "widgetLowestPoint": "Punto più basso",
        "widgetProjected": "Previsto",
        "widgetHorizonIn7Days": "Tra 7 giorni",
        "widgetHorizonEndOfMonth": "Fine mese",
        "widgetMetricAccount": "Saldo del conto",
        "widgetQuickAdd": "Aggiunta rapida",
        "widgetStale": "Potrebbe non essere aggiornato",
        "widgetOpenToStart": "Apri Platrare per aggiungere conti",
        "widgetDueToday": "Scade oggi",
        "widgetDescQuickAdd": "Aggiungi una transazione o un piano con un tocco.",
        "widgetNameNumbers": "Saldo",
        "widgetDescNumbers": "Mostra un dato: disponibile, patrimonio netto o il punto più basso del mese.",
        "widgetConfigMetric": "Metrica",
        "widgetConfigHorizon": "Orizzonte",
        "widgetSiriAddTransaction": "Aggiungi una transazione in {appName}",
        "widgetSiriAddPlanned": "Aggiungi una transazione pianificata in {appName}",
        "settingsWidgetAmountsTitle": "Mostra importi nei widget",
        "settingsWidgetAmountsSubtitle": "I widget nella schermata Home sono visibili senza sbloccare l’app. Con il blocco attivo gli importi restano nascosti, a meno che tu non attivi questa opzione.",
    },
    "ru": {
        "widgetLowestPoint": "Минимум",
        "widgetProjected": "Прогноз",
        "widgetHorizonIn7Days": "Через 7 дней",
        "widgetHorizonEndOfMonth": "Конец месяца",
        "widgetMetricAccount": "Баланс счёта",
        "widgetQuickAdd": "Быстрое добавление",
        "widgetStale": "Данные могут быть устаревшими",
        "widgetOpenToStart": "Откройте Platrare, чтобы добавить счета",
        "widgetDueToday": "Сегодня",
        "widgetDescQuickAdd": "Добавьте операцию или план одним касанием.",
        "widgetNameNumbers": "Баланс",
        "widgetDescNumbers": "Покажите одну цифру: доступно, чистые активы или минимум за месяц.",
        "widgetConfigMetric": "Показатель",
        "widgetConfigHorizon": "Горизонт",
        "widgetSiriAddTransaction": "Добавить операцию в {appName}",
        "widgetSiriAddPlanned": "Добавить плановую операцию в {appName}",
        "settingsWidgetAmountsTitle": "Показывать суммы в виджетах",
        "settingsWidgetAmountsSubtitle": "Виджеты на экране «Домой» видны без разблокировки приложения. При включённой блокировке суммы скрыты, если не включить этот параметр.",
    },
    "pl": {
        "widgetLowestPoint": "Najniższy punkt",
        "widgetProjected": "Prognoza",
        "widgetHorizonIn7Days": "Za 7 dni",
        "widgetHorizonEndOfMonth": "Koniec miesiąca",
        "widgetMetricAccount": "Saldo konta",
        "widgetQuickAdd": "Szybkie dodawanie",
        "widgetStale": "Dane mogą być nieaktualne",
        "widgetOpenToStart": "Otwórz Platrare, aby dodać konta",
        "widgetDueToday": "Termin dzisiaj",
        "widgetDescQuickAdd": "Dodaj transakcję lub plan jednym dotknięciem.",
        "widgetNameNumbers": "Saldo",
        "widgetDescNumbers": "Pokaż jedną liczbę: dostępne środki, wartość netto lub najniższy punkt w tym miesiącu.",
        "widgetConfigMetric": "Wskaźnik",
        "widgetConfigHorizon": "Horyzont",
        "widgetSiriAddTransaction": "Dodaj transakcję w {appName}",
        "widgetSiriAddPlanned": "Dodaj zaplanowaną transakcję w {appName}",
        "settingsWidgetAmountsTitle": "Pokazuj kwoty w widżetach",
        "settingsWidgetAmountsSubtitle": "Widżety na ekranie głównym są widoczne bez odblokowania aplikacji. Przy włączonej blokadzie kwoty pozostają ukryte, chyba że włączysz tę opcję.",
    },
    "uk": {
        "widgetLowestPoint": "Мінімум",
        "widgetProjected": "Прогноз",
        "widgetHorizonIn7Days": "Через 7 днів",
        "widgetHorizonEndOfMonth": "Кінець місяця",
        "widgetMetricAccount": "Баланс рахунку",
        "widgetQuickAdd": "Швидке додавання",
        "widgetStale": "Дані можуть бути застарілими",
        "widgetOpenToStart": "Відкрийте Platrare, щоб додати рахунки",
        "widgetDueToday": "Сьогодні",
        "widgetDescQuickAdd": "Додайте операцію або план одним дотиком.",
        "widgetNameNumbers": "Баланс",
        "widgetDescNumbers": "Покажіть одне число: доступно, чисті активи або мінімум цього місяця.",
        "widgetConfigMetric": "Показник",
        "widgetConfigHorizon": "Горизонт",
        "widgetSiriAddTransaction": "Додати операцію в {appName}",
        "widgetSiriAddPlanned": "Додати заплановану операцію в {appName}",
        "settingsWidgetAmountsTitle": "Показувати суми у віджетах",
        "settingsWidgetAmountsSubtitle": "Віджети на екрані «Дім» видно без розблокування застосунку. Коли блокування ввімкнено, суми приховані, якщо не ввімкнути цей параметр.",
    },
    "nl": {
        "widgetLowestPoint": "Laagste punt",
        "widgetProjected": "Prognose",
        "widgetHorizonIn7Days": "Over 7 dagen",
        "widgetHorizonEndOfMonth": "Einde maand",
        "widgetMetricAccount": "Rekeningsaldo",
        "widgetQuickAdd": "Snel toevoegen",
        "widgetStale": "Mogelijk verouderd",
        "widgetOpenToStart": "Open Platrare om rekeningen toe te voegen",
        "widgetDueToday": "Vandaag verschuldigd",
        "widgetDescQuickAdd": "Voeg met één tik een transactie of plan toe.",
        "widgetNameNumbers": "Saldo",
        "widgetDescNumbers": "Toon één getal: besteedbaar, nettowaarde of je laagste punt deze maand.",
        "widgetConfigMetric": "Waarde",
        "widgetConfigHorizon": "Horizon",
        "widgetSiriAddTransaction": "Een transactie toevoegen in {appName}",
        "widgetSiriAddPlanned": "Een geplande transactie toevoegen in {appName}",
        "settingsWidgetAmountsTitle": "Bedragen tonen in widgets",
        "settingsWidgetAmountsSubtitle": "Widgets op het beginscherm zijn zichtbaar zonder de app te ontgrendelen. Met appvergrendeling aan blijven bedragen verborgen, tenzij je dit inschakelt.",
    },
    "tr": {
        "widgetLowestPoint": "En düşük nokta",
        "widgetProjected": "Öngörülen",
        "widgetHorizonIn7Days": "7 gün içinde",
        "widgetHorizonEndOfMonth": "Ay sonu",
        "widgetMetricAccount": "Hesap bakiyesi",
        "widgetQuickAdd": "Hızlı ekle",
        "widgetStale": "Güncel olmayabilir",
        "widgetOpenToStart": "Hesap eklemek için Platrare’ı açın",
        "widgetDueToday": "Bugün vadesi doluyor",
        "widgetDescQuickAdd": "Tek dokunuşla işlem veya plan ekleyin.",
        "widgetNameNumbers": "Bakiye",
        "widgetDescNumbers": "Tek bir rakam gösterin: kullanılabilir, net değer veya bu ayki en düşük noktanız.",
        "widgetConfigMetric": "Ölçüt",
        "widgetConfigHorizon": "Ufuk",
        "widgetSiriAddTransaction": "{appName} uygulamasına işlem ekle",
        "widgetSiriAddPlanned": "{appName} uygulamasına planlı işlem ekle",
        "settingsWidgetAmountsTitle": "Tutarları widget’larda göster",
        "settingsWidgetAmountsSubtitle": "Ana ekran widget’ları uygulama kilidi açılmadan görünür. Uygulama kilidi açıkken bunu etkinleştirmediğiniz sürece tutarlar gizli kalır.",
    },
    "sv": {
        "widgetLowestPoint": "Lägsta punkt",
        "widgetProjected": "Prognos",
        "widgetHorizonIn7Days": "Om 7 dagar",
        "widgetHorizonEndOfMonth": "Månadens slut",
        "widgetMetricAccount": "Kontosaldo",
        "widgetQuickAdd": "Snabbregistrera",
        "widgetStale": "Kan vara inaktuellt",
        "widgetOpenToStart": "Öppna Platrare för att lägga till konton",
        "widgetDueToday": "Förfaller i dag",
        "widgetDescQuickAdd": "Lägg till en transaktion eller en plan med en tryckning.",
        "widgetNameNumbers": "Saldo",
        "widgetDescNumbers": "Visa en siffra: disponibelt, nettoförmögenhet eller din lägsta punkt denna månad.",
        "widgetConfigMetric": "Mått",
        "widgetConfigHorizon": "Horisont",
        "widgetSiriAddTransaction": "Lägg till en transaktion i {appName}",
        "widgetSiriAddPlanned": "Lägg till en planerad transaktion i {appName}",
        "settingsWidgetAmountsTitle": "Visa belopp i widgetar",
        "settingsWidgetAmountsSubtitle": "Widgetar på hemskärmen syns utan att appen låses upp. När applåset är på döljs belopp om du inte slår på det här.",
    },
    "hi": {
        "widgetLowestPoint": "न्यूनतम बिंदु",
        "widgetProjected": "अनुमानित",
        "widgetHorizonIn7Days": "7 दिनों में",
        "widgetHorizonEndOfMonth": "महीने का अंत",
        "widgetMetricAccount": "खाता शेष",
        "widgetQuickAdd": "त्वरित जोड़ें",
        "widgetStale": "पुराना हो सकता है",
        "widgetOpenToStart": "खाते जोड़ने के लिए Platrare खोलें",
        "widgetDueToday": "आज देय",
        "widgetDescQuickAdd": "एक टैप में लेनदेन या योजना जोड़ें।",
        "widgetNameNumbers": "शेष",
        "widgetDescNumbers": "एक आँकड़ा दिखाएँ: उपलब्ध, कुल संपत्ति, या इस महीने का न्यूनतम बिंदु।",
        "widgetConfigMetric": "मीट्रिक",
        "widgetConfigHorizon": "अवधि",
        "widgetSiriAddTransaction": "{appName} में लेनदेन जोड़ें",
        "widgetSiriAddPlanned": "{appName} में नियोजित लेनदेन जोड़ें",
        "settingsWidgetAmountsTitle": "विजेट में राशि दिखाएँ",
        "settingsWidgetAmountsSubtitle": "होम स्क्रीन विजेट ऐप अनलॉक किए बिना दिखते हैं। ऐप लॉक चालू होने पर, जब तक आप इसे चालू न करें, राशियाँ छिपी रहती हैं।",
    },
    "ar": {
        "widgetLowestPoint": "أدنى نقطة",
        "widgetProjected": "متوقَّع",
        "widgetHorizonIn7Days": "خلال 7 أيام",
        "widgetHorizonEndOfMonth": "نهاية الشهر",
        "widgetMetricAccount": "رصيد الحساب",
        "widgetQuickAdd": "إضافة سريعة",
        "widgetStale": "قد تكون غير محدَّثة",
        "widgetOpenToStart": "افتح Platrare لإضافة حسابات",
        "widgetDueToday": "مستحق اليوم",
        "widgetDescQuickAdd": "أضف معاملة أو خطة بلمسة واحدة.",
        "widgetNameNumbers": "الرصيد",
        "widgetDescNumbers": "اعرض رقمًا واحدًا: المتاح للإنفاق أو صافي الثروة أو أدنى نقطة هذا الشهر.",
        "widgetConfigMetric": "المقياس",
        "widgetConfigHorizon": "المدى",
        "widgetSiriAddTransaction": "أضف معاملة في {appName}",
        "widgetSiriAddPlanned": "أضف معاملة مخطَّطة في {appName}",
        "settingsWidgetAmountsTitle": "إظهار المبالغ في الأدوات",
        "settingsWidgetAmountsSubtitle": "تظهر أدوات الشاشة الرئيسية دون فتح قفل التطبيق. عند تفعيل قفل التطبيق تبقى المبالغ مخفية ما لم تُفعِّل هذا الخيار.",
    },
    "ja": {
        "widgetLowestPoint": "最低残高",
        "widgetProjected": "予測",
        "widgetHorizonIn7Days": "7日後",
        "widgetHorizonEndOfMonth": "月末",
        "widgetMetricAccount": "口座残高",
        "widgetQuickAdd": "クイック追加",
        "widgetStale": "最新でない可能性があります",
        "widgetOpenToStart": "Platrare を開いて口座を追加",
        "widgetDueToday": "本日期限",
        "widgetDescQuickAdd": "ワンタップで取引や予定を追加します。",
        "widgetNameNumbers": "残高",
        "widgetDescNumbers": "使える額・純資産・今月の最低残高から 1 つを表示します。",
        "widgetConfigMetric": "指標",
        "widgetConfigHorizon": "期間",
        "widgetSiriAddTransaction": "{appName} で取引を追加",
        "widgetSiriAddPlanned": "{appName} で予定取引を追加",
        "settingsWidgetAmountsTitle": "ウィジェットに金額を表示",
        "settingsWidgetAmountsSubtitle": "ホーム画面のウィジェットはアプリのロックを解除しなくても見えます。アプリロックが有効な間は、これをオンにしない限り金額は伏せられます。",
    },
    "ko": {
        "widgetLowestPoint": "최저점",
        "widgetProjected": "예상",
        "widgetHorizonIn7Days": "7일 후",
        "widgetHorizonEndOfMonth": "월말",
        "widgetMetricAccount": "계좌 잔액",
        "widgetQuickAdd": "빠른 추가",
        "widgetStale": "최신 정보가 아닐 수 있음",
        "widgetOpenToStart": "Platrare를 열어 계좌를 추가하세요",
        "widgetDueToday": "오늘 예정",
        "widgetDescQuickAdd": "한 번의 탭으로 거래나 계획을 추가합니다.",
        "widgetNameNumbers": "잔액",
        "widgetDescNumbers": "가용 금액, 순자산, 이번 달 최저점 중 하나를 표시합니다.",
        "widgetConfigMetric": "지표",
        "widgetConfigHorizon": "기간",
        "widgetSiriAddTransaction": "{appName}에 거래 추가",
        "widgetSiriAddPlanned": "{appName}에 예정 거래 추가",
        "settingsWidgetAmountsTitle": "위젯에 금액 표시",
        "settingsWidgetAmountsSubtitle": "홈 화면 위젯은 앱 잠금을 해제하지 않아도 보입니다. 앱 잠금이 켜져 있으면 이 옵션을 켜기 전까지 금액이 가려집니다.",
    },
    "zh_Hans": {
        "widgetLowestPoint": "最低点",
        "widgetProjected": "预计",
        "widgetHorizonIn7Days": "7 天后",
        "widgetHorizonEndOfMonth": "月末",
        "widgetMetricAccount": "账户余额",
        "widgetQuickAdd": "快速添加",
        "widgetStale": "可能不是最新",
        "widgetOpenToStart": "打开 Platrare 添加账户",
        "widgetDueToday": "今天到期",
        "widgetDescQuickAdd": "一键添加交易或计划。",
        "widgetNameNumbers": "余额",
        "widgetDescNumbers": "显示一个数字：可用余额、净资产或本月最低点。",
        "widgetConfigMetric": "指标",
        "widgetConfigHorizon": "时间范围",
        "widgetSiriAddTransaction": "在 {appName} 中添加交易",
        "widgetSiriAddPlanned": "在 {appName} 中添加计划交易",
        "settingsWidgetAmountsTitle": "在小组件中显示金额",
        "settingsWidgetAmountsSubtitle": "主屏幕小组件无需解锁应用即可查看。启用应用锁时，除非开启此项，否则金额将保持隐藏。",
    },
    "sr_Latn": {
        "widgetLowestPoint": "Najniža tačka",
        "widgetProjected": "Projekcija",
        "widgetHorizonIn7Days": "Za 7 dana",
        "widgetHorizonEndOfMonth": "Kraj meseca",
        "widgetMetricAccount": "Stanje računa",
        "widgetQuickAdd": "Brzi unos",
        "widgetStale": "Možda nije ažurno",
        "widgetOpenToStart": "Otvorite Platrare da dodate račune",
        "widgetDueToday": "Dospeva danas",
        "widgetDescQuickAdd": "Dodajte transakciju ili plan jednim dodirom.",
        "widgetNameNumbers": "Stanje",
        "widgetDescNumbers": "Prikažite jedan broj: raspoloživo, neto vrednost ili najnižu tačku ovog meseca.",
        "widgetConfigMetric": "Pokazatelj",
        "widgetConfigHorizon": "Horizont",
        "widgetSiriAddTransaction": "Dodaj transakciju u {appName}",
        "widgetSiriAddPlanned": "Dodaj planiranu transakciju u {appName}",
        "settingsWidgetAmountsTitle": "Prikaži iznose u vidžetima",
        "settingsWidgetAmountsSubtitle": "Vidžeti na početnom ekranu vide se bez otključavanja aplikacije. Dok je zaključavanje uključeno, iznosi ostaju sakriveni osim ako ovo ne uključite.",
    },
    "hr": {
        "widgetLowestPoint": "Najniža točka",
        "widgetProjected": "Projekcija",
        "widgetHorizonIn7Days": "Za 7 dana",
        "widgetHorizonEndOfMonth": "Kraj mjeseca",
        "widgetMetricAccount": "Stanje računa",
        "widgetQuickAdd": "Brzi unos",
        "widgetStale": "Možda nije ažurno",
        "widgetOpenToStart": "Otvorite Platrare da dodate račune",
        "widgetDueToday": "Dospijeva danas",
        "widgetDescQuickAdd": "Dodajte transakciju ili plan jednim dodirom.",
        "widgetNameNumbers": "Stanje",
        "widgetDescNumbers": "Prikažite jedan broj: raspoloživo, neto vrijednost ili najnižu točku ovog mjeseca.",
        "widgetConfigMetric": "Pokazatelj",
        "widgetConfigHorizon": "Horizont",
        "widgetSiriAddTransaction": "Dodaj transakciju u {appName}",
        "widgetSiriAddPlanned": "Dodaj planiranu transakciju u {appName}",
        "settingsWidgetAmountsTitle": "Prikaži iznose u widgetima",
        "settingsWidgetAmountsSubtitle": "Widgeti na početnom zaslonu vidljivi su bez otključavanja aplikacije. Dok je zaključavanje uključeno, iznosi ostaju skriveni osim ako ovo ne uključite.",
    },
    "bs": {
        "widgetLowestPoint": "Najniža tačka",
        "widgetProjected": "Projekcija",
        "widgetHorizonIn7Days": "Za 7 dana",
        "widgetHorizonEndOfMonth": "Kraj mjeseca",
        "widgetMetricAccount": "Stanje računa",
        "widgetQuickAdd": "Brzi unos",
        "widgetStale": "Možda nije ažurno",
        "widgetOpenToStart": "Otvorite Platrare da dodate račune",
        "widgetDueToday": "Dospijeva danas",
        "widgetDescQuickAdd": "Dodajte transakciju ili plan jednim dodirom.",
        "widgetNameNumbers": "Stanje",
        "widgetDescNumbers": "Prikažite jedan broj: raspoloživo, neto vrijednost ili najnižu tačku ovog mjeseca.",
        "widgetConfigMetric": "Pokazatelj",
        "widgetConfigHorizon": "Horizont",
        "widgetSiriAddTransaction": "Dodaj transakciju u {appName}",
        "widgetSiriAddPlanned": "Dodaj planiranu transakciju u {appName}",
        "settingsWidgetAmountsTitle": "Prikaži iznose u widgetima",
        "settingsWidgetAmountsSubtitle": "Widgeti na početnom ekranu vidljivi su bez otključavanja aplikacije. Dok je zaključavanje uključeno, iznosi ostaju skriveni osim ako ovo ne uključite.",
    },
}

# Serbian Cyrillic is transliterated from the Latin variant, matching the
# existing generate_l10n_arbs.py workflow.
_LAT2CYR = [
    ("Nj", "Њ"), ("NJ", "Њ"), ("nj", "њ"), ("Lj", "Љ"), ("LJ", "Љ"), ("lj", "љ"),
    ("Dž", "Џ"), ("DŽ", "Џ"), ("dž", "џ"),
    ("A", "А"), ("B", "Б"), ("V", "В"), ("G", "Г"), ("D", "Д"), ("Đ", "Ђ"),
    ("E", "Е"), ("Ž", "Ж"), ("Z", "З"), ("I", "И"), ("J", "Ј"), ("K", "К"),
    ("L", "Л"), ("M", "М"), ("N", "Н"), ("O", "О"), ("P", "П"), ("R", "Р"),
    ("S", "С"), ("T", "Т"), ("Ć", "Ћ"), ("U", "У"), ("F", "Ф"), ("H", "Х"),
    ("C", "Ц"), ("Č", "Ч"), ("Š", "Ш"),
    ("a", "а"), ("b", "б"), ("v", "в"), ("g", "г"), ("d", "д"), ("đ", "ђ"),
    ("e", "е"), ("ž", "ж"), ("z", "з"), ("i", "и"), ("j", "ј"), ("k", "к"),
    ("l", "л"), ("m", "м"), ("n", "н"), ("o", "о"), ("p", "п"), ("r", "р"),
    ("s", "с"), ("t", "т"), ("ć", "ћ"), ("u", "у"), ("f", "ф"), ("h", "х"),
    ("c", "ц"), ("č", "ч"), ("š", "ш"),
]


def to_cyrillic(text: str) -> str:
    # Protect ICU placeholders and the untranslated brand name.
    protected: list[str] = []

    def stash(m: str) -> str:
        protected.append(m)
        return f"\x00{len(protected) - 1}\x00"

    out = text
    for token in ("{appName}", "Platrare"):
        out = out.replace(token, stash(token))
    for lat, cyr in _LAT2CYR:
        out = out.replace(lat, cyr)
    for i, original in enumerate(protected):
        out = out.replace(f"\x00{i}\x00", original)
    return out


def main() -> None:
    T["zh"] = T["zh_Hans"]
    T["sr"] = T["sr_Latn"]
    T["sr_Cyrl"] = {k: to_cyrillic(v) for k, v in T["sr_Latn"].items()}

    keys = list(T["en"].keys())
    changed = 0

    for path in sorted(L10N.glob("app_*.arb")):
        raw = json.loads(path.read_text(encoding="utf-8"), object_pairs_hook=OrderedDict)
        locale = raw.get("@@locale")
        table = T.get(locale)
        if table is None:
            print(f"  !! no translations for {locale} ({path.name}) — skipped")
            continue

        out = OrderedDict()
        added_here = 0
        for k, v in raw.items():
            out[k] = v
            if k == ANCHOR:
                for nk in keys:
                    if nk in raw:
                        continue
                    out[nk] = table[nk]
                    if locale == "en":
                        meta: OrderedDict = OrderedDict()
                        if nk in DESCRIPTIONS:
                            meta["description"] = DESCRIPTIONS[nk]
                        if nk in PLACEHOLDERS:
                            meta["placeholders"] = PLACEHOLDERS[nk]
                        if meta:
                            out[f"@{nk}"] = meta
                    added_here += 1

        missing = [k for k in keys if k not in out]
        if missing:
            raise SystemExit(f"{path.name}: anchor '{ANCHOR}' not found; {missing} unplaced")

        if added_here:
            path.write_text(
                json.dumps(out, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
            )
            changed += 1
        print(f"  {path.name:22} {locale:8} +{added_here}")

    print(f"\n{changed} file(s) updated, {len(keys)} keys each.")


if __name__ == "__main__":
    main()
