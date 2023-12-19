<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DCAAnalyzerServiceWeb.aspx.cs" Inherits="DCAAnalyzerServiceWeb.DCAAnalyzerServiceWeb" %>

<%@ Register assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" namespace="System.Web.UI.DataVisualization.Charting" tagprefix="asp" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Kanit&display=swap');

    * {
        font-family: 'Kanit', sans-serif;
    }

    body {
        background-color: #f2f2f2;
        margin: 0;
        padding: 0;
    }

    #form1 {
        text-align: center;
    }

    .container {
        margin-top: 20px;
    }

    .btn {
        background-color: #007bff;
        color: #fff;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    .btn:hover {
        background-color: #0056b3;
    }

    .result-label {
        font-size: 18px;
        font-weight: bold;
        color: #007bff; /* Blue color for result labels */
    }

    .chart-container {
        display: flex;
        justify-content: center;
    }

    .chart {
        margin: 20px;
    }

    /* Style the dropdown list */
    #DropDownList1 {
        background-color: #f8f8f8;
        padding: 5px;
    }

    /* Style the text input */
    #txtMonthlyDCA {
        padding: 5px;
        border: 1px solid #ccc;
    }

    .center-table {
        margin: 0 auto; /* Center the table horizontally */
        text-align: center; /* Center the content within the table */
    }

    /* Style the table cells */
    .auto-style2 {
        width: 33%; /* Adjust the width as needed */
        padding: 10px;
        background-color: #f8f8f8;
        border: 1px solid #ccc;
    }

    .auto-style3 {
        width: 33%; /* Adjust the width as needed */
        padding: 10px;
        background-color: #f8f8f8;
        border: 1px solid #ccc;
    }

    .auto-style4 {
        width: 33%; /* Adjust the width as needed */
        padding: 5px;
        /*border: 1px solid #ccc;*/
    }

</style>

</head>
<body style="background-color: #FFFACD;">
    <form id="form1" runat="server">
        <div>
            <br />
            <h1>ผลการลงทุนแบบ DCA (Dollar Cost Averaging) 10 ปี ย้อนหลัง</h1>
            <table class="center-table">
                <tr>
                    <td class="auto-style4">เลือกหุ้น</td>
                    <td class="auto-style4">

                        <asp:DropDownList ID="DropDownList1" runat="server">
                            <asp:ListItem>CPALL</asp:ListItem>
                            <asp:ListItem>PTT</asp:ListItem>
                            <asp:ListItem>BANPU</asp:ListItem>
                            <asp:ListItem>BTS</asp:ListItem>
                            <asp:ListItem>AOT</asp:ListItem>
                            <asp:ListItem>KTB</asp:ListItem>
                            <asp:ListItem>TDEX</asp:ListItem>
                            <asp:ListItem>EA</asp:ListItem>
                        </asp:DropDownList>

                    </td>
                    <td class="auto-style4">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="auto-style4">ลงทุนเดือนละ</td>
                        <td class="auto-style4">

                            <asp:TextBox ID="txtMonthlyDCA" runat="server"></asp:TextBox>

                        </td>
                        <td class="auto-style4">บาท</td>
                    </tr>
            </table>

            <asp:Button ID="ButtonCalculate" runat="server" OnClick="ButtonCalculate_Click" Text="คำนวณ" Height="40px" Width="130px" />
            <br />
            <br />
            <table class="center-table">
                <tr>
                    <td class="auto-style4">เงินลงทุนทั้งหมด</td>
                    <td class="auto-style4">
                        <asp:Label ID="lblRultDCAInitial" runat="server">0</asp:Label>
                    </td>
                    <td class="auto-style4">บาท</td>
                </tr>
                <tr>
                    <td class="auto-style4">ราคาเฉลี่ยต่อหุ้น</td>
                    <td class="auto-style4">
                        <asp:Label ID="lblResultDCAaverageCost" runat="server">0</asp:Label>
                    </td>
                    <td class="auto-style4">บาท</td>
                </tr>
                <tr>
                    <td class="auto-style4">จำนวนหุ้น</td>
                    <td class="auto-style4">
                        <asp:Label ID="lblResulttotalShares" runat="server">0</asp:Label>
                    </td>
                    <td class="auto-style4">หน่วย</td>
                </tr>
                <tr>
                    <td class="auto-style4">มูลค่าล่าสุด</td>
                    <td class="auto-style4">
                        <asp:Label ID="lblResultDCAcurrentInvestment" runat="server">0</asp:Label>
                    </td>
                    <td class="auto-style4">บาท</td>
                </tr>
                <tr>
                    <td class="auto-style4">ผลการตอบแทน</td>
                    <td class="auto-style4">
                        <asp:Label ID="lblResultDCAreturns" runat="server">0</asp:Label>
                    </td>
                    <td class="auto-style4">บาท</td>
                </tr>
                <tr>
                    <td class="auto-style4">ตอบแทน</td>
                    <td class="auto-style4">
            <asp:Label ID="lblResultDCAreturnsPercentage" runat="server" Text="0"></asp:Label>
                    </td>
                    <td class="auto-style4">%</td>
                </tr>
            </table>
            <br />
            <table class="center-table">
                <tr>
                    <td class="auto-style3">กราฟมูลค่าเงินในการลงทุน</td>
                    <td class="auto-style2">กราฟผลการตอบแทน</td>
                    <td class="auto-style3">กราฟราคาหุ้น</td>
                </tr>
                <tr>
                    <td class="auto-style2">
                        <asp:Chart ID="chartReturns" runat="server" Width="434px" Height="275px">
                            <Series>
                                <asp:Series Name="Returns" ChartType="Line" XValueMember="Month" YValueMembers="Returns">
                                </asp:Series>
                            </Series>
                            <ChartAreas>
                                <asp:ChartArea Name="ChartArea1">
                                    <AxisX Title="เดือน">
                                    </AxisX>
                                    <AxisY Title="บาท">
                                    </AxisY>
                                </asp:ChartArea>
                            </ChartAreas>
                        </asp:Chart>
                    </td>
                    <td class="auto-style3">
                        <asp:Chart ID="chartCurrentInvestment" runat="server" Width="434px" Height="275px">
                            <Series>
                                <asp:Series Name="PortfolioValue" ChartType="Line" XValueMember="Month" YValueMembers="Value">
                                </asp:Series>
                            </Series>
                            <ChartAreas>
                                <asp:ChartArea Name="ChartArea3">
                                    <AxisX Title="เดือน">
                                    </AxisX>
                                    <AxisY Title="บาท">
                                    </AxisY>
                                </asp:ChartArea>
                            </ChartAreas>
                        </asp:Chart>
                    </td>
                    <td class="auto-style3">
                        <asp:Chart ID="chartStockPrice" runat="server" Width="434px" Height="275px">
                            <Series>
                                <asp:Series Name="StockPrice" ChartType="Line" XValueMember="Month" YValueMembers="Price">
                                </asp:Series>
                            </Series>
                            <ChartAreas>
                                <asp:ChartArea Name="ChartArea2">
                                    <AxisX Title="เดือน">
                                    </AxisX>
                                    <AxisY Title="บาท">
                                    </AxisY>
                                </asp:ChartArea>
                            </ChartAreas>
                        </asp:Chart>
                    </td>
                </tr>
            </table>
            <br />
            &nbsp;&nbsp;&nbsp;&nbsp;
            </div>
    </form>
</body>
</html>
