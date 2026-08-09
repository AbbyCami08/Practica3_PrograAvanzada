using Practica3.EF;
using Practica3.Models;
using System.Collections.Generic;
using System.Linq;

namespace Practica3.Services
{
    public class PrincipalService
    {
        public List<ConsultaModel> ConsultarProductos()
        {
            using (var context = new PracticaS13Entities())
            {
                var resultado = context.SP_ConsultarProductos()
                    .Select(x => new ConsultaModel
                    {
                        IdCompra = x.Id_Compra,
                        Descripcion = x.Descripcion,
                        Precio = x.Precio,
                        Saldo = x.Saldo,
                        Estado = x.Estado
                    })
                    .ToList();

                return resultado;
            }
        }
    }
}