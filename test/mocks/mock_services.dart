import 'package:mockito/mockito.dart';
import 'package:smart_counter/services/api_service.dart';
import 'package:smart_counter/services/storage_service.dart';
import 'package:smart_counter/utils/logger.dart';

class MockLogger extends Mock implements AppLogger {}

class MockApiService extends Mock implements ApiService {}

class MockStorageService extends Mock implements StorageService {}