from rest_framework import serializers
from .models import Event, Location


class LocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Location
        fields = ['lat', 'lng', 'address']

class Eventserializer(serializers.ModelSerializer):
    
    location = LocationSerializer(read_only=True)

    class Meta:
        model = Event
        fields = [
            'id',
            'titulo', 
            'descripcion',
            'date',
            'location'
        ]
        read_only_fields = ['id']
    
    def validate_titulo(self, value):
        """
        Validar que el titular no esté vacío y tenga longitud mínima
        """
        if not value or not value.strip():
            raise serializers.ValidationError("El titulo es requerido")
            
        if len(value.strip()) < 2:
            raise serializers.ValidationError("El titulo debe tener al menos 2 caracteres")
            
        return value.strip()
    




class EventCreateSerializer(Eventserializer):
    """
    Serializer específico para crear marcas
    """
    
    def create(self, validated_data):
        """
        Crear una nueva marca
        """
        return Event.objects.create(**validated_data)

