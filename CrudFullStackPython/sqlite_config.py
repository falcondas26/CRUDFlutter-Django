# Configuración temporal de SQLite para desarrollo/testing
# Descomenta estas líneas en settings.py si no tienes PostgreSQL configurado

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

# Comentar la configuración de PostgreSQL temporalmente
