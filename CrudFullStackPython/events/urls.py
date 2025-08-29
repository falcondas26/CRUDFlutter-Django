from django.urls import path
from .views import EventListCreateView

app_name = 'events'

urlpatterns = [
    # CRUD endpoints para marcas
    path('Event', EventListCreateView.as_view(), name='Event-list-create'),
    path('Event/<str:id>',  EventListCreateView.as_view(), name='Event-detail'),
]
