from django.test import TestCase
from models import Customer

# Create your tests here.

class CustomerModelTestCase(TestCase):
    def setUp(self):
        self.customer = Customer.objects.create(
            name='John Doe',
            address='123 Main St',
            phone='555-1234',
            email='john.doe@example.com',
            cpf = '123.456.789-10'
        )

    def test_customer_creation(self):
        self.assertEqual(str(self.customer), 'John Doe')
        self.assertEqual(self.customer.name, 'John Doe')
        self.assertEqual(self.customer.address, '123 Main St')
        self.assertEqual(self.customer.phone, '555-1234')
        self.assertEqual(self.customer.email, 'john.doe@example.com')
        self.assertEqual(self.customer.cpf, '123.456.789-10')