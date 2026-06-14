# Vilas Magazine

Aplicativo Flutter oficial da Vilas Magazine, com notícias reais via WordPress REST API, fallback RSS, revista digital, guia local e tela institucional.

## Requisitos

- Flutter 3.44.0 ou superior
- Dart 3.12.0 ou superior
- Android Studio/Xcode configurados para o alvo escolhido

## Como rodar

~~~powershell
flutter pub get
flutter run
~~~

## Validação

~~~powershell
flutter analyze
flutter test
~~~

## Firebase

Projeto: `vilasmagazine-oficial`

Apps configurados:

- Android: `com.salles.vilasmagazine`
- iOS: `com.salles.vilasmagazine`
- Web: `Vilas Magazine`

Deploy web:

~~~powershell
flutter build web
firebase deploy --only hosting
~~~

## Dados

- Notícias: `https://vilasmagazine.com.br/wp-json/wp/v2/posts?_embed=true`
- Categorias: `https://vilasmagazine.com.br/wp-json/wp/v2/categories`
- RSS fallback: `https://vilasmagazine.com.br/feed/`
- Guia Local: `assets/data/guia_local.json`
