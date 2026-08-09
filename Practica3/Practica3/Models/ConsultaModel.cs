using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Practica3.Models
{
    public class ConsultaModel
    {
        public long IdCompra { get; set; }

        public string Descripcion { get; set; }

        public decimal Precio { get; set; }

        public decimal Saldo { get; set; }

        public string Estado { get; set; }
    }
}