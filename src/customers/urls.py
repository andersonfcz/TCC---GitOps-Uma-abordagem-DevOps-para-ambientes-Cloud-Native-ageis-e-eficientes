from django.urls import path
from .views import customer_list, customer_detail

urlpatterns = [
    path('', customer_list, name='contact_list'),
    path('<int:pk>/', customer_detail, name='contact_detail'),
]