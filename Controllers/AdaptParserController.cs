using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AdaptWebParser.Interfaces;
using AdaptWebParser.Models;
using AdaptWebParser.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;


namespace AdaptWebParser.Controllers
{
    [Route("api")]
    [Produces("application/json")]
    [ApiController]
    public class AdaptParserController : ControllerBase
    {
        private IParserService _parserService;

        public AdaptParserController(IParserService parserService)
        {
            _parserService = parserService;
        }

        [HttpPost]
        [Route("parse")]
        public List<AdaptOutputModel> ParseAdapt()
        {
            IFormFile zipFile = Request.Form.Files[0];
            _parserService.Config();
            return _parserService.ParseInput(zipFile);
        }
    }
}
