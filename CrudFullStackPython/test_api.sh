#!/bin/bash

echo "=== Probando API de Marcas ==="
echo

# Base URL
BASE_URL="http://127.0.0.1:8000/api"

echo "1. Probando GET /Event (listar marcas vacías):"
timeout 5s curl -s -X GET "$BASE_URL/Event" | head -c 200
echo -e "\n"

echo "2. Creando primera marca (Nike):"
timeout 5s curl -s -X POST "$BASE_URL/Event" \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Nike",
    "titular": "Nike Inc.",
    "descripcion": "Marca deportiva internacional",
    "estado": "pendiente"
  }' | head -c 200
echo -e "\n"

echo "3. Creando segunda marca (Adidas):"
timeout 5s curl -s -X POST "$BASE_URL/Event" \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Adidas", 
    "titular": "Adidas AG",
    "descripcion": "Marca alemana de artículos deportivos",
    "estado": "en_progreso"
  }' | head -c 200
echo -e "\n"

echo "4. Listando todas las marcas:"
timeout 5s curl -s -X GET "$BASE_URL/Event" | head -c 300
echo -e "\n"

echo "5. Obteniendo marca específica (ID: 1):"
timeout 5s curl -s -X GET "$BASE_URL/Event/1" | head -c 200
echo -e "\n"

echo "6. Actualizando marca (ID: 1):"
timeout 5s curl -s -X PUT "$BASE_URL/Event/1" \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Nike Updated",
    "titular": "Nike Inc.",
    "descripcion": "Marca deportiva internacional actualizada", 
    "estado": "completada"
  }' | head -c 200
echo -e "\n"

echo "7. Probando filtro por estado:"
timeout 5s curl -s -X GET "$BASE_URL/Event?estado=completada" | head -c 200
echo -e "\n"

echo "8. Estadísticas de marcas:"
timeout 5s curl -s -X GET "$BASE_URL/Event/stats" | head -c 200
echo -e "\n"

echo "=== Pruebas completadas ==="
