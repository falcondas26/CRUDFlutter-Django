from django.db import models
from django.core.exceptions import ValidationError


class Event(models.Model):
    
    titulo = models.CharField(
        max_length=255,
        help_text="Titulo del evento"
    )
    
    descripcion = models.TextField(
        blank=True,
        null=True,
        help_text="Descripción del evento"
    )
    
    # Campos de auditoría
    date = models.DateTimeField(
        help_text="Fecha y hora asociada al evento"
    )
    
    class Meta:
        verbose_name = "Evento"
        verbose_name_plural = "Eventos"
        ordering = ['-date']
        
    def __str__(self):
        return f"{self.titulo}"
    
    def clean(self):
        """
        Validaciones personalizadas del modelo
        """
            
        if self.titulo:
            self.titulo = self.titulo.strip()
            
            
        if len(self.titulo) < 2:
            raise ValidationError("El titulo debe tener al menos 2 caracteres")
    
    def save(self, *args, **kwargs):
        self.full_clean()
        super().save(*args, **kwargs)

class Location(models.Model):
    event = models.OneToOneField(  # Un evento tiene una única ubicación
        Event,
        on_delete=models.CASCADE,
        related_name="location"
    )
    lat = models.DecimalField(max_digits=9, decimal_places=6)
    lng = models.DecimalField(max_digits=9, decimal_places=6)
    address = models.CharField(max_length=255)

    def __str__(self):
        return f"{self.address} ({self.lat}, {self.lng})"
