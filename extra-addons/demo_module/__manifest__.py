{
    'name': 'Demo Module',
    'version': '18.0.1.0.0',
    'category': 'Tools',
    'summary': 'Módulo de demostración para Odoo 18',
    'description': """
        Este es un módulo de demostración para probar el entorno de desarrollo de Odoo 18.
        
        Características:
        - Modelo de ejemplo
        - Vista de formulario
        - Vista de lista
        - Menú en aplicaciones
    """,
    'author': 'Tu Nombre',
    'website': 'https://tu-website.com',
    'depends': ['base'],
    'data': [
        'security/ir.model.access.csv',
        'views/demo_views.xml',
        'views/menu_views.xml',
    ],
    'demo': [
        'demo/demo_data.xml',
    ],
    'installable': True,
    'application': True,
    'auto_install': False,
    'license': 'LGPL-3',
}
