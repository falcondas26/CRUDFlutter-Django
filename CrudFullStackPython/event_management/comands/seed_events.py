from django.core.management.base import BaseCommand
from faker import Faker
from events.models import events # 👈 ajusta el nombre de la app si no es "events"
from django.utils import timezone


class Command(BaseCommand):
    help = "Seed the database with fake events"

    def add_arguments(self, parser):
        parser.add_argument("--total", type=int, default=1000)

    def handle(self, *args, **kwargs):
        total = kwargs["total"]
        fake = Faker()

        for _ in range(total):
            Event.objects.create(
                titulo=fake.sentence(),
                descripcion=fake.text(),
                date=fake.date_time_between(
                    start_date="-1y",
                    end_date="now",
                    tzinfo=timezone.utc
                ),
                location={
                    "lat": str(fake.latitude()),
                    "lng": str(fake.longitude()),
                    "address": fake.address(),
                }
            )

        self.stdout.write(self.style.SUCCESS(f"✅ {total} eventos creados"))