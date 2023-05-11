SELECT '1234567' id, T1.*
  FROM TABLE(gzk_example_3.f_get_parking_charge_data('710000003')) T1