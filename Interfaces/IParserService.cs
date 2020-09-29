using AdaptWebParser.Models;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AdaptWebParser.Interfaces
{
    public interface IParserService
    {
        void Config();
        List<AdaptOutputModel> ParseInput(IFormFile file);

    }
}
