from django.shortcuts import get_object_or_404, render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from suppliers.models import Supplier
from django.core import serializers
import json

@csrf_exempt
def supplier_list(request):
    if request.method == 'GET':
        suppliers = Supplier.objects.all()
        data = serializers.serialize('json', suppliers)
        return JsonResponse(json.loads(data), safe=False)

    elif request.method == 'POST':
        data = json.loads(request.body)
        name = data.get('name')
        if not name:
            return JsonResponse({'error': 'Name field is required'})

        address = data.get('address')
        email = data.get('email')
        phone = data.get('phone')
        cnpj = data.get('cnpj')
        
        supplier = Supplier(name=name, address=address, email=email, phone=phone, cnpj=cnpj)
        supplier.save()

        return JsonResponse({'id': supplier.id})

@csrf_exempt
def supplier_detail(request, pk):
    supplier = get_object_or_404(supplier, pk=pk)

    if request.method == 'GET':
        data = serializers.serialize('json', [supplier])
        return JsonResponse(json.loads(data)[0], safe=False)

    elif request.method == 'PUT':
        data = json.loads(request.body)
        name = data.get('name', supplier.name)
        address = data.get('address', supplier.address)
        email = data.get('email', supplier.email)
        phone = data.get('phone', supplier.phone)
        cnpj = data.get('cnpj', supplier.cnpj)

        supplier.name = name
        supplier.address = address
        supplier.email = email
        supplier.phone = phone
        supplier.cnpj = cnpj
        supplier.save()

        return JsonResponse({'id': supplier.id})

    elif request.method == 'DELETE':
        supplier.delete()
        return JsonResponse({'result': True})