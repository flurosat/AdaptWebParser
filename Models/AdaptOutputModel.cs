using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AdaptWebParser.Models
{
    public class AdaptOutputModel
    {
        public AdaptOutputModel()
        {
            Crop_Name = new List<string>();
            Crop_Variety_Name = new List<string>();
        }
        public List<string> Crop_Name { get; set; }

        public List<string> Crop_Variety_Name { get; set; }
    }
}
