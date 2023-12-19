using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;

namespace DCAAnalyzerService
{
    /// <summary>
    /// Summary description for DCAAnalyzerService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class DCAAnalyzerService : System.Web.Services.WebService
    {
        //คำนวณหาเงินทุน
        [WebMethod]
        public double CalculateInitialInvestment(double monthlyDCA, double month)
        {
            return monthlyDCA*month;
        }

        //คำนวณหาจำนวนหุ้นที่ซื้อ
        [WebMethod]
        public int CalculateSharesPurchased(double monthlyDCA, double price)
        {
            return (int)(monthlyDCA / price);
        }

        //คำนวณมูลค่าหุ้นที่ถืออยู่
        [WebMethod]
        public double CalculateCurrentInvestment(double totalShares, double lastprice)
        {
            return totalShares * lastprice;
        }

        //คำนวณค่าเฉลี่ยราคาต่อหุ้น
        [WebMethod]
        public double CalculateAverageCost(double totalInvestment, double totalShares)
        {
            return totalInvestment / totalShares;
        }

        //คำนวณหาผลตอบแทน DCA
        [WebMethod]
        public double CalculateReturnsDCA(double currentInvestment, double monthlyDCA, int month)
        {
            return currentInvestment - (monthlyDCA * month);
        }

        //คำนวณหาผลตอบแทน
        [WebMethod]
        public double CalculateReturns(double currentInvestment, double initialInvestment)
        {
            return currentInvestment - initialInvestment;
        }

        //คำนวณหาผลตอบแทน %
        [WebMethod]
        public double CalculateReturnsPercentage(double returns, double initialInvestment)
        {
            return (returns / initialInvestment) * 100;
        }





    }
}
