using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Amazon.CostExplorer;

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
        public async Task<ActionResult<AwsCosts>> GetCurrentMonthsCostsAsync()
        {
            // var client = new AmazonCostExplorerClient(new Amazon.Runtime.BasicAWSCredentials("test", "test"), Amazon.RegionEndpoint.APSoutheast2);
            var client = new AmazonCostExplorerClient();
            var response = await client.GetCostAndUsageAsync(
                new Amazon.CostExplorer.Model.GetCostAndUsageRequest() {
                    Granularity = Granularity.MONTHLY,
                    TimePeriod = new Amazon.CostExplorer.Model.DateInterval()
                    {
                        Start = "2020-07-01",
                        End = "2020-08-01"
                    },
                    Filter = new Amazon.CostExplorer.Model.Expression()
                    {
                        Dimensions = new Amazon.CostExplorer.Model.DimensionValues
                        { 
                            Key = "LINKED_ACCOUNT", 
                            Values = new List<string> { "470344065667" }
                            // TODO - Use get-access-key-info api?
                        }
                    },
                    Metrics = new List<string>
                    {
                        "BlendedCost",
                        "UnblendedCost",
                        "UsageQuantity",
                        "AmortizedCost",
                        "NetAmortizedCost",
                        "NetUnblendedCost",
                        "NormalizedUsageAmount"
                    }
                });

            return new AwsCosts
            {
                CurrentMonthToDateBalanceAmount = response.ResultsByTime[0].Total["BlendedCost"].Amount,
                CurrentMonthToDateBalanceCurrency = response.ResultsByTime[0].Total["BlendedCost"].Unit
            };
        }
    }
}
