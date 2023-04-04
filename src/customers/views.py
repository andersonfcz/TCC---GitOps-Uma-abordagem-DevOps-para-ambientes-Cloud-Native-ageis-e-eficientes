from django.shortcuts import get_object_or_404, render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from customers.models import Customer
from django.core import serializers
import json

@csrf_exempt
def customer_list(request):
    if request.method == 'GET':
        customers = Customer.objects.all()
        data = serializers.serialize('json', customers)
        return JsonResponse(json.loads(data), safe=False)

    elif request.method == 'POST':
        data = json.loads(request.body)
        name = data.get('name')
        if not name:
            return JsonResponse({'error': 'Name field is required'})

        address = data.get('address')
        email = data.get('email')
        phone = data.get('phone')
        cpf = data.get('cpf')
        
        customer = Customer(name=name, address=address, email=email, phone=phone, cpf=cpf)
        customer.save()

        return JsonResponse({'id': customer.id})

@csrf_exempt
def customer_detail(request, pk):
    customer = get_object_or_404(Customer, pk=pk)

    if request.method == 'GET':
        data = serializers.serialize('json', [customer])
        return JsonResponse(json.loads(data)[0], safe=False)

    elif request.method == 'PUT':
        data = json.loads(request.body)
        name = data.get('name', customer.name)
        address = data.get('address', customer.address)
        email = data.get('email', customer.email)
        phone = data.get('phone', customer.phone)
        cpf = data.get('cpf', customer.cpf)

        customer.name = name
        customer.address = address
        customer.email = email
        customer.phone = phone
        customer.cpf = cpf
        customer.save()

        return JsonResponse({'id': customer.id})

    elif request.method == 'DELETE':
        customer.delete()
        return JsonResponse({'result': True})