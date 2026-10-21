<#
.SYNOPSIS
    Randevu Platformu Feature & Scaffold Oluşturucu (generate_feature.ps1)
.DESCRIPTION
    Çok Sektörlü Teklif Usulü Randevu Platformu için model, provider, view ve widget iskeletlerini oluşturur.
.EXAMPLE
    .\generate_feature.ps1 appointment
    .\generate_feature.ps1 -ScaffoldAll
#>

[CmdletBinding()]
param (
    [Parameter(Position = 0, Mandatory = $false)]
    [string]$FeatureName,

    [switch]$ScaffoldAll
)

$ErrorActionPreference = "Stop"

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "   Randevu Platformu Feature & Scaffold Oluşturucu  " -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

function Find-ProjectRoot {
    $current = (Get-Location).Path
    while ($current -and (Test-Path $current)) {
        if (Test-Path (Join-Path $current "lib")) {
            return $current
        }
        if (Test-Path (Join-Path $current "21-EKIM\lib")) {
            return (Join-Path $current "21-EKIM")
        }
        $parent = Split-Path -Parent $current
        if ($parent -eq $current) { break }
        $current = $parent
    }
    if (Test-Path (Join-Path (Get-Location).Path "21-EKIM")) {
        return (Join-Path (Get-Location).Path "21-EKIM")
    }
    return (Get-Location).Path
}

$ProjectRoot = Find-ProjectRoot
Write-Host "Proje Çalışma Dizini: $ProjectRoot" -ForegroundColor Green

if ($ScaffoldAll -or $FeatureName -eq "all" -or $FeatureName -eq "--scaffold-all") {
    Write-Host "Proje temel klasör yapısı ve yerel JSON veri setleri kuruluyor..." -ForegroundColor Yellow
    
    $dirs = @(
        "assets/data", "assets/images",
        "lib/core/constants", "lib/core/services", "lib/core/theme",
        "lib/models", "lib/providers",
        "lib/views/auth", "lib/views/customer", "lib/views/provider", "lib/views/shared/widgets",
        "test"
    )

    foreach ($d in $dirs) {
        $p = Join-Path $ProjectRoot $d
        if (!(Test-Path $p)) {
            New-Item -ItemType Directory -Path $p -Force | Out-Null
        }
    }

    Write-Host "Tüm klasör yapısı hazırlandı!" -ForegroundColor Green
    exit 0
}

if (-not $FeatureName) {
    $FeatureName = Read-Host "Oluşturulacak modül adını giriniz (örn: appointment, listing, chat)"
}

$FeatureName = $FeatureName.ToLower().Replace("-", "_")

function To-PascalCase([string]$text) {
    return ($text -split '_' | ForEach-Object { 
        if ($_.Length -gt 0) { 
            $_.Substring(0,1).ToUpper() + $_.Substring(1).ToLower() 
        } 
    }) -join ''
}

$PascalName = To-PascalCase $FeatureName

Write-Host "Modül Oluşturuluyor: $FeatureName ($PascalName)" -ForegroundColor Cyan

$modelDir = Join-Path $ProjectRoot "lib\models"
$providerDir = Join-Path $ProjectRoot "lib\providers"
$viewDir = Join-Path $ProjectRoot "lib\views\$FeatureName"
$widgetDir = Join-Path $ProjectRoot "lib\views\shared\widgets"

New-Item -ItemType Directory -Path $modelDir -Force | Out-Null
New-Item -ItemType Directory -Path $providerDir -Force | Out-Null
New-Item -ItemType Directory -Path $viewDir -Force | Out-Null
New-Item -ItemType Directory -Path $widgetDir -Force | Out-Null

$modelFile = Join-Path $modelDir "$($FeatureName)_model.dart"
if (!(Test-Path $modelFile)) {
@"
import 'package:flutter/foundation.dart';

@immutable
class ${PascalName}Model {
  final String id;
  final String title;
  final String status;
  final DateTime createdAt;

  const ${PascalName}Model({
    required this.id,
    required this.title,
    this.status = 'beklemede',
    required this.createdAt,
  });

  ${PascalName}Model copyWith({
    String? id,
    String? title,
    String? status,
    DateTime? createdAt,
  }) {
    return ${PascalName}Model(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ${PascalName}Model.fromJson(Map<String, dynamic> json) {
    return ${PascalName}Model(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? 'beklemede',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
"@ | Out-File -FilePath $modelFile -Encoding utf8
    Write-Host "✓ $modelFile oluşturuldu." -ForegroundColor Green
}

$providerFile = Join-Path $providerDir "$($FeatureName)_provider.dart"
if (!(Test-Path $providerFile)) {
@"
import 'package:flutter/material.dart';
import '../models/${FeatureName}_model.dart';

class ${PascalName}Provider extends ChangeNotifier {
  List<${PascalName}Model> _items = [];
  bool _isLoading = false;

  List<${PascalName}Model> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;

  void addItem(${PascalName}Model item) {
    _items = [item, ..._items];
    notifyListeners();
  }

  void updateStatus(String id, String newStatus) {
    _items = _items.map((item) {
      if (item.id == id) {
        return item.copyWith(status: newStatus);
      }
      return item;
    }).toList();
    notifyListeners();
  }
}
"@ | Out-File -FilePath $providerFile -Encoding utf8
    Write-Host "✓ $providerFile oluşturuldu." -ForegroundColor Green
}

Write-Host "Başarılı! Modül iskeleti hazır." -ForegroundColor Green
Write-Host "Doğrulama için: flutter analyze ve flutter test" -ForegroundColor Yellow
