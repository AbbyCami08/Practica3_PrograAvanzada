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

        public List<ComprasPendienteItem> ConsultarComprasPendientes()
        {
            using (var context = new PracticaS13Entities())
            {
                return context.SP_ConsultarComprasPendientes()
                    .Select(x => new ComprasPendienteItem
                    {
                        IdCompra = x.Id_Compra,
                        Descripcion = x.Descripcion,
                        Saldo = x.Saldo
                    })
                    .ToList();
            }
        }

        public SP_ConsultarSaldo_Result ConsultarSaldo(long idCompra)
        {
            using (var context = new PracticaS13Entities())
            {
                return context.SP_ConsultarSaldo(idCompra).FirstOrDefault();
            }
        }

        public SP_RegistrarAbono_Result RegistrarAbono(long idCompra, decimal monto)
        {
            using (var context = new PracticaS13Entities())
            {
                return context.SP_RegistrarAbono(idCompra, monto).FirstOrDefault();
            }
        }
    }
}