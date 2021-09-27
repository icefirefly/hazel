class NormalizationHelper {
  ///********MATLAB calcluations**********
  /// const GAS_RESISTANCE_RANGE = single([170, 103e6]);
  ///
  /// var  p = polyfit(log(BsecConst.GAS_RESISTANCE_RANGE), [0 1], 1);
  ///  normalizedGasValue = polyval(p, log(obj.inputGas));
  ///  ********************************************
  ///
  ///******** Simplified calculations is : **********************
  ///
  /// p = polyfit(log(single([170, 103e6])), [0 1], 1) = [ 0.0751  , -0.3857]
  ///
  /// And normalized gas resistance will be like this,
  /// normalized_gas(1) = p(1)*gas_res(1) + p(2)
  /// normalized_gas(2) = p(1)*gas_res(2) + p(2)
  ///
  ///
  /// *********************************************

  static const POLY_FIT_1 = 0.0751;
  static const POLY_FIT_2 = - 0.3857;

  static double getNormalizedGas(double gasResistance) {
    return (POLY_FIT_1 * gasResistance + POLY_FIT_2);
  }
}
