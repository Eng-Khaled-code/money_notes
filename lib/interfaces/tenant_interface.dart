abstract class TenantInterface {
    Future<bool> addTenant({required Map<String, dynamic> data});
    Future<bool> updateTenant({required Map<String, dynamic> data});
    Future<bool> deleteTenant({required String tenantId});
    Future<void> loadTenants();
    Future<void> updateFlatValue({required String tenantId,required double flatValue,required double additionValue,required int additionMonth});
    Future<void> loadFlatValue({required String tenantId});


    }
