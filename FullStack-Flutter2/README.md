# Events App - Módulo de Eventos

Una aplicación Flutter completa para el módulo de eventos de una app social. Los usuarios pueden consultar eventos, ver detalles y filtrar por fechas.

## 🚀 Características

- **Lista de eventos paginada** con scroll infinito
- **Vista de detalle** completa de cada evento
- **Filtros por fecha** (desde/hasta)
- **Integración con mapas** para ubicaciones
- **Arquitectura escalable** preparada para backend real
- **Manejo de estado** con Provider
- **Backend simulado** con datos JSON locales

## 🏗️ Arquitectura

El proyecto sigue una arquitectura limpia con separación clara de responsabilidades:

```
lib/
├── models/          # Modelos de datos (Event, Location, etc.)
├── services/        # Servicios para API/datos 
├── providers/       # Manejo de estado con Provider
├── screens/         # Pantallas de la aplicación
├── widgets/         # Widgets reutilizables
└── utils/           # Utilidades (formateo, helpers)
```

## 📱 Pantallas

### Lista de Eventos
- Visualización de eventos en cards atractivos
- Paginación automática con scroll infinito
- Pull-to-refresh para actualizar
- Filtros por rango de fechas
- Indicadores de estado (cargando, error, vacío)

### Detalle de Evento
- Información completa del evento
- Integración con mapas para ver ubicación
- Diseño atractivo con scroll personalizado
- Botón de registro (preparado para funcionalidad futura)

## 🛠️ Configuración y Ejecución

### Prerrequisitos
- Flutter SDK (versión 3.9.0 o superior)
- Dart SDK
- Android Studio / VS Code
- Dispositivo Android/iOS o emulador

### Instalación

1. **Clonar el proyecto**
```bash
git clone <repository-url>
cd FullStack-Flutter2
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Ejecutar la aplicación**
```bash
flutter run
```

### Desarrollo
```bash
# Ejecutar en modo debug
flutter run --debug

# Ejecutar tests
flutter test

# Análisis de código
flutter analyze

# Construcción para release
flutter build apk --release
```

## 📦 Dependencias Principales

- **provider**: Manejo de estado
- **http**: Cliente HTTP (preparado para backend real)
- **intl**: Formateo de fechas y números
- **url_launcher**: Abrir URLs/mapas
- **flutter_spinkit**: Indicadores de carga

## 🔌 Integración con Backend

El proyecto está preparado para integrarse fácilmente con un backend real:

### Endpoints Esperados
```
GET /events?page=1&size=10&from=2025-08-01&to=2025-08-31
GET /events/{id}
```

### Configuración
En `lib/services/events_service.dart` descomenta las funciones marcadas para usar el backend real y actualiza la URL base:

```dart
static const String baseUrl = 'https://tu-api.com';
```

## 🎨 Diseño

- **Material Design 3** con colores personalizados
- **Tema consistente** en toda la aplicación
- **Responsivo** y adaptable a diferentes tamaños
- **Animaciones fluidas** y transiciones suaves

## 🧪 Testing

El proyecto incluye tests básicos que se pueden expandir:

```bash
flutter test
```

## 📊 Datos de Prueba

El archivo `assets/data/events_mock.json` contiene 10 eventos de ejemplo con diferentes categorías:
- Música
- Gastronomía  
- Tecnología
- Arte
- Deportes
- Cine
- Educación
- Literatura

## 🔄 Estado de la Aplicación

La aplicación maneja correctamente todos los estados:
- **Carga inicial**
- **Paginación**
- **Estados de error**
- **Estados vacíos**
- **Refresh/actualización**

## 🚀 Próximas Funcionalidades

- Registro a eventos
- Favoritos
- Notificaciones push
- Compartir eventos
- Categorías dinámicas
- Búsqueda por texto
- Modo offline

## 🐛 Troubleshooting

### Problemas Comunes

1. **Error de dependencias**
```bash
flutter clean
flutter pub get
```

2. **Problemas de compilación**
```bash
flutter clean
flutter pub deps
flutter run
```

3. **Emulador no detectado**
```bash
flutter devices
flutter emulators --launch <emulator_id>
```

## 👥 Contribución

1. Fork del proyecto
2. Crear rama para feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit de cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crear Pull Request

## 📄 Licencia

Este proyecto es parte de un desafío técnico para Overthere.

## 📞 Contacto

Para preguntas sobre el proyecto, contactar al equipo de desarrollo.

---

**Nota**: Este es el frontend del módulo de eventos. El backend está en desarrollo separado siguiendo las especificaciones del desafío técnico.
