from django.shortcuts import render
from rest_framework import viewsets

from encrypt.customers import models
from encrypt.customers import serializers
# Create your views here.

class CustomerViewSet(viewsets.ModelViewSet):
    """
    A viewset for viewing and editing user instances.
    """
    serializer_class = serializers.CustomerSerializer
    queryset = models.Customer.objects.all()

    def get_readable_queryset(self):
        return models.CustomerReadable.objects.all()

    def get_raw_queryset(self):
        return models.Customer.objects.all()

    def filter_queryset(self, queryset):
        first = self.request.query_params.get('first', None)
        if first:
            queryset = queryset.filter(first_name__contains=first)

        return queryset

    def list(self, request, *args, **kwargs):
        self.get_queryset = self.get_readable_queryset
        return super().list(request, *args, **kwargs)

    def retrieve(self, request, *args, **kwargs):
        self.get_queryset = self.get_readable_queryset
        return super().retrieve(request, *args, **kwargs)
