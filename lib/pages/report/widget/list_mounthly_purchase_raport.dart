import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir_mobile/helper/format_cuurency.dart';
import 'package:kasir_mobile/pages/report/daily_report.dart';
import 'package:kasir_mobile/provider/get_monthly_purchase_provider.dart';

class ListMounthlyPurchaseReport extends StatelessWidget {
  final String typeRaport;
  final String date;

  const ListMounthlyPurchaseReport({
    super.key,
    required this.typeRaport,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetMonthlyPurchase.getMonthlyTransaction(date),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available'));
        }

        final apiResponse = snapshot.data!;
        if (!apiResponse.status || apiResponse.data == null) {
          return Center(child: Text(apiResponse.message));
        }

        final monthlyData = apiResponse.data!;

        return CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                _buildSummarySection(monthlyData),
                _buildTransactionList(context, monthlyData),
              ]),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummarySection(dynamic monthlyData) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              "Jml Transaksi",
              "${monthlyData.dailyData.length}",
            ),
          ),
          Expanded(
            child: _buildSummaryCard(
              "Total Pengeluaran",
              convertToIdr(monthlyData.totalExpenditure),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff076A68),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: TextButton(
        onPressed: null,
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context, dynamic monthlyData) {
    return Container(
      margin: const EdgeInsets.only(top: 26),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: monthlyData.dailyData.length,
        itemBuilder: (context, index) =>
            _buildTransactionItem(context, monthlyData.dailyData[index]),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, dynamic dailyData) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Color(0xffDDDDDD)),
          top: BorderSide(width: 1, color: Color(0xffDDDDDD)),
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 5),
      height: MediaQuery.of(context).size.height * 0.14,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDateSection(dailyData),
          _buildExpenditureSection(dailyData.expenditure),
          _buildActionsSection(context, dailyData.date),
        ],
      ),
    );
  }

  Widget _buildDateSection(dynamic dailyData) {
    final DateTime parsedDate = DateTime.parse(date);
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                DateFormat('dd').format(parsedDate),
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.only(left: 3),
                child: Column(
                  children: [
                    Text(
                      DateFormat('MM').format(parsedDate),
                      style: const TextStyle(fontSize: 10),
                    ),
                    Text(
                      DateFormat('yyyy').format(parsedDate),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            "${dailyData.totalTransaction} Transaksi",
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _buildExpenditureSection(double expenditure) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Pengeluaran"),
                Text(
                  convertToIdr(expenditure),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context, String date) {
    return Expanded(
      flex: -1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _navigateToDailyReport(context, date),
              child: const Icon(Icons.navigate_next_outlined),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDailyReport(BuildContext context, String date) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DailyReport(
          typeRaport: typeRaport,
          date: date,
        ),
      ),
    );
  }
}
