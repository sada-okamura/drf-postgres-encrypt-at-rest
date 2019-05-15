from rest_framework import serializers

from encrypt.customers import models

class CustomerSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Customer
        fields = ('id', 'first_name', 'last_name')
