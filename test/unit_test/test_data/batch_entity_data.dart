import 'package:student_management_starter/features/batch/domain/entity/batch_entity.dart';

class BatchTestData {
  BatchTestData._();

  static List<BatchEntity> getBatchTestData() {
    List<BatchEntity> lstBatches = [
      const BatchEntity(
        batchId: "20df4a89-6c95-44d0-bebf-0980c33bd49f",
        batchName: "30-A",
      ),
      const BatchEntity(
        batchId: "278ce8eb-223c-4c4b-85ba-17dbc83f27ba",
        batchName: "30-B",
      ),
      const BatchEntity(
        batchId: "87152c66-5a61-4aba-b303-c99c31bb3a3b",
        batchName: "31-A",
      ),
      const BatchEntity(
        batchId: "d9d517d8-d964-4106-91eb-75e38ebc3b31",
        batchName: "31-B",
      ),
    ];

    return lstBatches;
  }
}


