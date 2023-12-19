using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace DCAAnalyzerServiceWeb
{
    public partial class DCAAnalyzerServiceWeb : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ButtonCalculate_Click(object sender, EventArgs e)
        {
            DCAAnalyzerService.DCAAnalyzerService DCAAnalyzerService = new DCAAnalyzerService.DCAAnalyzerService();

            // ดึงชื่อหุ้นจากการเลือก
            string stockName = DropDownList1.Text;
            // ดึงจำนวนการลงทุนต่อเดือน
            double monthlyDCA = Convert.ToDouble(txtMonthlyDCA.Text);
            // โหลดไฟล์ xml จากหุ้นที่เลือก
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.Load(Server.MapPath("/Data/" + stockName + ".xml"));

            XmlNodeList stockNodes = xmlDoc.SelectNodes("/stock_data/stock");

            // กราฟผลตอบแทน
            DataTable chartData = new DataTable();
            chartData.Columns.Add("Month", typeof(int));
            chartData.Columns.Add("Returns", typeof(double));
            // กราฟราคาหุ้น
            DataTable chartData2 = new DataTable();
            chartData2.Columns.Add("Month", typeof(int));
            chartData2.Columns.Add("Price", typeof(double));
            // กราฟราคามูลค่าในการลงทุน
            DataTable chartData3 = new DataTable();
            chartData3.Columns.Add("Month", typeof(int));
            chartData3.Columns.Add("Value", typeof(double));

            // ตัวแปรผลลัพธ์ต่าง
            double totalInvestment = 0.0;
            double totalShares = 0.0;
            double averageCost = 0.0;
            double currentInvestment = 0.0;

            int month = 0;

            foreach (XmlNode stockNode in stockNodes)
            {
                double price = Convert.ToDouble(stockNode.SelectSingleNode("price").InnerText);
                int sharesPurchased = DCAAnalyzerService.CalculateSharesPurchased(monthlyDCA, price);
                totalInvestment += monthlyDCA;
                totalShares += sharesPurchased;
                currentInvestment = DCAAnalyzerService.CalculateCurrentInvestment(totalShares, price);
                averageCost = DCAAnalyzerService.CalculateAverageCost(totalInvestment, totalShares);

                month++;

                chartData3.Rows.Add(month, DCAAnalyzerService.CalculateReturnsDCA(currentInvestment, monthlyDCA, month));
                chartData.Rows.Add(month, currentInvestment);
                chartData2.Rows.Add(month, price);
            }

            double initialInvestment = DCAAnalyzerService.CalculateInitialInvestment(monthlyDCA, stockNodes.Count);
            double returns = DCAAnalyzerService.CalculateReturns(currentInvestment, initialInvestment);
            double returnsPercentage = DCAAnalyzerService.CalculateReturnsPercentage(returns, initialInvestment);

            DisplayResults(initialInvestment, averageCost, totalShares, currentInvestment, returns, returnsPercentage);
            BindChartDataToChartControls(chartData, chartData2, chartData3);
        }

        private void DisplayResults(double initialInvestment, double averageCost, double totalShares, double currentInvestment, double returns, double returnsPercentage)
        {
            lblRultDCAInitial.Text = $"{initialInvestment:F2}";
            lblResultDCAaverageCost.Text = $"{averageCost:F2}";
            lblResulttotalShares.Text = $"{totalShares:F2}";
            lblResultDCAcurrentInvestment.Text = $"{currentInvestment:F2}";
            lblResultDCAreturns.Text = $"{returns:F2}";
            lblResultDCAreturnsPercentage.Text = $"{returnsPercentage:F2}";
        }

        private void BindChartDataToChartControls(DataTable chartData, DataTable chartData2, DataTable chartData3)
        {
            chartReturns.DataSource = chartData;
            chartReturns.DataBind();

            chartStockPrice.DataSource = chartData2;
            chartStockPrice.DataBind();


            chartCurrentInvestment.DataSource = chartData3;
            chartStockPrice.DataBind();
        }
    }
}