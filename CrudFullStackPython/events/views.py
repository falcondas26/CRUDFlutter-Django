from django.shortcuts import render
from rest_framework import generics, status, filters
from rest_framework.response import Response
from rest_framework.decorators import api_view
from django_filters.rest_framework import DjangoFilterBackend
from django.db.models import Q
from .models import Event
from .serializers import Eventserializer, EventCreateSerializer
from django.utils.dateparse import parse_date


class EventListCreateView(generics.ListCreateAPIView):
    queryset = Event.objects.all()
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['date']
    search_fields = [ 'titulo', 'descripcion', 'date']
    ordering_fields = ['date']
    ordering = ['date']
    
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return EventCreateSerializer
        return Eventserializer
    
    def get_queryset(self):
        queryset = Event.objects.all()
        from_date = self.request.query_params.get('from_date')
        to_date = self.request.query_params.get('to_date')

        # Parsear las fechas (convierte string YYYY-MM-DD a objeto date)
        if from_date:
            from_date = parse_date(from_date)
        if to_date:
            to_date = parse_date(to_date)

        # Aplicar filtros solo si el parseo fue exitoso
        if from_date and to_date:
            queryset = queryset.filter(date__date__range=[from_date, to_date])
        elif from_date:
            queryset = queryset.filter(date__date__gte=from_date)
        elif to_date:
            queryset = queryset.filter(date__date__lte=to_date)

        return queryset

    def list(self, request, *args, **kwargs):
        response = super().list(request, *args, **kwargs)
        data = response.data

        # Extraer datos de paginación y results
        pagination = {
            "count": data.get("count"),
            "next": data.get("next"),
            "previous": data.get("previous"),
        }
        events = data.get("results", [])

        # Construir nueva estructura
        return Response({
            "pagination": pagination,
            "events": events
        })
    
    def create(self, request, *args, **kwargs):

        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            Event = serializer.save()
            return Response(
                Eventserializer(Event).data,
                status=status.HTTP_201_CREATED
            )
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )

