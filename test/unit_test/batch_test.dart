import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management_starter/features/batch/domain/entity/batch_entity.dart';
import 'package:student_management_starter/features/batch/domain/usecases/batch_usecase.dart';
import 'package:student_management_starter/features/batch/presentation/viewmodel/batch_viewmodel.dart';

import 'batch_test.mocks.dart';
import 'test_data/batch_test_data.dart';

@GenerateNiceMocks([
  MockSpec<BatchUseCase>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late BatchUseCase mockBatchUseCase;
  late List<BatchEntity> lstBatches;
  setUp(
    () {
      mockBatchUseCase = MockBatchUseCase();
      lstBatches = BatchTestData.getBatchTestData();
      container = ProviderContainer(
        overrides: [
          batchViewmodelProvider.overrideWith(
            (ref) => BatchViewmodel(mockBatchUseCase),
          )
        ],
      );
    },
  );

  // Test initial state
  test('check batch initial state', () async {
    when(mockBatchUseCase.getAllBatches())
        .thenAnswer((_) => Future.value(Right(lstBatches)));

    // Get all batches
    await container.read(batchViewmodelProvider.notifier).getAllBatches();

    // Store the state
    final batchState = container.read(batchViewmodelProvider);

    // Check the state
    expect(batchState.isLoading, false);
    expect(batchState.error, isNull);
    expect(batchState.lstBatches, isNotEmpty);
  });

  // Remove snackbar code from viewmodel vefore running this code
  test('add batch entity and return true if successfully added', () async {
    when(mockBatchUseCase.getAllBatches())
        .thenAnswer((_) => Future.value(Right(lstBatches)));

    when(mockBatchUseCase.addBatch(lstBatches[0]))
        .thenAnswer((_) => Future.value(const Right(true)));

    await container
        .read(batchViewmodelProvider.notifier)
        .addBatch(lstBatches[0]);

    final batchState = container.read(batchViewmodelProvider);

    expect(batchState.error, isNull);
  });

  tearDown(() {
    container.dispose();
  });
}


