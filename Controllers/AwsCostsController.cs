using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Amazon.CostExplorer;
using Amazon.CostExplorer.Model;

namespace TodoApi.Controllers
{
    [Route("api/AwsCosts")]
    [ApiController]
    public class AwsCostsController : ControllerBase
    {
        private readonly IAmazonCostExplorer _client;
        public AwsCostsController(IAmazonCostExplorer costExplorer)
        {
            _client = costExplorer;
        }

        [HttpGet()]
        public async Task<ActionResult<AwsCosts>> GetCurrentMonthsCostsAsync()
        {
            // For testing and avoiding AWS cost of calling IAmazonCostExplorer.GetCostAndUsageRequest
            var thisEntireMonth = ConvertToDateIntervalForEntireMonth(DateTime.UtcNow);
            return new AwsCosts
            {
                CurrentMonthToDateBalanceAmount = thisEntireMonth.Start, //"777.77",
                CurrentMonthToDateBalanceCurrency = thisEntireMonth.End
            };

            var response = await _client.GetCostAndUsageAsync(
                new GetCostAndUsageRequest() {
                    Granularity = Granularity.MONTHLY,
                    TimePeriod = ConvertToDateIntervalForEntireMonth(DateTime.UtcNow),
                    Filter = new Expression()
                    {
                        Dimensions = new DimensionValues
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
        
        private DateInterval ConvertToDateIntervalForEntireMonth(DateTime dateTime)
        {
            var firstDayOfMonth = new DateTime(dateTime.Year, dateTime.Month, 1);
            return new DateInterval()
            {
                Start = firstDayOfMonth.ToString("yyyy-MM-01"),
                End = firstDayOfMonth.AddMonths(1).ToString("yyyy-MM-01")
            };
        }

    }
}
