using Practica3.Models;
using Practica3.Services;
using System.Web.Mvc;

namespace Practica3.Controllers
{
    public class HomeController : Controller
    {
        private readonly PrincipalService _principalService;

        public HomeController()
        {
            _principalService = new PrincipalService();
        }

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Registro()
        {
            var model = new RegistroModel
            {
                ComprasPendientes = _principalService.ConsultarComprasPendientes()
            };
            return View(model);
        }

        [HttpGet]
        public JsonResult ObtenerSaldo(long idCompra)
        {
            var resultado = _principalService.ConsultarSaldo(idCompra);
            return Json(new { saldo = resultado?.Saldo }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public ActionResult Registro(long idCompra, decimal abono)
        {
            var resultado = _principalService.RegistrarAbono(idCompra, abono);

            if (resultado.Resultado != 1)
            {
                ModelState.AddModelError("", resultado.Mensaje);
                var model = new RegistroModel { ComprasPendientes = _principalService.ConsultarComprasPendientes() };
                return View(model);
            }

            return RedirectToAction("Consulta");
        }

        public ActionResult Consulta()
        {
            var productos = _principalService.ConsultarProductos();

            return View(productos);
        }
    }
}