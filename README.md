# 📌 CRUDFlutter-Django
Prueba técnica de CRUD simple usando **Flutter** (frontend) y **Django** (backend).  

## 🚀 Levantar el proyecto con Docker
El proyecto ya incluye **Dockerfiles** tanto para el backend como para el frontend, y todo el proceso está automatizado (incluyendo la creación de la instancia de **PostgreSQL**).

Desde la carpeta raíz del proyecto ejecute:

```bash
docker-compose up --build
```

⏳ El tiempo de espera dependerá de la capacidad de tu equipo. Este comando levantará **3 contenedores** y poblará la base de datos con **10,000 registros de prueba**.  

## ⚙️ Levantar el proyecto en local (sin Docker)

### 🔹 Backend (Django)
Clone el repositorio y acceda a la carpeta del backend. Cree y active un entorno virtual:

```bash
python -m venv venv
```

- En Linux/Mac:
  ```bash
  source venv/bin/activate
  ```
- En Windows:
  ```bash
  ./venv/Scripts/activate
  ```

Instale las dependencias:

```bash
pip install -r requirements.txt
```

Cree la base de datos en PostgreSQL con el nombre **calendar** en el puerto `5432`. Puede crearla vacía, las migraciones la poblarán. Luego ejecute:

```bash
python manage.py makemigrations
python manage.py migrate
```

Para poblar la base de datos con 10,000 registros de prueba:

```bash
python manage.py seed_events --total 10000
```

Con esto el backend ya debería estar funcionando.  

### 🔹 Frontend (Flutter)
Acceda a la carpeta raíz del frontend. Asegúrese de tener instalada la última versión de Flutter:

```bash
flutter doctor
```

Instale las dependencias:

```bash
flutter pub get
```

Ejecute la aplicación:

```bash
flutter run
```

Ahora la aplicación debería estar corriendo y conectada al backend. 
