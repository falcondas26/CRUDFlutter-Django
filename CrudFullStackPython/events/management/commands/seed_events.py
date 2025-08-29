from django.core.management.base import BaseCommand
from events.models import Event, Location
from faker import Faker
from datetime import timezone

fake = Faker("es_CO")

class Command(BaseCommand):
    help = "Genera eventos falsos para pruebas"

    def add_arguments(self, parser):
        parser.add_argument(
            '--total',
            type=int,
            default=50,
            help='Número de eventos falsos a crear (por defecto 50)',
        )

    def handle(self, *args, **kwargs):
        total = kwargs['total']

        for _ in range(total):
            # Primero creamos el evento
            event = Event.objects.create(
                titulo=fake.sentence(),
                descripcion=fake.text(),
                date=fake.date_time_this_year(tzinfo=timezone.utc),
            )

            # Luego creamos su ubicación asociada
            Location.objects.create(
                event=event,
                lat=fake.latitude(),
                lng=fake.longitude(),
                address=fake.address()
            )

        self.stdout.write(self.style.SUCCESS(f"✅ {total} eventos con ubicación creados con éxito"))