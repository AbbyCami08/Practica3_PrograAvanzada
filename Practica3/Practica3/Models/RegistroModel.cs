using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Practica3.Models
{
    public class ComprasPendienteItem
    {
        public long IdCompra { get; set; }
        public string Descripcion { get; set; }
        public decimal Saldo { get; set; }
    }

    public class RegistroModel
    {
        public List<ComprasPendienteItem> ComprasPendientes { get; set; }
    }
}