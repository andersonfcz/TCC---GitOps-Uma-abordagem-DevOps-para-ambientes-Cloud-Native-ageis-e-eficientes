from django.db import models

# Create your models here.
class Customer(models.Model):
    name = models.CharField(max_length=80)
    address = models.CharField(max_length=200, null=True)
    cpf = models.CharField(max_length=14)
    email = models.EmailField(max_length=120, null=True)
    phone = models.CharField(max_length=14, null=True)
    
    def __str__(self):
        return self.name
