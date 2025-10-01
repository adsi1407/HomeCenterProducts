# Home Center Products — Español

Resumen
-------
Este repositorio contiene una aplicación Flutter pequeña implementada como una prueba técnica. Aunque la tarea es sencilla, la solución fue desarrollada aplicando Clean Architecture para mostrar buenas prácticas de ingeniería y facilitar la mantenibilidad.

Versión de Flutter y requisitos
------------------------------
- Canal: stable
- Versión probada: Flutter 3.32.x y Dart 3.8.x (ver `pubspec.yaml`)
- Requisitos para abrir y ejecutar:
  - Flutter SDK instalado y en PATH
  - SDK de Android (o Xcode para iOS)
  - Ejecutar `flutter pub get` desde la raíz del repositorio

Cómo ejecutar
-------------
1. flutter pub get
2. flutter run

Requerimientos iniciales del reto
--------------------------------
- Buscar productos y una pantalla de carrito con añadir/eliminar
- Implementar infinite scroll en la lista de productos
- Agregar pruebas y comprobar cobertura en CI por módulo

Por qué Clean Architecture
--------------------------
Se aplicó Clean Architecture para separar responsabilidades y mostrar:
- Capas independientes (domain, infrastructure, presentation)
- Casos de uso y entidades desacopladas de frameworks
- Código testeable y con buena mantenibilidad

Modularización por paquetes
---------------------------
La base de código está modularizada para limitar librerías por paquete:
- `module/domain` – entidades de dominio, interfaces de repositorio y casos de uso
- `module/infrastructure` – implementaciones, API, cache, BD y DAOs
- App raíz – capa de presentación, composición DI y wiring

Patrones de diseño implementados
--------------------------------
- BLoC (flutter_bloc) para gestión de estado
- Inyección de dependencias con `get_it` + `injectable`
- Patrón Repository para abstracción de fuentes de datos
- Traductores/mappers para transformar DTOs <-> entidades de dominio
- Proxy para capas de cache/API
- DAO (Drift) para persistencia local

Principios SOLID
----------------
Se respetaron principios SOLID: responsabilidad única, inversión de dependencias y otros para mantener el código limpio.

Mejoras de rendimiento en widgets
---------------------------------
- Uso de constructores const cuando es posible
- Widgets pequeños para reducir áreas de rebuild
- `cached_network_image` para imágenes remotas
- Evitar trabajo pesado en `build` y mover cálculos costosos fuera del árbol de widgets

Pruebas realizadas
------------------
- Unit tests: dominio y casos de uso
- Widget tests: renderizado, interacciones y semántica
- Integration tests: flujos end-to-end
- Golden tests: baselines de UI para detectar regresiones
- Accessibility tests: validación de labels y semántica

Buenas prácticas en pruebas
--------------------------
- Patrón Triple-A (Arrange-Act-Assert) y principios FIRST aplicados en pruebas unitarias
- Uso de mocks y fakes para aislar unidades bajo prueba
- Inclusión de `localizationsDelegates` en tests para aserciones robustas ante locales

Buenas prácticas de código
-------------------------
- Nombres claros para archivos, clases y tests
- Widgets pequeños y estilos reutilizables
- Análisis estático (linting) con `very_good_analysis` recomendado

Localización
------------
- Strings localizadas con `gen_l10n` (archivos ARB en `lib/l10n`) y uso de clases generadas.

Pipeline de CI
-------------
- GitHub Actions configurado para ejecutar pruebas, análisis y comprobar cobertura por módulo.
- Scripts custom en `tool/ci/` para validar cobertura y análisis.
