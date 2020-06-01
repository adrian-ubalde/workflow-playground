using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TodoApi.Models;

namespace TodoApi.Controllers
{
    [Route("api/AwsCosts")]
    [ApiController]
    public class AwsCostsController : ControllerBase
    {
        public AwsCostsController()
        {
        }

        [HttpGet()]
        public ActionResult<AwsCosts> GetCurrentMonthsCosts()
        {
            return new AwsCosts { CurrentMonthCost = 1.00M };
        }
    }
}
