from django.urls import path
from .views import supplier_list, supplier_detail

urlpatterns = [
    path('', supplier_list, name='supplier_list'),
    path('<int:pk>/', supplier_detail, name='supplier_detail'),
]