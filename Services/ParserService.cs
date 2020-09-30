using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AgGateway.ADAPT.PluginManager;
using AgGateway.ADAPT.ApplicationDataModel.ADM;
using AgGateway.ADAPT.ApplicationDataModel.Common;
using AgGateway.ADAPT.ApplicationDataModel.Products;
using AgGateway.ADAPT.ApplicationDataModel.Logistics;
using AgGateway.ADAPT.ApplicationDataModel.Equipment;
using AgGateway.ADAPT.ApplicationDataModel.LoggedData;
using AgGateway.ADAPT.ApplicationDataModel.Representations;
using AgGateway.ADAPT.Representation.UnitSystem.ExtensionMethods;
using UnitSystem = AgGateway.ADAPT.Representation.UnitSystem;
using Ionic.Zip;
using System.IO;
using System.Xml.Serialization;
using AdaptWebParser.Models;
using AdaptWebParser.Interfaces;
using Microsoft.AspNetCore.Http;
using System.Text;
using System.IO.Compression;

namespace AdaptWebParser.Services
{
    public class ParserService : IParserService
    {
        protected static IPlugin plugin = null;
        protected static DirectoryInfo tempDir = null;

        public void Config()
        {
            //use the below to test locally
            //string path = Path.Combine(Environment.CurrentDirectory, @"AdaptPlugin\");
            //PluginFactory factory = new PluginFactory(path);
            PluginFactory factory = new PluginFactory("/app/AdaptPlugin/");

            plugin = factory.GetPlugin("ClimateADAPT");
            plugin.Initialize();
            tempDir = CreateTempDir();
        }
        public List<AdaptOutputModel> ParseInput(IFormFile file)
        {
            List<AdaptOutputModel> result = new List<AdaptOutputModel>();
            Unzip(file, tempDir);
            IList<ApplicationDataModel> admModels = plugin.Import(tempDir.FullName);
            foreach (ApplicationDataModel adm in admModels)
            {
                AdaptOutputModel model = new AdaptOutputModel();
                if (adm.Catalog.Crops.Count > 0)
                {
                    foreach (Crop crop in adm.Catalog.Crops)
                    {
                        model.Crop_Name.Add(crop.Name);
                    }
                }
                if (adm.Catalog.Products.Count > 0)
                {
                    foreach (Product product in adm.Catalog.Products)
                    {
                        model.Crop_Variety_Name.Add(product.Description);
                    }
                }
                result.Add(model);
            }
            tempDir.Delete(true);
            return result;
        }

        public static DirectoryInfo CreateTempDir()
        {
            string path = Path.GetTempPath() + "TempFiles";
            DirectoryInfo tempDir = new DirectoryInfo(path);
            tempDir.Create();
            tempDir.Refresh();
            Console.Error.WriteLine(tempDir.FullName);
            return tempDir;
        }

        public static void Unzip(IFormFile zipfile, DirectoryInfo tempDir)
        {
            Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
            using (ZipArchive archive = new ZipArchive(zipfile.OpenReadStream(), ZipArchiveMode.Read)) {
                archive.ExtractToDirectory(tempDir.FullName);
            }
        }

    }
}
