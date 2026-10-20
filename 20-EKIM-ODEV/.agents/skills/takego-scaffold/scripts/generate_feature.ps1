<#
.SYNOPSIS
    TakeGO Feature Scaffold Oluşturucu (PowerShell Sürümü)
.DESCRIPTION
    TakeGO araç kiralama projesi için feature bazlı klasör yapısını (controller, models, view, widget, test)
    ve ValueNotifier mimarisine uygun standart iskelet kodları otomatik olarak üretir.
.PARAMETER FeatureName
    Oluşturulacak modül adı (örn: car_listing, car_detail, create_listing, smart_key_assistant)
.EXAMPLE
    .\generate_feature.ps1 car_listing
#>

param (
    [Parameter(Position=0, Mandatory=$false)]
    [string]$FeatureName
)

$Host.UI.RawUI.ForegroundColor = "Cyan"
Write-Host "===================================================="
Write-Host "       TakeGO Feature İskelet Oluşturucu (PS)       "
Write-Host "===================================================="
$Host.UI.RawUI.ForegroundColor = "Gray"

if ([string]::IsNullOrWhiteSpace($FeatureName)) {
    Write-Host "Bir modül adı belirtilmedi." -ForegroundColor Yellow
    $FeatureName = Read-Host "Oluşturulacak modül adını giriniz (örn: car_listing)"
}

$FeatureName = $FeatureName.ToLower().Trim().Replace("-", "_")

if ($FeatureName -notmatch "^[a-z0-9_]+$") {
    Write-Host "HATA: Modül adı yalnızca küçük harf, rakam ve alt çizgi (_) içerebilir." -ForegroundColor Red
    exit 1
}

$textInfo = (Get-Culture).TextInfo
$pascalParts = $FeatureName.Split('_') | ForEach-Object { $textInfo.ToTitleCase($_) }
$PascalName = $pascalParts -join ""

function Get-ProjectRoot {
    $cur = Get-Location
    while ($cur -and $cur.Path -ne $cur.Root.Path) {
        if (Test-Path (Join-Path $cur.Path "lib")) {
            return $cur.Path
        }
        if (Test-Path (Join-Path $cur.Path "20-EKIM-ODEV\lib")) {
            return (Join-Path $cur.Path "20-EKIM-ODEV")
        }
        $parent = Split-Path $cur.Path -Parent
        if ($parent -eq $cur.Path) { break }
        $cur = Get-Item $parent
    }
    return (Get-Location).Path
}

$ProjectRoot = Get-ProjectRoot
$FeatureDir = Join-Path $ProjectRoot "lib\features\$FeatureName"
$TestDir = Join-Path $ProjectRoot "test\features\$FeatureName"

Write-Host "Hedef Proje Dizini: $ProjectRoot"
Write-Host "Modül Adı:         $FeatureName ($PascalName)" -ForegroundColor Green
Write-Host ""

New-Item -ItemType Directory -Force -Path (Join-Path $FeatureDir "controller") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $FeatureDir "models") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $FeatureDir "view") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $FeatureDir "widget") | Out-Null
New-Item -ItemType Directory -Force -Path $TestDir | Out-Null

# 1. CONTROLLER
$ControllerFile = Join-Path $FeatureDir "controller\${FeatureName}_controller.dart"
if (-not (Test-Path $ControllerFile)) {
    $controllerContent = @"
import 'package:flutter/foundation.dart';
import '../models/${FeatureName}_model.dart';

/// TakeGO Standart ${PascalName}Controller
///
/// Durum yönetimi saf [ValueNotifier] ile sağlanır.
/// Sayfa kapandığında mutlaka [dispose] çağrılmalıdır.
class ${PascalName}Controller {
  /// Yükleme durumu
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  /// Hata veya bilgilendirme mesajı
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  /// Ana veri listesi bildiricisi
  final ValueNotifier<List<${PascalName}Model>> itemsNotifier =
      ValueNotifier<List<${PascalName}Model>>([]);

  /// İlk verileri yükle
  Future<void> loadInitialData() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      itemsNotifier.value = [
        ${PascalName}Model(
          id: 'item-1',
          title: 'TakeGO Örnek Kayıt',
          createdAt: DateTime.now(),
        ),
      ];
    } catch (e) {
      errorMessage.value = 'Veri yüklenirken hata oluştu: `$e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Yeni kayıt ekle
  void addItem(${PascalName}Model item) {
    itemsNotifier.value = [item, ...itemsNotifier.value];
  }

  /// Bellek sızıntılarını önlemek için dinleyicileri serbest bırak
  void dispose() {
    isLoading.dispose();
    errorMessage.dispose();
    itemsNotifier.dispose();
  }
}
"@
    Set-Content -Path $ControllerFile -Value $controllerContent -Encoding UTF8
    Write-Host "  [+] Oluşturuldu: $ControllerFile" -ForegroundColor Green
} else {
    Write-Host "  [.] Zaten mevcut: $ControllerFile" -ForegroundColor Yellow
}

# 2. MODEL
$ModelFile = Join-Path $FeatureDir "models\${FeatureName}_model.dart"
if (-not (Test-Path $ModelFile)) {
    $modelContent = @"
import 'package:flutter/foundation.dart';

/// TakeGO Standart Değişmez (Immutable) ${PascalName}Model
@immutable
class ${PascalName}Model {
  final String id;
  final String title;
  final DateTime createdAt;

  const ${PascalName}Model({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  ${PascalName}Model copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
  }) {
    return ${PascalName}Model(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ${PascalName}Model.fromJson(Map<String, dynamic> json) {
    return ${PascalName}Model(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ${PascalName}Model &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
"@
    Set-Content -Path $ModelFile -Value $modelContent -Encoding UTF8
    Write-Host "  [+] Oluşturuldu: $ModelFile" -ForegroundColor Green
} else {
    Write-Host "  [.] Zaten mevcut: $ModelFile" -ForegroundColor Yellow
}

# 3. WIDGET
$WidgetFile = Join-Path $FeatureDir "widget\${FeatureName}_card.dart"
if (-not (Test-Path $WidgetFile)) {
    $widgetContent = @"
import 'package:flutter/material.dart';
import '../models/${FeatureName}_model.dart';

/// TakeGO Sabit Görsel Oranlı ${PascalName}Card
///
/// Kırmızı Çizgi Kuralı: İlan kartlarında 16:9 sabit görsel oranı korunmalı,
/// taşmaları önlemek için AspectRatio(16/9) veya sabit yükseklik kullanılmalıdır.
class ${PascalName}Card extends StatelessWidget {
  final ${PascalName}Model item;
  final VoidCallback? onTap;

  const ${PascalName}Card({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SABİT 16:9 GÖRSEL ALANI
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: colors.surfaceContainerHighest,
                child: Center(
                  child: Icon(
                    Icons.directions_car_filled_outlined,
                    size: 48,
                    color: colors.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Kayıt: `\${item.createdAt.day}.`\${item.createdAt.month}.`\${item.createdAt.year}',
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
"@
    Set-Content -Path $WidgetFile -Value $widgetContent -Encoding UTF8
    Write-Host "  [+] Oluşturuldu: $WidgetFile" -ForegroundColor Green
} else {
    Write-Host "  [.] Zaten mevcut: $WidgetFile" -ForegroundColor Yellow
}

# 4. VIEW
$ViewFile = Join-Path $FeatureDir "view\${FeatureName}_view.dart"
if (-not (Test-Path $ViewFile)) {
    $viewContent = @"
import 'package:flutter/material.dart';
import '../controller/${FeatureName}_controller.dart';
import '../models/${FeatureName}_model.dart';
import '../widget/${FeatureName}_card.dart';

/// TakeGO ${PascalName}View
///
/// [StatelessWidget] ve [ValueListenableBuilder] mimarisi ile
/// sadece durumun değiştiği arayüz bileşenleri yeniden çizilir.
class ${PascalName}View extends StatelessWidget {
  final ${PascalName}Controller controller;

  const ${PascalName}View({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TakeGO - ${PascalName}'),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: controller.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ValueListenableBuilder<List<${PascalName}Model>>(
            valueListenable: controller.itemsNotifier,
            builder: (context, items, _) {
              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'Henüz kayıt bulunmuyor.',
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                );
              }

              return ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) {
                  return ${PascalName}Card(item: items[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}
"@
    Set-Content -Path $ViewFile -Value $viewContent -Encoding UTF8
    Write-Host "  [+] Oluşturuldu: $ViewFile" -ForegroundColor Green
} else {
    Write-Host "  [.] Zaten mevcut: $ViewFile" -ForegroundColor Yellow
}

# 5. TEST
$TestFile = Join-Path $TestDir "${FeatureName}_test.dart"
if (-not (Test-Path $TestFile)) {
    $testContent = @"
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/features/${FeatureName}/controller/${FeatureName}_controller.dart';
import '../../../lib/features/${FeatureName}/models/${FeatureName}_model.dart';
import '../../../lib/features/${FeatureName}/view/${FeatureName}_view.dart';
import '../../../lib/features/${FeatureName}/widget/${FeatureName}_card.dart';

void main() {
  group('${PascalName} Unit & State Tests', () {
    late ${PascalName}Controller controller;

    setUp(() {
      controller = ${PascalName}Controller();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç durumları doğru tanımlanmalıdır', () {
      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isNull);
      expect(controller.itemsNotifier.value, isEmpty);
    });

    test('loadInitialData sonrası veri listesi güncellenmelidir', () async {
      await controller.loadInitialData();
      expect(controller.itemsNotifier.value.isNotEmpty, isTrue);
      expect(controller.isLoading.value, isFalse);
    });

    test('addItem yeni kaydı listenin başına eklemelidir', () {
      final newItem = ${PascalName}Model(
        id: 'test-123',
        title: 'Birim Test Kaydı',
        createdAt: DateTime.now(),
      );
      controller.addItem(newItem);
      expect(controller.itemsNotifier.value.first.id, equals('test-123'));
    });
  });

  group('${PascalName} Widget Tests', () {
    late ${PascalName}Controller controller;

    setUp(() {
      controller = ${PascalName}Controller();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('View bileşeni hatasız çizilmelidir', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ${PascalName}View(controller: controller),
        ),
      );

      expect(find.text('TakeGO - ${PascalName}'), findsOneWidget);
    });

    testWidgets('Sabit oranlı 16:9 kart bileşeni taşma yapmadan çizilmelidir', (tester) async {
      final testItem = ${PascalName}Model(
        id: 'card-1',
        title: 'Sabit Görsel Testi',
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ${PascalName}Card(item: testItem),
          ),
        ),
      );

      expect(find.text('Sabit Görsel Testi'), findsOneWidget);
      expect(find.byType(AspectRatio), findsOneWidget);
    });
  });
}
"@
    Set-Content -Path $TestFile -Value $testContent -Encoding UTF8
    Write-Host "  [+] Oluşturuldu: $TestFile" -ForegroundColor Green
} else {
    Write-Host "  [.] Zaten mevcut: $TestFile" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✔ '$FeatureName' modülü başarıyla oluşturuldu!" -ForegroundColor Green
Write-Host "Çalıştırılacak doğrulama komutları:"
Write-Host "  flutter analyze" -ForegroundColor Cyan
Write-Host "  flutter test $TestFile" -ForegroundColor Cyan
Write-Host "===================================================="
