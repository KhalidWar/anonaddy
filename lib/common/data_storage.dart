abstract class DataStorage {
  const DataStorage();
  Future saveData(Map<String, dynamic> data);
  Future loadData();
}
