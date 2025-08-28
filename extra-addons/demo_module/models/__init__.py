from odoo import api, fields, models
from odoo.exceptions import ValidationError


class DemoModel(models.Model):
    _name = 'demo.model'
    _description = 'Modelo de Demostración'
    _order = 'name'

    name = fields.Char(
        string='Nombre',
        required=True,
        help='Nombre del registro de demostración'
    )
    
    description = fields.Text(
        string='Descripción',
        help='Descripción detallada del registro'
    )
    
    active = fields.Boolean(
        string='Activo',
        default=True,
        help='Indica si el registro está activo'
    )
    
    priority = fields.Selection(
        selection=[
            ('low', 'Baja'),
            ('medium', 'Media'),
            ('high', 'Alta'),
        ],
        string='Prioridad',
        default='medium',
        help='Prioridad del registro'
    )
    
    date_created = fields.Datetime(
        string='Fecha de Creación',
        default=fields.Datetime.now,
        readonly=True,
        help='Fecha y hora de creación del registro'
    )
    
    value = fields.Float(
        string='Valor',
        digits=(16, 2),
        help='Valor numérico del registro'
    )
    
    @api.depends('name', 'description')
    def _compute_display_name(self):
        for record in self:
            if record.description:
                display_name = f"{record.name} - {record.description[:50]}"
                record.display_name = display_name
            else:
                record.display_name = record.name
    
    @api.constrains('value')
    def _check_value(self):
        for record in self:
            if record.value < 0:
                raise ValidationError("El valor no puede ser negativo")
    
    def action_activate(self):
        """Activa el registro"""
        self.active = True
        return True
    
    def action_deactivate(self):
        """Desactiva el registro"""
        self.active = False
        return True
