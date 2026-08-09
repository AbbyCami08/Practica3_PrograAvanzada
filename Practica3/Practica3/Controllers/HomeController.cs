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
            return View();
        }

        public ActionResult Consulta()
        {
            var productos = _principalService.ConsultarProductos();

            return View(productos);
        }
    }
}