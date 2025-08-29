from django.contrib import admin
from .models import Event, Location

class LocationInline(admin.StackedInline):  # También puedes usar TabularInline
    model = Location
    extra = 1 


@admin.register(Event)
class EventAdmin(admin.ModelAdmin):
    """
    Configuración del admin para el modelo Event
    """
    list_display = ['titulo', 'descripcion', 'date']
    list_filter = ['date']
    search_fields = ['titulo', 'descripcion', 'date']
    list_editable = ['date']
    ordering = ['-date']

    fieldsets = (
        ('Información del evento', {
            'fields': ('titulo', 'descripcion', 'date')
        }),
    )

    inlines = [LocationInline]  
    
    def get_queryset(self, request):
        """
        Optimizar consultas del admin
        """
        return super().get_queryset(request).select_related()
